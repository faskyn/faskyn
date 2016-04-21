#controller for checking thread safety
class FooController < ApplicationController
  def bar
    sleep 1
    render plain: "foobar\n"
  end
end