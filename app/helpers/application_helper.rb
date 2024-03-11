module ApplicationHelper
  def full_title(page_title='')
    base_title = "#{t('app.app_name')} - #{t('app.app_description')}"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  # deviseのalertをbootstrapのclassに対応させる
  def bootstrap_alert(key)
    case key
      when 'alert'
        'warning'
      when 'notice'
        'success'
      when 'error'
        'danger'
      else
        key
    end
  end
end
