# encoding: utf-8
require 'spec_helper'

describe ApplicationController do
  it "should invoke sys_logger" do
    lambda do
      controller.sys_logger('test')
    end.should change(SysLog, :count).by(1)
  end
end