class Api::OrdersController < ApplicationController
  def index
    @data = Order.order(created_at: :desc).all

    render json: @data.to_json(include: [{ order_menus: { include: :menu }}, :customer])
  end

  def index_revenue
    @data = nil
    optional_params = [:email, :max_price, :min_price, :max_date, :min_date]
    param_exist = false

    optional_params.each do |param|
      if !params[param].nil?
        param_exist = true
        break
      end
    end


    if !param_exist
      @data = Order.where(
        status: Order::STATUS[:paid],
        created_at: Time.now.beginning_of_day..Time.now.end_of_day
      ).all
    else
      @data = Order.where(
        status: Order::STATUS[:paid],
      ).all

      if !params[:email].blank?
        @data = @data. select { |order| order.customer.email == params[:email] }
      end

      if !params[:max_price].blank?
        @data = @data. select { |order| order.total_price <= params[:max_price].to_i }
      end

      if !params[:min_price].blank?
        @data = @data. select { |order| order.total_price >= params[:min_price].to_i }
      end

      if !params[:max_date].blank?
        @data = @data. select { |order| order.created_at <= params[:max_date].to_datetime }
      end

      if !params[:min_date].blank?
        @data = @data. select { |order| order.created_at >= params[:min_date].to_datetime }
      end
    end

    total_revenue = 0

    @data.each do |order|
      total_revenue += order.total_price
    end

    render json: {
      orders: @data,
      total_revenue: total_revenue
    }
  end

  def create
    ActiveRecord::Base.transaction do
      customer = nil

      if !Customer.exists?(email: params[:customer][:email])
        customer = Customer.create!(
          name: params[:customer][:name],
          email: params[:customer][:email],
        )
      else
        customer = Customer.where(email: params[:customer][:email]).first
      end

      menus = []

      total_price = 0

      if params[:menus].nil?
        raise "Parameter missing"
      end

      param_menus = JSON.parse(params[:menus])

      param_menus.each do |menu|
        menus << Menu.find(menu["menu_id"].to_i)
        total_price += menu["quantity"].to_i * menus.last.price.to_i
      end

      order = Order.create!(
        total_price: total_price,
        customer: customer,
      )

      menus.each do |menu|
        quantity = param_menus.find { |m| m["menu_id"] == menu.id }["quantity"]
        total_price_order_menu = param_menus.find { |m| m["menu_id"] == menu.id }["quantity"] * menu.price

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
end
