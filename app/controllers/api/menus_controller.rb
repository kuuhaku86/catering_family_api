class Api::MenusController < ApplicationController
  def create
    begin
      menu = params[:menu]

      @data = Menu.new(
        name: menu[:name],
        price: menu[:price],
        description: menu[:description],
      )

      menu[:categories].each do |category_id|
        category = Category.find(category_id)

        @data.categories << category
      end

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
end
