class UsersController < ApplicationController
  before_action :authorized, only: :show

  def create
    user = User.create(user_params)
    if user.valid?
      #saves user id in the session hash
      session[:user_id] = user.id
      #return the user obj in json response
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    user = User.find_by(id: session[:user_id])
    render json: user
  end

  private
  def authorized
    return render json: {error: "Not Authorized"}, status: :unauthorized unless session.include? :user_id
  end

  def user_params
    params.permit(:username, :password, :password_confirmation)
  end

end
