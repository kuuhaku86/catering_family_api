class ApplicationController < ActionController::Base
  def save_data(data, message, status)
    if data.save
      render json: message, status: status
    else
      raise data.errors.full_messages.join(', ')
    end
  end
end
