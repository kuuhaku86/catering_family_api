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

      if @data.save
        render json: @data, status: :created
      else
        raise @data.errors.full_messages.join(', ')
      end
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

      if category.save
        render json: { message: "Category updated" }, status: :ok
      else
        raise category.errors.full_messages.join(', ')
      end
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

      if category.save
        render json: { message: "Category deleted" }, status: :ok
      else
        raise category.errors.full_messages.join(', ')
      end
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
