class SessionsController < Devise::SessionsController
  layout "authentication"
  skip_load_and_authorize_resource
end
