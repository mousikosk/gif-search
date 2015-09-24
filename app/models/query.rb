require 'net/http'

class Query < ActiveRecord::Base
  before_save :replace_spaces

  def get_results
    response = query_service self.term
    @results = []
    count = response["pagination"]["count"].to_i
    (0..count-1).each do |i|
      @results << response["data"][i]["images"]["downsized"]["url"]
    end
    @results
  end

  def query_service(term)
    url = URI.parse("http://api.giphy.com/v1/gifs/search?q=#{term}&api_key=dc6zaTOxFJmzC")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    JSON.parse res.body
  end

  private

    def replace_spaces
      self.term.gsub!(/\s+/, '+')  
    end
end
