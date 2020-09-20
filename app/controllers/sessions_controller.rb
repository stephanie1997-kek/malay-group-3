class SessionsController < ApplicationController
  def new; end

   def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      if user.activated?
        log_in user
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = t ".create_alert"
        redirect_to root_path
      end
    else
      flash.now[:danger] = t ".invalid_email" 
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
