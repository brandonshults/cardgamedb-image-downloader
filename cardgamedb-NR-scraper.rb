require 'watir'
require 'open-uri'
require 'fileutils'

LOCAL_BASE_DIR = '/netrunnercards/'
SETS_REGEX = /-(core|trace-amount|what-lies-ahead|cyber-exodus|a-study-in-static|humanitys-shadow|future-proof|

creation-and-control|opening-moves|second-thoughts|mala-tempora|true-colors|fear-and-loathing|double-time)\.png/
FILE_URL_PREFIX = "http://www.cardgamedb.com"

cardgamedbFiles = []
filesMap = {}
not_found = {}

setsArray = ['Core','Genesis','Creation and Control','Spin Cycle']



def read_and_write(remoteFile, localFile)
  open(remoteFile) {|src|
    open(localFile,"wb") {|dst|
      puts "writing file #{localFile}..."
      dst.write(src.read)
    }      
  }
end  


setsArray.each { |filterSet|  
  browser = Watir::Browser.new
  browser.goto 'http://www.cardgamedb.com/index.php/netrunner/android-netrunner-card-search'
  browser.select_list(:id => 'filterSet').option(:text => filterSet).select
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
        begin
          read_and_write fileUrl, fullFileWithPath
        rescue
          not_found[fileUrl] = ""
          lowResFileUrl = fileUrl.sub /(.*\/)(.*?\.png)$/, '\1med_\2'
          puts "attempting to get lower resolution version from #{lowResFileUrl}..."
          fullLowResFileWithPath = dir + "med_" + fileName
          begin
            read_and_write lowResFileUrl, fullLowResFileWithPath
            not_found[fileUrl] = lowResFileUrl
          rescue
          end
        end
      else
        puts "skipping #{fileName}.  It exists at #{fullFileWithPath}"
      end
    end
  }

browser.close if browser

}
unless not_found.empty?
  puts "Unable to find the following files:"
  not_found.each {|mainFile, replacement|
    puts "\t#{mainFile}"
    puts "\t\tGot: #{replacement} instead." unless replacement == ""
  }
end

