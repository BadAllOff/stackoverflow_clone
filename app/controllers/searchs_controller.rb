class SearchsController < ApplicationController
  # if (Error connecting to Sphinx via the MySQL protocol)
  # do rake ts:configure ts:restart
  # more info https://github.com/pat/thinking-sphinx/issues/813
  # to reindex use  rake ts:index

  before_action :load_results, only: [:results]

  def index
  end

  def results
    @search_query = params[:search_query][:query]
    @index_type = index_type
  end

  private

  def load_results
    @results = ThinkingSphinx.search query, classes: [index_type]
  end

  def search_query_params
    params.require(:search_query).permit(:query, :index_type)
  end

  def index_type
    index_type = params[:search_query][:index_type]
    index_type == 'nil' ? nil : index_type.singularize.constantize
  end

  def query
    params[:search_query][:query]
  end

end
