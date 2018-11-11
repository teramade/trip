class AccountController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    
    @user.nickname = params[:user][:nickname]
    @user.email = params[:user][:email]
    if params[:user][:icon]
      @user.icon.attach params[:user][:icon]
    end
    
    if @user.save
      flash[:notice] ="更新しました。"
    else
      flash[:alert] ="更新失敗しました。"
    end
    redirect_to("/account/edit")
    
  end

end
