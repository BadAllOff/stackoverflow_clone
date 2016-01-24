module ApplicationHelper

  BOOTSTRAP_FLASH_MSG = {
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-info'
  }

  def bootstrap_class_for(flash_type)
    BOOTSTRAP_FLASH_MSG.fetch(flash_type.to_sym, flash_type.to_s)
  end

  def bootstrap_icon_for(flash_type)
    { success: 'ok-circle', error: 'remove-circle', alert: 'warning-sign', notice: 'exclamation-sign' }[flash_type.to_sym] || 'question-sign'
  end

  def flash_messages(*)
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do
               concat content_tag(:button, 'x', class: 'close', data: { dismiss: 'alert' })
               concat content_tag(:i, nil, class: "glyphicon glyphicon-#{bootstrap_icon_for(msg_type)}")
               concat ' '
               concat message
             end)
    end
    nil
  end

end
