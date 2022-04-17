class Api::MenusController < ApplicationController
  def index
    @data = nil

    if params[:category_id].present?
      @data = Category.find(params[:category_id]).menus
    else
      @data = Menu.all
    end

    @data = @data.select { |menu| menu.soft_deleted == false }

    render json: @data
  end

  def create
    begin
      menu = params[:menu]

      @data = Menu.new(
        name: menu[:name],
        price: menu[:price],
        description: menu[:description],
      )

      if !menu[:categories].nil?
        menu[:categories].each do |category_id|
          category = Category.find(category_id)

          @data.categories << category
        end
      end

      if @data.save
        render json: @data, status: :created
      else
        raise @data.errors.full_messages.join(', ')
      end
    rescue NoMethodError
      render json: {
        message: "Parameter missing"
      }, status: :unprocessable_entity
    rescue => e
      render json: {
        message: e.message
      }, status: :unprocessable_entity
    end
  end

  def update
    begin
      attributes_exist = false
      menu = Menu.find(params[:id])
      column_names = [:name, :price, :description, :categories]

      column_names.each do |column_name|
        if !params[column_name].nil?
          attributes_exist = true

          break
        end
      end

      if !attributes_exist
        raise "Parameter missing"
      end

      if !params[:name].nil?
        menu.name = params[:name]
      end

      if !params[:price].nil?
        menu.price = params[:price]
      end

      if !params[:description].nil?
        menu.description = params[:description]
      end

      if !params[:categories].nil?
        menu.categories = []

        params[:categories].each do |category_id|
          category = Category.find(category_id)

          menu.categories << category
        end
      end

      if menu.save
        render json: menu, status: :ok
      else
        raise menu.errors.full_messages.join(', ')
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: {
        message: "Menu not found"
      }, status: :not_found
    rescue NoMethodError
      render json: {
        message: "Parameter missing"
      }, status: :unprocessable_entity
    rescue => e
      render json: {
        message: e.message
      }, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      menu = Menu.find(params[:id])

      menu.soft_deleted = true

      if menu.save
        render json: { message: "Menu deleted" }, status: :ok
      else
        raise menu.errors.full_messages.join(', ')
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: {
        message: "Menu not found"
      }, status: :not_found
    rescue => e
      render json: {
        message: e.message
      }, status: :unprocessable_entity
    end
  end
end
