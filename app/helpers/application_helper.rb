module ApplicationHelper
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
