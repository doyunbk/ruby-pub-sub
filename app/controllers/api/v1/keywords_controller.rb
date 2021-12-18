class Api::V1::KeywordsController < ApplicationController

    # GET /keywords
    # Fetch all keywords
    def index
        @keywords = Keyword.all
        render json: @keywords
    end

    # GET /keywords/:id
    # Find a keyword by id
    def show
        @keyword = Keyword.find(params[:id])
        if @keyword
            render json: @keyword
        else
            render json: {
                messages: "cannot find keyword",
                is_success: false,
                data: {}
            }, status: :unprocessable_entity
        end
    end

    # POST /keywords
    # If a given keyword is already registered,
    # then it will throw an error, otherwise,
    # create a new keyword with the name
    # When a keyword is created, it will be appending to 
    # KeywordList.keyword_list
    def create
        @keyword = Keyword.find_by(name: params[:name]).nil?
        if !@keyword
            render json: {
                messages: "you've already created this keyword",
                is_success: false,
                data: {}
            }, status: :unprocessable_entity
        end

        begin
            @keyword = KeywordCreator.call(params[:name])
            render json: {
                messages: "created keyword successfully",
                is_success: true,
                data: { keyword: @keyword}
            }, status: :created

        rescue => exception
            render json: {
                messages: "created keyword unsuccessfully",
                is_success: false,
                data: {}
            }, status: :unprocessable_entity
        end
    end

    ######## TESTING PURPOSE #######
    # POST /keywords/import
    # Import 10,000 keywords into database for the testing purpose
    # 5,000 keywords will be appending to KeywordList.keyword_list.
    # Once KeywordList.keyword_list is full then a new KeywordList.keyword_list
    # will be created for the next keywords
    def import
        keywords = []
        10000.times do |i|
            KeywordCreator.call("#{params[:name]} #{i}")
        end
    end


    # PUT /keywords/:id
    # Update an existing keyword by id
    def update
        @keyword = Keyword.find(params[:id])
        if @keyword.update(keyword_params)
            render json: {
                messages: "updated keyword successfully",
                is_success: true,
                data: { keyword: @keyword}
            }, status: :ok
        else
            render json: {
                messages: "updated keyword unsuccessfully",
                is_success: false,
                data: {}
            }, status: :unprocessable_entity
        end
    end

    # Delete /keywords/:id
    # Destroy an existing keyword by id
    # NOTE: Since Subscription depends on Keyword,
    # when Keyword is destroyed then associated child(Subscription) records
    # will be deleted as well
    def destroy
        @keyword = Keyword.find(params[:id])
        if @keyword
            @keyword.destroy
            render json: {
                messages: "deleted keyword successfully",
                is_success: true,
                data: { keyword: @keyword}
            }, status: :ok
        else
            render json: {
                messages: "deleted keyword unsuccessfully",
                is_success: false,
                data: {}
            }, status: :unprocessable_entity
        end
    end

    private

    def keyword_params
        params.require(:keyword).permit(:name)
    end

end
