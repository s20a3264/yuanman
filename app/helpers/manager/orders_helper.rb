module Manager::OrdersHelper
  def active_link(scope, name, options, html_options = {})
  	default_query_scope = scope if html_options[:default] 
    query_scope = request.query_parameters["query_scope"] ? request.query_parameters["query_scope"] : default_query_scope
    if  query_scope == scope
      content_tag(:span, name, class: "bold gray")
    else
      link_to(name, options, html_options)
    end   
  end	
end
