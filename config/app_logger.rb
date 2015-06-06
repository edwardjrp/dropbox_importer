require "rubygems"
require "active_record"
require "yaml"
require "fileutils"
require "logger"

class AppLogger

  def initialize
    @configpathlog = File.expand_path("../logs.txt", __FILE__)
    @file = @configpathlog
    @log = Logger.new(@file,"weekly")
  end

  def getLogger
    @log
  end

  def logdebugmessage(message)
    @log.level = Logger::DEBUG
    @log.debug message
  end

  def logfatalmessage(message)
    @log.level = Logger::FATAL
    @log.fatal message
  end

  def loginfomessage(message)
    @log.info message
  end


  def logerrormessage(message)
    @log.level = Logger::ERROR
    @log.error message
  end

end