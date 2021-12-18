class Api::V1::UsersController < ApplicationController

    # GET /users
    # Fetch all Users
    def index
        @users = User.all
        render json: @users
    end

    # GET /users/:id
    # Find a User by id
    def show
        @user = User.find(params[:id])
        render json: @user
    end

    # POST /users
    # Create a new user
    def create
        @user = User.new(user_params)
        if @user.save
            render json: {
                messages: "sign up successfully",
                is_success: true,
                data: { user: @user}
            }, status: :created

        else
            render json: {
                messages: "sign up unsuccessfully",
                is_success: false,
                data: {}
            }, status: :unprocessable_entity
        end
    end

    ######## TESTING PURPOSE #######
    # POST /users/import
    # Importing 1,000 users in the database for the testing purpose
    def import
        users = []
        10000.times do |i|
            users << User.new(:email => "baek#{i}@gmail.com", :password => "123123")
        end
        User.import users
    end

    # PUT /users/:id
    # Update an existing user by id
    def update
        @user = User.find(params[:id])
        if @user.update(user_params)
            render json: {
                messages: "updated user successfully",
                is_success: true,
                data: { user: @user}
            }, status: :ok
        else
            render json: {
                messages: "updated user unsuccessfully",
                is_success: false,
                data: {}
            }, status: :unprocessable_entity
        end
    end

    # Delete /users/:id
    # Destroy a existing user by id
    # NOTE: Since Item and Subscription depend on User,
    # when User is destroyed then associated children(Item & Subscription) records
    # will be deleted as well
    def destroy
        @user = User.find(params[:id])
        if @user
            @user.destroy
            render json: {
                messages: "deleted user successfully",
                is_success: true,
                data: { user: @user}
            }, status: :ok
        else
            render json: {
                messages: "deleted user unsuccessfully",
                is_success: false,
                data: {}
            }, status: :unprocessable_entity
        end
    end

    private

    def user_params
        params.require(:user).permit(:email, :password)
    end

end
