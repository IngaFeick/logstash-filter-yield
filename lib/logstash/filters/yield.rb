# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

# TODO docu
class LogStash::Filters::Yield < LogStash::Filters::Base
  
  config_name "yield"

  # The name of the field which contains the array or hash value(s)
  config :source, :validate => :string

  # list of field names that should be copied into the new events
  config :copy_fields, :validate => :array, :default => []

  # optional tag to identify the new events
  config :tag, :validate => :string, :default => nil

  # optional prefix for new field names
  config :prefix, :validate => :string, :default => nil



  public
  def register
    # nothing to do here
  end # def register

  public
  def filter(event)
    objectlist = event[@source]
    if !objectlist.nil?  
      if (objectlist.is_a? Enumerable)
        objectlist.each do |some_object|
          new_event = LogStash::Event.new
          new_event['@timestamp'] = event['@timestamp']
          puts "new event start: " + new_event.inspect.to_s

          # add all fields from objectlist to the event
          if some_object.is_a?(::Hash) 
            some_object.each do |key, value|
              puts "new event: add field " + key.to_s + " with value " + value.to_s 
              new_event[key.to_s] = value
            end
          end

          # copy all the needed fields from the mother event
          if (@copy_fields.is_a? Enumerable)
            @copy_fields.each do |take_me_with_you|
              puts "new event: copy field " + take_me_with_you.to_s
              if !@prefix.nil?
                key = @prefix + take_me_with_you.to_s
              else
                key = take_me_with_you.to_s
              end
              new_event[key] = event[take_me_with_you]
            end
          end 

          if !@tag.nil?
            new_event["tags"] = [@tag]
          end

          puts "new event final: " + new_event.inspect.to_s
          filter_matched(new_event)
          yield new_event
          # event.cancel # maybe offer this as a config option
        end # do    
      else
        @logger.debug("Not iterable: field " + @source + " with some_object " + objectlist.to_s)
      end
    else
       @logger.debug("Nil: field " + @source)
    end # if objectlist.nil? 

  end # def filter  


end # class LogStash::Filters::yield


