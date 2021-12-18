class Api::V1::SubscriptionsController < ApplicationController


    # GET /subscriptions
    # Fetch all subscriptions
    def index
        @subscriptions = Subscription.all
        render json: @subscriptions
    end

    # GET /subscriptions/:id
    # Find a subscription by id
    def show
        @subscription = Subscription.find(params[:id])
        render json: @subscription
    end

    # POST /subscriptions
    # If there is a none-existing user_id or keyword_id,
    # it will throw an error, otherwise,
    # create a new subscription with user_id and keyword_id
    def create
        if !@keyword_id = Keyword.find(params[:keyword_id]) or !@user = User.find(params[:user_id])
            render json: {
                messages: "we cannot find keyword or user",
                is_success: false,
                data: {}
            }, status: :unprocessable_entity

        elsif !@subscription = Subscription.find_by(user_id: params[:user_id], keyword_id: params[:keyword_id]).nil?
            render json: {
                messages: "you've already subscribed to this keyword",
                is_success: false,
                data: {}
            }, status: :unprocessable_entity
        end
        
        @subscription = Subscription.new(subscription_params)
        if @subscription.save
            render json: {
                messages: "created subscription successfully",
                is_success: true,
                data: { subscription: @subscription}
            }, status: :created
        else
            render json: {
                messages: "created subscription unsuccessfully",
                is_success: false,
                data: {}
            }, status: :unprocessable_entity
        end
    end

    ######## TESTING PURPOSE #######
    # POST /subscriptions/import
    # 1000 Users(user_id = 1 to user_id = 1000) will be
    # subscribing to the last keyword('nike') in db
    def import
        subscription = []
        (1..1000).each do |i|
            subscription << Subscription.new(:user_id => "#{i}", :keyword_id => "10002")
        end
        Subscription.import subscription
    end


    # PUT /subscriptions/:id
    # Update an existing subscription by id
    def update
        @subscription = Subscription.find(params[:id])
        if @subscription.update(subscription_params)
            render json: {
                messages: "updated subscription successfully",
                is_success: true,
                data: { subscription: @subscription}
            }, status: :ok
        else
            render json: {
                messages: "updated subscription unsuccessfully",
                is_success: false,
                data: {}
            }, status: :unprocessable_entity
        end
    end

    # DELETE /subscriptions/:id
    # Destroy an existing subscription by id
    def destroy
        @subscription = Subscription.find(params[:id])
        if @subscription
            @subscription.destroy
            render json: {
                messages: "deleted subscription successfully",
                is_success: true,
                data: { subscription: @subscription}
            }, status: :ok
        else
            render json: {
                messages: "deleted subscription unsuccessfully",
                is_success: false,
                data: {}
            }, status: :unprocessable_entity
        end
    end

    private

    def subscription_params
        params.require(:subscription).permit(:user_id, :keyword_id)
    end

end
