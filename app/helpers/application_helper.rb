module ApplicationHelper
  def money_format(value)
    "$#{'%.02f' % value.to_d}"
  end

  #https://github.com/scottwater/detect_timezone_rails
  def format_time(time, timezone="America/New_York", strftime_format="%A %B %e, %Y %l:%M%P")
    return "" if time.blank?
    time.to_time.in_time_zone(timezone).strftime(strftime_format)
  end
end
