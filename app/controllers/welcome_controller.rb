class WelcomeController < ApplicationController
  authorize_resource class: WelcomeController

  def index
  end
end
