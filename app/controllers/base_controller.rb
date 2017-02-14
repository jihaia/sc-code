class BaseController < ApplicationController
    # Generic helper that allows searching by criteria, sorting results and
    # pagination for JS based grids (such as Bootgrid).
    # Options can include a where clause if you wish to prefilter the collection.
    def process_search(model, _format = :json, options = {})
        page = params[:current] || 1
        limit = params[:rowCount] || 10

        query = build_query(model, options[:where])
        total = query.count
        results = limit == '-1' ? query : query.page(page).per(limit).all.to_a

        # Return an instance variable containing the collection of instances formatted
        # correctly. Example, model Party will result in @parties in the following format;
        #
        # {
        #   "total": 52,
        #   "current": 1,
        #   "rows": [
        #     {"id": 1, "host_name": "blah blah", etc...},
        #     {"id": 2, "host_name": "git milk", etc...},
        #     ...
        #     {"id": 10, "host_name": "hello motto", etc...}
        #   ]
        # }
        #
        CustomHelper.format_response(results, page.to_i, total)
    end # def process_search

    # The query will be dynamically established based on the parameters supplied
    # from the request.
    def build_query(model, where_clause)
        sort = params[:sort] || {}
        criteria = params[:searchPhrase]
        query = (model.respond_to? :search) ? model.send(:search, criteria) : model

        # append where clause if it exists
        query = query.where(where_clause) if where_clause

        sort.each do |k, v|
            query = query.order(k.to_sym => v)
        end

        query # return the resulting query
    end # def build_query
end # class
