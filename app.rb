%w(bundler camping camping/session redcloth sequel).each { | r | require r}

Bundler.require

APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__)))

# Check for Rack env, if not set, we will use development mode
if ENV['RACK_ENV'] == nil
  ENV['RACK_ENV'] = "development"
end

# Load hash of config 
DB_CONF = Psych.load(File.read(File.join('config/database.yml')))[ENV['RACK_ENV']]

DB = Sequel.connect(DB_CONF)

Sequel::Model.plugin :timestamps, update_on_create: true

#app start
Camping.goes :App
module App
  include Camping::Session

  Dir.glob(APP_ROOT + '/app/*.rb').each do |rb|
    require(rb)
  end

end
