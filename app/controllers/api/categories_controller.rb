class Api::CategoriesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @data = Category.where(soft_deleted: false).all

    render json: @data
  end

  def show
    begin
      @data = Category.find(params[:id])

      render json: @data, status: :ok
    rescue
      render json: {
        message: "Category not found"
      }, status: :not_found
    end
  end

  def create
    begin
      category = params[:category]

      check_params(category)

      @data = Category.new(
        name: category[:name],
      )

      save_data(
        data: @data, 
        message: @data, 
        status: :created
      )
    rescue => e
      render json: {
        message: e.message
      }, status: :unprocessable_entity
    end
  end

  def update
    begin
      category = Category.find(params[:id])

      check_params(params)

      category.name = params[:name]

      save_data(
        data: category, 
        message: { message: "Category updated" }, 
        status: :ok
      )
    rescue ActiveRecord::RecordNotFound => e
      render json: {
        message: "Category not found"
      }, status: :not_found
    rescue => e
      render json: {
        message: e.message
      }, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      category = Category.find(params[:id])

      category.soft_deleted = true

      save_data(
        data: category, 
        message: { message: "Category deleted" },
        status: :ok
      )
    rescue ActiveRecord::RecordNotFound => e
      render json: {
        message: "Category not found"
      }, status: :not_found
    rescue => e
      render json: {
        message: e.message
      }, status: :unprocessable_entity
    end
  end
  
  private
  def check_params(params)
    if params.nil? || params[:name].nil?
      raise "Parameter missing"
    end
  end
end
