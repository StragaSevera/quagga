module ApplicationHelper
  def full_title(page_title = '')
    base_title = "Quagga"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def errors_count(number)
    "К сожалению, в форме #{t(:custom_errors, count: number)}:"
  end
end