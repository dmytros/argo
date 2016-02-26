module ApplicationHelper
  def img_class(cast)
    case cast
    when 'boolean', 'tinyint'
      'ui-icon-shuffle'
    when 'integer', 'int'
      'ui-icon-calculator'
    when 'numeric', 'float', 'decimal'
      'ui-icon-clipboard'
    when 'character'
      'ui-icon-pin-s'
    when 'string', 'varchar'
      'ui-icon-image'
    when 'text'
      'ui-icon-power'
    when 'date'
      'ui-icon-print'
    when 'time'
      'ui-icon-battery-2'
    when 'datetime', 'timestamp'
      'ui-icon-calendar'
    else
      'ui-icon-help'
    end
  end
  
  def spent_time_tag(spent_time)
    "%0.3f" % spent_time
  end
  
  def bool_tag(value)
    if value
      'SUCCESS'
    else
      'FAIL'
    end
  end
  
  def timestamp_format_tag(date)
    date.to_s(:db)
  end
end
