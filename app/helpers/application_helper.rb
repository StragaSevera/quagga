module ApplicationHelper
  def full_title(page_title = '')
    base_title = "Quagga"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def alert_type(type)
    case type
    when "alert"
      "alert-danger"
    when "notice"
      "alert-info"  
    else
      "alert-#{type}"
    end
  end

  def nav_class(link_path)
    current_page?(link_path) ? 'active' : 'not-active'
  end

  def nav_link(link_text, link_path, options = {})
    class_name = nav_class(link_path)

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path, options
    end
  end

  def errors_count(number)
    "К сожалению, в форме #{t(:custom_errors, count: number)}:"
  end

  def publication_date(date, short = false)
    if short
      pattern = "%s, %s"
    else
      pattern = "Опубликовано %s в %s"
    end
    str = pattern % [date.strftime("%d.%m.%Y"), date.strftime("%k:%M")]
  end

  def klass_name(object)
    object.class.name.underscore
  end
end