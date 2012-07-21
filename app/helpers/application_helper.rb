# encoding: utf-8
module ApplicationHelper
  def title
    base_title = "北冶"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def return_time_frame
    ['周','月','季','年']  #week, month, quarter, year
  end    
end
