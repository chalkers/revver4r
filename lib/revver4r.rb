# Revver4R - Revver for Ruby Library
# Author: Andrew Chalkley (andrew@chalkley.org)
# Copyright: 2008 Andrew Chalkley
# License: MIT
# http://creativecommons.org/licenses/MIT/

require 'rubygems'
require 'open-uri'
require 'hpricot'

#== About
#
# This is module for searching Revver and returning video information from it.
#
#== Usage Example
#
# Here's how to pull 1 quicktime video with the tag ruby
#    
#    require 'Revver4R'
#    video_search = Revver4R::VideoSearch.new("qt","tag","ruby",{"limit" => 1})
#    videos = video_search.search
#    videos.each do |video|
#      puts video.to_yaml
#    end
# 
#  For more information at http://developer.revver.com/feeds/mrss
module Revver4R

  POSSIBLE_MEDIA_TYPES = ["flash", "qt"]
  POSSIBLE_CONTENTS = ["user","collection","search","tag","latest","full","top10","top20","offline"]
  POSSIBLE_OPTIONS = ["affiliate","orderBy","order","offset","limit","minAgeRestriction","maxAgeRestriction"]

  POSSIBLE_ORDER_BYS = ["publicationDate","modifiedDate","createdDate","title","author","views","duration","size"]
  POSSIBLE_ORDERS = ["asc","desc"]
  RESTRICTION_RANGE = (1..5)

  # http://feeds.revver.com/2.0/mrss/MEDIA/FEEDCONTENTS/FEEDCRITERIA?OPTIONS
  REVVER_RSS_START = "http://feeds.revver.com/2.0/mrss/"

  class SearchBase
      
    attr_accessor :media, :feed_contents, :criteria
    def initialize(media="flash", feed_contents="tag", criteria="rails", options = {"affiliate" => "chalkers"})
      if POSSIBLE_MEDIA_TYPES.include? media
        @media = media
      else
        raise "Invalid 'media' type. Choose from " + POSSIBLE_MEDIA_TYPES.join[", "]
      end

      if POSSIBLE_CONTENTS.include? feed_contents
        @feed_contents = feed_contents
      else
        raise "Invalid 'feed_content' type. Choose from " + POSSIBLE_CONTENTS.join[", "]
      end

      @criteria = criteria

      options.delete("affiliate") if options["affiliate"] == ""
      raise "Invalid 'offset' must be an Integer" if (options.has_key?"offset" && options["offset"].is_a?(Integer))
      raise "Invalid 'order'. Choose from "+ POSSIBLE_ORDERS.join[", "] if (options.has_key?"order" && !POSSIBLE_ORDERS.include?(options["order"]))
      raise "Invalid 'orderBy'. Choose from "+ POSSIBLE_ORDER_BYS.join[", "] if (options.has_key?"orderBy" && !POSSIBLE_ORDER_BYS.include?(options["order"]))

      ["minAgeRestriction","maxAgeRestriction"].each do |restriction|
         raise "Invalid '#{restriction}'. It must be between " + RESTRICTION_RANGE.first + " - " + RESTRICTION_RANGE.last if (options.has_key?restriction && !RESTRICTION_RANGE.include?(options[restriction]))
      end

      @options = options
    end

    def search
      raise "'search' method not implemented"
    end

    private

    def download_feed(url)
      Hpricot.XML(open(url, { "User-Agent" => "Ruby/#{RUBY_VERSION} (Revver4R)" }))
    end

    def generate_url
      options = []
      @options.each do |k,v|
        options << (k + "=" + v.to_s)
      end
      REVVER_RSS_START + [@media,@feed_contents,@criteria].join("/") + "?" + options.join("&")
    end

  end

  class VideoSearch < SearchBase
    def search
      doc = download_feed(generate_url)
      feed_to_videos(doc)
    end
    private
    def feed_to_videos(doc)
      videos = []
      (doc/"item").each do |item|
        videos << Video.new(item)
      end
      videos
    end
  end

  class Video
    attr_accessor  :title, :description, :credit, :content, :categories, :thumbnail, :rating, :license, :revver_url
    alias :user :credit
    def initialize(item)
      @title = (item/"media:title").first.to_plain_text
      @description = (item/"media:description").first.to_plain_text
      @credit = (item/"media:credit").first.to_plain_text
      @categories = (item/"media:category").first.to_plain_text.split(" ")
      content_node = (item/"media:content").first
      @content = VideoContent.new(  content_node.attributes["type"],
              content_node.attributes["url"],
              content_node.attributes["duration"].to_i)
      thumnail_node = (item/"media:thumbnail").first
      @thumbnail = Thumbnail.new( thumnail_node.attributes["url"],
              thumnail_node.attributes["width"].to_i,
              thumnail_node.attributes["height"].to_i)
      @revver_url = (item/"media:player").first.attributes["url"]
      @rating = (item/"media:rating").first.to_plain_text
      @license = (item/"creativeCommons:license").first.to_plain_text
    end
  end

  class VideoContent
    attr_accessor :type, :url, :duration
    def initialize(type, url, duration)
      @type = type
      @url = url
      @duration = duration
    end
  end

  class Thumbnail
    attr_accessor :url, :width, :height
    def initialize(url, width, height)
      @url = url
      @width = width
      @height = height
    end
  end
end