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
end
