class Api::CategoriesController < ApplicationController
  def index
    @data = Category.all

    render json: @data
  end

  def show
    begin
      @data = Category.find(params[:id])

      render json: @data
    rescue
      render json: {
        message: "Category not found"
      }, status: :not_found
    end
  end

  def create
    begin
      category = params[:category]

      if category.nil? || category[:name].nil?
        raise "Parameter missing"
      end

      @data = Category.new(
        name: category[:name],
      )

      if @data.save
        render json: @data
      else
        raise @data.errors.full_messages.join(', ')
      end
    rescue => e
      render json: {
        message: e.message
      }, status: :unprocessable_entity
    end
  end
end
