require 'rubygems'
require 'active_record'
require 'logger'
require 'yaml'
require 'fileutils'
require 'dropbox_sdk'
require 'awesome_print'
require 'smarter_csv'

require File.expand_path('../config/sheets_dbs.rb',__FILE__)

class DropboxImport

  DOWNLOAD_DIR = '/tmp/'

  def get_dropbox_api_params
    config_path = File.expand_path('../config/params.yml', __FILE__)
    params = YAML.load( File.open( config_path ) )
    params['dropbox_api']
  end

  def get_flow
    api_params = self.get_dropbox_api_params
    flow = DropboxOAuth2FlowNoRedirect.new(api_params['app_key'], api_params['app_secret'])
=  end

  #Generate the authentication link to get the user consent access token
  def authorize_dropbox
    flow = self.get_flow
    autorize_url = flow.start()
    return autorize_url, flow
  end

  def authorize_token

    #This is called once to get the url authorization code consent from the user
    #authUrl, flow = self.authorizeDropbox
    #puts authUrl

    #The authCode is a onetime authorization key from the authUrl gotten from the browser
    #So if called twice with the same authCode the result will be invalid
    #But the resulting accessToken will be always valid unless the user deletes the permission
    #And in that case you have to rerun this method manually
    auth_code = 'kDF6RpilcWAAAAAAAAAAQ5hi_OF6KD8nvgDPNGX35oM'
    flow = self.get_flow
    access_token, user_id = flow.finish(auth_code)
    puts access_token
    puts user_id

  end

  def get_client
    api_params = self.get_dropbox_api_params
    client = DropboxClient.new(api_params['self2_account_token'])
  end

  def get_account_info
    client = self.get_client
    client.account_info()
  end

  def list_all_folders
    client = self.get_client
    root_meta_data = client.metadata('/')
    puts root_meta_data.inspect
    
  end

  def download_file(file)
    filename = File.basename(file)
    client = self.get_client
    content, metadata = client.get_file_and_metadata(file)
    open(DOWNLOAD_DIR + filename, 'w') { |f| f.puts content}
  end

  def import_csv_products
    file = "/Misc/Purchases_for_send.csv"
    filename = File.basename(file)
    localFile = DOWNLOAD_DIR + filename

    puts '> Downloading file.....'
    self.download_file(file)
    puts '> Downloading file done.....'

    if File.exists?(localFile)
      products = SmarterCSV.process(localFile)

      puts '> Inserting products.......'
      products.each do |item|

        #puts item[:item_description] puts item[:status] puts item[:price] puts item[:barcode]
        if !item[:item_description].nil?

          puts item[:barcode].to_s + ' - ' + item[:item_description]

          newProduct = SheetProducts.new(
            guid: SecureRandom.uuid,
            description: item[:item_description],
            status:  item[:status],
            price: Float(item[:price]),
            barcode: item[:barcode],
            updated_at: nil
          )
          newProduct.save

        end

      end
      #puts products.inspect

    end

  end



end