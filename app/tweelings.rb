$LOAD_PATH << File.dirname(__FILE__)

module Tweelings
  require 'csv'
  require 'json'
  require 'sqlite3'
  require 'twitter'
  require 'yaml'

  require 'Tweelings/boot/loader'
end
