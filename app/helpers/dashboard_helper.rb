module DashboardHelper
  def token_button(user)
    if user && user.token.present?
      button_to "Get New Token", get_token_path, class: "btn btn-info", remote: true
    else
      button_to "Get Token", get_token_path, class: "btn btn-success", remote: true
    end
  end
end
