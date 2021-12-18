class Api::V1::KeywordListsController < ApplicationController

    # GET /keywordlists
    # Fetch all keyword lists
    def index
        @keyword_list = KeywordList.all
        render json: @keyword_list
    end

end
