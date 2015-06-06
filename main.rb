require "rubygems"
require "active_record"

require File.expand_path("../dropbox_import.rb",__FILE__)

if ARGV.size > 0
  cli_option1 = ARGV[0]

  case cli_option1
    when "daemon" then
      loop do
        #execute classes
        #alm = Alm.new
        #alm.setExpiredLicenses

        #Wait time in seconds, 5 minutes
        #sleep(180)
      end

    when "cli" then
      dropboxImporter = DropboxImport.new
      #dropboxImporter.authorizeToken
      #dropboxImporter.getAccountInfo
      #dropboxImporter.listAllFolders
      dropboxImporter.import_csv_products

  end

end