require 'rubygems'
require 'unicode'
require 'punycode'
require 'actionmailer'

class IdnActionmailer
  VERSION = '1.0.0'
  
  UTF8REGEX = /\A(?:                                                            
                [\x09\x0A\x0D\x20-\x7E]            # ASCII
              | [\xC2-\xDF][\x80-\xBF]             # non-overlong 2-byte
              |  \xE0[\xA0-\xBF][\x80-\xBF]        # excluding overlongs
              | [\xE1-\xEC\xEE\xEF][\x80-\xBF]{2}  # straight 3-byte
              |  \xED[\x80-\x9F][\x80-\xBF]        # excluding surrogates
              |  \xF0[\x90-\xBF][\x80-\xBF]{2}     # planes 1-3
              | [\xF1-\xF3][\x80-\xBF]{3}          # planes 4-15
              |  \xF4[\x80-\x8F][\x80-\xBF]{2}     # plane 16
              )*\z/mnx


  UTF8_REGEX_MBYTE = /(?:                                 
                   [\xC2-\xDF][\x80-\xBF]             # non-overlong 2-byte
                 |  \xE0[\xA0-\xBF][\x80-\xBF]        # excluding overlongs
                 | [\xE1-\xEC\xEE\xEF][\x80-\xBF]{2}  # straight 3-byte
                 |  \xED[\x80-\x9F][\x80-\xBF]        # excluding surrogates
                 |  \xF0[\x90-\xBF][\x80-\xBF]{2}     # planes 1-3
                 | [\xF1-\xF3][\x80-\xBF]{3}          # planes 4-15
                 |  \xF4[\x80-\x8F][\x80-\xBF]{2}     # plane 16
                 )/mnx
  
  def self.encode(str)
    if str =~ UTF8REGEX && str =~ UTF8_REGEX_MBYTE
      
      parts = Unicode::downcase(str).split('.')
      parts.map! do |part|
        if part =~ UTF8REGEX && part =~ UTF8_REGEX_MBYTE
          "xn--" + Punycode.encode(Unicode::normalize_KC(part))
        else
          part
        end
      end
      
      parts.join('.') 
     else
      str 
    end
  end
end

module ActionMailer
  module Quoting
    alias_method :orig_quote_address_if_necessary, :quote_address_if_necessary
    
    def quote_address_if_necessary(address, charset)
      if Array === address
        orig_quote_address_if_necessary(address, charset)
      else
        if(address =~ /^(.*(<)?.*@)(.*)(>)?$/)
          predomain = $1
          domain = IdnActionmailer.encode($3)
          postdomain = $4
          orig_quote_address_if_necessary("#{predomain}#{domain}#{postdomain}", charset)
        else
          orig_quote_address_if_necessary(address, charset)
        end
      end
    end
  end
end