module ApplicationHelper

	def notice_message
    alert_types = { notice: :success, alert: :danger }

    close_button_options = { class: "close", "data-dismiss" => "alert", "aria-hidden" => true }
    close_button = content_tag(:button, "×", close_button_options)

    alerts = flash.map do |type, message|
      alert_content = close_button + message

      alert_type = alert_types[type.to_sym] || type
      alert_class = "alert alert-#{alert_type} alert-dismissable"

      content_tag(:div, alert_content, class: alert_class)
    end

    alerts.join("\n").html_safe
  end

  def render_navbar 
    if manager_signed_in? && current_manager.admin?
      render("common/manager_navbar")
    else
      render "common/navbar"  
    end
  end

  def session_link(session_key, session_value, name, options, html_options = {})
    if session_value == session[session_key]
      content_tag(:span, name)
    else
      link_to(name, options, html_options)
    end     
  end

end
