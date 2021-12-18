class ItemListener

    require 'aho_corasick'

    def item_create_successful(item)

        keywords = Keyword.all
        subscriptions = Subscription.all
        keyword_list = KeywordList.pluck(:keyword_list)

        keyword_id = ''
        keyword_name = ''

        # When a item is posted,
        # iterate through all the KeywordList.keyword_list
        # and use the string-search-algorithm of 'Aho-Corasick' to 
        # find the matching keyword

        ##############################################
        ######## NEW APPROACH OF KEYWORD LOOP ########
        ##############################################

        keyword_list.find_all do |k|
            matcher = AhoCorasick.new(k)
            matching_title = matcher.match(item.title)
            matching_description = matcher.match(item.description)

            if matching_title.present?
                keyword = Keyword.find_by(name: matching_title)
            elsif matching_description.present?
                keyword = Keyword.find_by(name: matching_description)
            end

            if keyword.present?
                keyword_id = keyword.id
                keyword_name = keyword.name
            end

        end

        # When a new item is posted,
        # iterate through all the keywords and
        # check if any keyword is matching with
        # item's title or item's description

        ##############################################
        ######## OLD APPROACH OF KEYWORD LOOP ########
        ##############################################

        # keywords.each do |keyword|
        #     if [item.title, item.description].any? { |s| s.include? keyword.name }
        #         keyword = Keyword.find_by(name: keyword.name)
        #         keyword_id = keyword.id
        #         keyword_name = keyword.name
        #     end
        # end
        
        # Search and retrieve all the Subscriptions that contain keyword_id 
        filtered_subscriptions = Subscription.where(:keyword_id => keyword_id).to_a()

        data_dic_list = []

        # If there is any Subscription from searching,
        # retrieve the user information(email) and the name of keyword.
        # Then, transform these information into a list of dictionaries
        # and print out all the information of notifications in the console
        if !filtered_subscriptions.empty?
            filtered_subscriptions.each do |subscription|
                user_id = subscription.user_id

                user_email = User.find_by(id: user_id).email

                data_dic = {
                    "user_email" => user_email,
                    "keyword" => keyword_name
                }
                data_dic_list.push(data_dic)
            end
            puts "**************** ALERT *****************\n\n" \
                 "we sent notifications to every user who subscribes to about '#{keyword_name}'\n\n" \
                 "this is a list of subscription information:\n #{filtered_subscriptions}\n\n" \
                 "this is a list of subscriber data:\n #{data_dic_list}\n\n" \
                 "***************** END ******************" \
        else
            puts "*************** NO ALERT **************\n\n" \
                 "we didn't send any notification cuz no one subscribes to this item\n\n" \
                 "***************** END *****************" \
        end
    end

    def item_create_failed(item)
        puts 'an item is not created successfully'
    end
end