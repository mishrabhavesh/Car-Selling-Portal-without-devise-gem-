class TokensController < ApplicationController
  before_action :set_token, only: [ :edit, :update,:show ]
  before_action :require_login 
  before_action :require_seller, only: [:new,:create,:my_add,:index,:status_search] 
  before_action :require_admin ,only: [:edit,:update]

  include ApplicationHelper
  def index
    @mylist = current_user.tokens
      @tokens = Token.all
  end

  def my_add
    @post = my_post
  end

  def new
    @token = Token.new
  end

  def show
    flash[:notice] = "status updated successfully"
    redirect_to update_status_sellers_path
     
  end

  def edit
  end

  def create
    @token = CarCost.last.tokens.build(token_params)
    @token.user_id = current_user.id
    @token.seller_id = current_user.sellers.last.id

    if @token.save
      redirect_to root_path, notice: 'Your post is waiting for approval from admin.'
    else
      render :new
    end
  end

  def update
    
    if @token.update(token_params)
       flash[:notice] = 'Status of the post changed.'
       @my_add= @token.seller
      AdminMailer.admin_mail(@token.user.email,@token.status ).deliver
        ActionCable.server.broadcast "admin_approval_channel", my_post: render_to_string(partial: 'mylist',locals: { list: @token }), token_id: @token.id
        ActionCable.server.broadcast "my_post_channel", my_add: render_to_string(partial: 'posts/post',locals: { seller: @my_add }), seller_id: @my_add.id
      redirect_to root_path
    else
      render :edit
    end
  end

  def status_search
    @search = Token.all.where(id: params[:q])
  end
  

  private
    def set_token
      @token = Token.find(params[:id])
    end

    def token_params
      params.require(:token).permit(:phoneno, :user_id,:status,:seller_id,:appointment_date,:car_cost_id)
    end

    def post_render(post)
      render(partial: 'mylist',locals: { list: post } )
    end
end