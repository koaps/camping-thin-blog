APP_ROOT = File.expand_path File.dirname(__FILE__)

if ENV['RACK_ENV'] == nil
  env = "development"
else
  env = ENV['RACK_ENV']
end

namespace :app do
  desc "Starts application."
  task :start do
    puts "Starting application in #{env} mode..."
    system("thin -C config/#{env}.yml start")
    puts "Application started"
  end

  desc "Stops application."
  task :stop do
    puts "Stopping application in #{env} mode..."
    system("thin -C config/#{env}.yml stop")
    puts "Application stopped"
  end
  
  desc "Restarts application."
  task :restart do
    puts "Restarting application in #{env} mode..."
    system("thin -C config/#{env}.yml restart")
    puts "Application restarted"
  end

  desc "Starts application in debug mode"
  task :debug do
    puts "Starting application in debug mode..."
    ENV['RACK_ENV'] = 'debug'
    system("thin -C config/debug.yml start")
  end
end

task :environment do
  require(File.join(APP_ROOT, 'app'))
end

namespace :db do
  task :load_config => :environment do
    Sequel.extension :migration
  end

  namespace :schema do
    desc "drops the schema, using schema.rb"
    task :drop => [:load_config] do
      eval(File.read(File.join(APP_ROOT, 'db', 'schema.rb'))).apply(DB, :down)
    end
    
    desc "loads the schema from db/schema.rb"
    task :load => :load_config do
      eval(File.read(File.join(APP_ROOT, 'db', 'schema.rb'))).apply(DB, :up)
	  #Migrator = Sequel::Migrator.new(DB)
      latest_version = Sequel::IntegerMigrator.new(DB, File.join(APP_ROOT, 'db', 'migrate')).current
      #Migrator.set_migration_version(DB, latest_version)
	  Sequel::IntegerMigrator.new(DB, File.join(APP_ROOT, 'db', 'migrate'))
      puts "Database schema loaded version #{latest_version}"
    end
    
    desc "Returns current schema version"
    task :version => :load_config do
      puts "Current Schema Version: #{latest_version = Sequel::IntegerMigrator.new(DB, File.join(APP_ROOT, 'db', 'migrate')).current}"
    end
  end
  
  desc "Migrate the database through scripts in db/migrate and db/schema.rb. Target specific version with VERSION=x. Turn off output with VERBOSE=false."
  task :migrate => :load_config do
    Sequel::Migrator.apply(DB, File.join(APP_ROOT, 'db', 'migrate'))
    Rake::Task["db:schema:version"].invoke
  end

  namespace :migrate do
    desc  'Rollbacks the database one migration and re migrate up. If you want to rollback more than one step, define STEP=x. Target specific version with VERSION=x.'
    task :redo => :load_config do
      Rake::Task["db:rollback"].invoke
      Rake::Task["db:migrate"].invoke
    end

    desc 'Runs the "up" for a given migration VERSION.'
    task :up => :load_config do
      version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
      raise "VERSION is required" unless version
      puts "migrating up to version #{version}"
      Sequel::Migrator.apply(DB, File.join(APP_ROOT, 'db', 'migrate'), version)
    end

    desc 'Runs the "down" for a given migration VERSION.'
    task :down => :load_config do
      step = ENV['STEP'] ? ENV['STEP'].to_i : 1
      latest_version = Sequel::IntegerMigrator.new(DB, File.join(APP_ROOT, 'db', 'migrate')).current
      down_version = current_version - step
      down_version = 0 if down_version < 0
      puts "migrating down to version #{down_version}"
      Sequel::Migrator.apply(DB, File.join(APP_ROOT, 'db', 'migrate'), down_version)
    end
  end

  desc 'Rolls the schema back to the previous version. Specify the number of steps with STEP=n'
  task :rollback => :load_config do
    Rake::Task["db:migrate:down"].invoke
  end

  desc 'Drops and recreates the database from db/schema.rb for the current environment.'
  task :reset => ['db:schema:drop', 'db:schema:load']
end

namespace :default do
  desc "Help"
  task :help do
    p "Run rake -T for task list"
  end

  task :all => [:help]
end

desc "Default Task"
task :default => 'default:all'
