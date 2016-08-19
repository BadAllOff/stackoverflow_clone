class SearchsController < ApplicationController
  # if (Error connecting to Sphinx via the MySQL protocol)
  # do rake ts:configure ts:restart
  # more info https://github.com/pat/thinking-sphinx/issues/813
  # to reindex use  rake ts:index

  def index
  end

  def results
    @search_query = query
    @condition = condition
    @results = SearchQuery.sphinx_search(query, params[:search_query][:condition])
  end

  private

  def search_query_params
    params.require(:search_query).permit(:query, :condition)
  end

  def condition
    condition = params[:search_query][:condition]
    condition == 'nil' ? nil : condition.to_s.singularize
  end

  def query
    params[:search_query][:query]
  end

end
