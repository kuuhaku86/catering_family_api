class Api::OrdersController < ApplicationController
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

      params[:menus].each do |menu|
        menus << Menu.find(menu[:menu_id])
        total_price += menu[:quantity] * menus.last.price
      end

      order = Order.create!(
        total_price: total_price,
        customer: customer,
      )

      menus.each do |menu|
        quantity = params[:menus].find { |m| m[:menu_id] == menu.id }[:quantity]
        total_price_order_menu = params[:menus].find { |m| m[:menu_id] == menu.id }[:quantity] * menu.price

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
