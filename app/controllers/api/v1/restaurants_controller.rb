class Api::V1::RestaurantsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User, except: [ :index, :show ]
  before_action :find_restaurant, only: [:show, :update]
  def index
    @restaurants = policy_scope(Restaurant)
  end

  def show
    authorize @restaurant
  end

  def update
    if @restaurant = Restaurant.update(restaurant_params)
      render :show
    else
      render_error
    end
  end

  private
  def find_restaurant
    @restaurant = Restaurant.find(params[:id])
  end
  def restaurant_params
params.require(@restaurant).permit(:name, :address)
  end
  def render_error
    render json: { errors: @restaurant.errors.full_messages },
      status: :unprocessable_entity
  end
end
