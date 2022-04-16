class Api::CategoriesController < ApplicationController
  def index
    @data = nil

    if params[:id]
      @data = Category.find(params[:id])
    else
      @data = Category.all
    end

    render json: @data
  end
end
