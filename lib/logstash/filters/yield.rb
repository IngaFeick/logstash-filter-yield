# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

# TODO docu
class LogStash::Filters::yield < LogStash::Filters::Base
  
  config_name "yield"

  # The name of the field which contains the array or hash value(s)
  config :source, :validate => :string

  # list of field names that should be copied into the new events
  config :copy_fields, :validate => :array, :default => []

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

          # add all fields from objectlist to the event
          if some_object.is_a?(::Hash) # TODO what about objects?
            some_object.each do |key, value|
              new_event[key] = value
            end
          end

          # copy all the needed fields from the mother event
          if (@copy_fields.is_a? Enumerable)
            @copy_fields.each do |take_me_with_you|
              new_event[take_me_with_you] = event[take_me_with_you]
            end
          end 
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


