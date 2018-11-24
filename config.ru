require 'thin'
require 'camping'
require 'camping/reloader'

use Rack::ShowExceptions

class CampingRunner
  def initialize(path, name)
    @reloader = Camping::Reloader.new(path)
    @name = name
  end

  def call(env)
    @reloader.reload
    app = @reloader.apps[@name]
    raise "Could not find app: #{@name}" if app.nil?
    app.call(env)
  end
end

run CampingRunner.new('app.rb', :App)
