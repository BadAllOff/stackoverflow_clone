class Object
 def me
    User.find_by(email: 'andrew@example.com')
 end
 def slmn
    SomeLongModelName
 end
 def an_array
    (1..5).to_a
 end
 def a_hash
    {a: 'b', c: 'd'}
 end

 def switch_db(env)
  config = Rails.configuration.database_configuration
  raise ArgumentError, 'Invalid Environment' unless config[env].present?

  ActiveRecord::Base.establish_connection(config[env])
  Logger.new(STDOUT).info("Successfully changed to #{env} environment")
 end

end