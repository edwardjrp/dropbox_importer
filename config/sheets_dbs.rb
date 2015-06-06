require "active_record"
#New active record versions generate attribute accesors which causes issues with fields that matches the active record convention for a model
require "safe_attributes/base"
require "yaml"
require "fileutils"

config_path = File.expand_path('../params.yml', __FILE__)
params = YAML.load(File.open(config_path))
#self.establish_connection(params["sheet_db"])
ActiveRecord::Base.establish_connection(params['sheet_db'])

class SheetProducts < ActiveRecord::Base
  include SafeAttributes::Base
  self.table_name = 'sheet_products'
  self.primary_key = 'id'
  self.pluralize_table_names = false

  #Excluding a few columns
  exclude_columns = ['created_at','updated_at']
  columns = self.attribute_names - exclude_columns
  self.select(columns)

  #loading yaml config for db
=begin
  configPath = File.expand_path('../params.yml', __FILE__)
  params = YAML.load(File.open(configPath))
  self.establish_connection(params["sheet_db"])
=end

end
