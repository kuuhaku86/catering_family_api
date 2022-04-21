class Api::OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @data = Order.order(created_at: :desc).all
    @data = get_order_relation(@data)

    render json: @data
  end

  def index_revenue
    @data = get_order_revenue(params)

    total_revenue = get_total_revenue(@data)

    @data = get_order_relation(@data)

    render json: {
      orders: @data,
      total_revenue: total_revenue
    }
  end

  def create
    ActiveRecord::Base.transaction do
      check_params(params)

      customer = get_customer(params)
      menus = get_menus(params)
      total_price = get_total_price(params, menus)

      order = Order.create!(
        total_price: total_price,
        customer: customer,
      )

      menus.each do |menu|
        index = menus.index(menu)
        quantity = get_quantity(params, index)
        total_price_order_menu = get_total_price_order_menu(params, menu, index)

        OrderMenu.create!(
          order: order,
          menu: menu,
          quantity: quantity,
          total_price: total_price_order_menu,
        )
      end

      order = Order.find(order.id)

      render json: order, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: {
        message: "Menu not found"
      }, status: :not_found
    rescue NoMethodError => e
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
      order = Order.find(params[:id])

      order.update!(
        status: params[:status]
      )

      render json: { message: "Order updated" }, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: {
        message: "Order not found"
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

  private

  def get_order_revenue(params)
    @optional_params = [:email, :max_price, :min_price, :max_date, :min_date]
    query_exist = check_if_query_exist(params)

    if !query_exist
      data = Order.where(
        status: Order::STATUS[:paid],
        created_at: Time.now.beginning_of_day..Time.now.end_of_day
      ).all
    else
      data = Order.where(
        status: Order::STATUS[:paid],
      ).all
      
      @optional_params.each do |param|
        if !params[param].nil?
          data = filter_data_by_param(data, param)
        end
      end
    end

    return data
  end

  def check_if_query_exist(params)
    @optional_params.each do |param|
      if !params[param].nil?
        return true
      end
    end

    return false
  end

  def filter_data_by_param(data, param)
    case param
    when :email
      data = data. select { |order| order.customer.email.include? params[:email] }
    when :max_price
      data = data. select { |order| order.total_price <= params[:max_price].to_i }
    when :min_price
      data = data. select { |order| order.total_price >= params[:min_price].to_i }
    when :max_date
      data = data. select { |order| order.created_at < params[:max_date].to_datetime + 1.day }
    when :min_date
      data = data. select { |order| order.created_at >= params[:min_date].to_datetime }
    end

    data
  end

  def get_total_revenue(data)
    total_revenue = 0

    data.each do |order|
      total_revenue += order.total_price
    end

    return total_revenue
  end

  def get_order_relation(data)
    return JSON.parse(
      data.to_json(
        include: [
          { 
            order_menus: 
            { 
              include: :menu 
            }
          }, 
          :customer
        ]
      )
    )
  end

  def check_params(params)
    if params[:menu_ids].nil? || 
      params[:menu_quantities].nil? || 
      params[:customer].nil? ||
      params[:customer][:email].nil? ||
      params[:menu_ids].length != params[:menu_quantities].length
      raise "Parameter missing"
    end
  end

  def get_customer(params)
    if !Customer.exists?(email: params[:customer][:email])
      return Customer.create!(
        email: params[:customer][:email],
      )
    else
      return Customer.where(email: params[:customer][:email]).first
    end
  end

  def get_menus(params)
    menus = []

    (0..params[:menu_ids].length - 1).each do |i|
      menus << Menu.find_by!(id: params[:menu_ids][i].to_i, soft_deleted: false)
    end

    return menus
  end

  def get_total_price(params, menus)
    total_price = 0

    (0..params[:menu_quantities].length - 1).each do |i|
      total_price += params[:menu_quantities][i].to_f * menus[i].price.to_f
    end

    return total_price
  end

  def get_quantity(params, index)
    return params[:menu_quantities][index].to_i
  end

  def get_total_price_order_menu(params, menu, index)
    quantity = params[:menu_quantities][index].to_i
    return quantity.to_f * menu.price.to_f
  end
end
