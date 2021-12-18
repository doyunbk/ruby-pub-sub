class Api::V1::ItemsController < ApplicationController

    include Wisper::Publisher

    # GET /items
    # Fetch all items
    def index
        @items = Item.all
        render json: @items
    end

    # GET /items/:id
    # Find an existing item by id
    def show
        @item = Item.find(params[:id])
        render json: @item
    end

    # POST /items
    # When a new item is posted,
    # ItemListner is subscribed to 
    # check if any keyword in db is matching with an item's title or description.
    # If we find any match, then searching the Subscription db to 
    # find User and send the notifications to them by being handled asynchronously 
    def create
        @item = Item.new(item_params)
        @item.subscribe(ItemListener.new, async: true)
        @item.on(:item_create_successful) { 
            render json: {
                messages: "created item successfully",
                is_success: true,
                data: { item: @item}
            }, status: :created
        }
        @item.on(:item_create_failed) {
            render json: {
                messages: "created item unsuccessfully",
                is_success: false,
                data: {}
            }, status: :unprocessable_entity
        }
        @item.commit
    end

    # PUT /items/:id
    # Update an existing item by id
    def update
        @item = Item.find(params[:id])
        if @item.update(item_params)
            render json: {
                messages: "updated item successfully",
                is_success: true,
                data: { item: @item}
            }, status: :ok
        else
            render json: {
                messages: "updated item unsuccessfully",
                is_success: false,
                data: {}
            }, status: :unprocessable_entity
        end
    end

    # Delete /items/:id
    # Destroy an existing item by id
    def destroy
        @item = Item.find(params[:id])
        if @item
            @item.destroy
            render json: {
                messages: "deleted item successfully",
                is_success: true,
                data: { item: @item}
            }, status: :ok
        else
            render json: {
                messages: "deleted item unsuccessfully",
                is_success: false,
                data: {}
            }, status: :unprocessable_entity
        end
    end

    private

    def item_params
        params.require(:item).permit(:user_id, :title, :price, :description)
    end

end
