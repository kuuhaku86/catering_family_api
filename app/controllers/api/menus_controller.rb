class Api::MenusController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @data = get_menu_data(params)

    render json: @data.to_json(include: [:categories])
  end

  def create
    begin
      menu = params[:menu]

      @data = Menu.new(
        name: menu[:name],
        price: menu[:price],
        description: menu[:description],
      )

      add_categories(@data, menu[:categories])

      save_data(
        data: @data, 
        message: @data, 
        status: :created
      )
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

      check_if_updated_attributes_exist(params)

      update_menu(menu, params)

      save_data(
        data: menu, 
        message: { message: "Menu updated" },
        status: :ok
      )
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

      save_data(
        data: menu, 
        message: { message: "Menu deleted" },
        status: :ok
      )
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

  private

  def get_menu_data(params)
    if params[:category_id].present?
      @data = Category.find(params[:category_id])
                .menus
                .where(soft_deleted: false)
                .all
    else
      @data = Menu.where(soft_deleted: false).all
    end

    @data
  end

  def add_categories(menu, categories)
    categories.each do |category_id|
      category = Category.find_by!(id: category_id, soft_deleted: false)

      menu.categories << category
    end
  end

  def check_if_updated_attributes_exist(params)
    column_names = [:name, :price, :description, :categories]

    column_names.each do |column_name|
      if !params[column_name].nil?
        return
      end
    end

    raise "Parameter missing"
  end

  def update_menu(menu, params)
    column_names = [:name, :price, :description, :categories]

    column_names.each do |column_name|
      if !params[column_name].nil?
        if column_name == :categories
          menu.categories = []

          add_categories(menu, params[column_name])
        else
          menu.send("#{column_name}=", params[column_name])
        end
      end
    end
  end
end
