class KeywordCreator < ApplicationService

    def initialize(name)
        @name = name
    end

    # When a keyword is created,
    # its name will be appending to KeywordList.keyword_list,
    # once the KeywordList.keyword_list has 5,000 keywords in a list,
    # a new keyword_list will be created for the next keywords
    def call
        keyword_list = KeywordList.all

        length_keyword_list = []
        count = 0
        keyword_list_count = keyword_list.count
        keyword_list.each do |k|
            if k.keyword_list.size < 5000
                if k.keyword_list.size == 4999
                    count += 1
                end
            end
        end

        if count == 1
            @keyword_list = KeywordList.new(keyword_list: [])
            @keyword_list.save()
        end

        keyword_list.each do |k|
            length_keyword_list.append(k.keyword_list.size)
        end

        keyword_list_size, keyword_list_index = length_keyword_list.each_with_index.min

        if length_keyword_list.count > 1 and length_keyword_list.uniq.count == 1
            @keyword_list = KeywordList.find((keyword_list_index+2))
        else
            @keyword_list = KeywordList.find((keyword_list_index+1))
        end

        @keyword = Keyword.new(name: @name)

        if @keyword.save
            @keyword_list.keyword_list.push(@keyword.name)
            @keyword_list.save
        end

        @keyword

    end

end
