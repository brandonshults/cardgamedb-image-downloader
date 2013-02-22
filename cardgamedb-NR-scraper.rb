require 'watir'
require 'open-uri'
require 'fileutils'

LOCAL_BASE_DIR = '/netrunnercards/'
SETS_REGEX = /-(core|trace-amount|what-lies-ahead|cyber-exodus)\.png/
FILE_URL_PREFIX = "http://www.cardgamedb.com"

cardgamedbFiles = []
filesMap = {}

browser = Watir::Browser.new
browser.goto 'http://www.cardgamedb.com/index.php/netrunner/android-netrunner-card-search'
browser.button(:id => 'andb-submit-button').click
browser.li(:class => 'nrcard').wait_until_present

browser.images.each { |image|
  next unless image.attribute_value("data-original")
  
  fileUrl = FILE_URL_PREFIX + image.attribute_value("data-original")
  fileUrl.sub!('tn_', '')
  fileUrl.sub!('.jpg', '.png')
  fileName = fileUrl.split(/\//)[-1]
  if fileName
    setMatches = fileName.match(SETS_REGEX)
    if setMatches
      subDir = setMatches.captures[0] || 'unknown'
    else
      subDir = 'unknown'
    end

    dir = LOCAL_BASE_DIR + subDir + '/'
    fullFileWithPath = dir + fileName
    
    unless File.exists?(fullFileWithPath)
      unless File.directory?(dir)
        FileUtils.mkdir_p(dir)
        puts "adding directory #{dir}..."
      end
      open(fileUrl) {|src|
        open(fullFileWithPath,"wb") {|dst|
          puts "writing file #{fullFileWithPath}..."
          dst.write(src.read)
        }      
      }
    else
      puts "skipping #{fileName}.  It exists at #{fullFileWithPath}"
    end
  end
}

