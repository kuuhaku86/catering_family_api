class Api::OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token

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
        @data = @data. select { |order| order.customer.email.include? params[:email] }
      end

      if !params[:max_price].blank?
        @data = @data. select { |order| order.total_price <= params[:max_price].to_i }
      end

      if !params[:min_price].blank?
        @data = @data. select { |order| order.total_price >= params[:min_price].to_i }
      end

      if !params[:max_date].blank?
        @data = @data. select { |order| order.created_at < params[:max_date].to_datetime + 1.day }
      end

      if !params[:min_date].blank?
        @data = @data. select { |order| order.created_at >= params[:min_date].to_datetime }
      end
    end

    total_revenue = 0

    @data.each do |order|
      total_revenue += order.total_price
    end

    @data = JSON.parse(@data.to_json(include: [{ order_menus: { include: :menu }}, :customer]))

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

      if params[:menu_ids].nil? || params[:menu_quantities].nil? || params[:menu_ids].length != params[:menu_quantities].length
        raise "Parameter missing"
      end

      (0..params[:menu_ids].length - 1).each do |i|
        menus << Menu.find_by!(id: params[:menu_ids][i].to_i, soft_deleted: false)
        total_price += params[:menu_quantities][i].to_f * menus.last.price.to_f
      end

      order = Order.create!(
        total_price: total_price,
        customer: customer,
      )

      menus.each do |menu|
        quantity = params[:menu_quantities][menus.index(menu)].to_i
        total_price_order_menu = quantity.to_f * menu.price.to_f

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
