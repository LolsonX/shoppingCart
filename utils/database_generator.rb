require 'json'

class DatabaseGenerator
  def self.create_database(env)
    puts "======== Create database for environment: #{env} ========"
    database_name = CONFIG_FILE[env]["database"]["file"]
    database_file = File.join(DATABASE_DIR, database_name)
    if File.exist?(database_file)
      puts "#{database_file} already exists. Nothing to do."
      return
    end
    File.open(database_file, "w+") { |file| file.puts empty_database }
  end

  def self.empty_database
    {migrations: [], database: {}}.to_json
  end
end
