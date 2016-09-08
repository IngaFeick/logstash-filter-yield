# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/filters/yield"
require "logstash/event"

describe LogStash::Filters::Yield do

  context "when event has 3 child objects" do
    it "should generate 3 new events" do
      filter = LogStash::Filters::Yield.new({"source" => "services"})
      event = LogStash::Event.new(
              "host" => "machine4711",
              "services" => [ {"name" => "cpu-user", "value" => 42}, {"name" => "cpu-system", "value" => 23}, {"name" => "memory-free", "value" => 4711}],
              "ip" => "10.1.2.3")
      
      expect {filter.filter(event).length}.to eq(4)
    end
  end

  context "when event has 3 child objects and copy config" do
    it "should copy the fields from the original event" do
      filter = LogStash::Filters::Yield.new({"source" => "services", "copy_fields" => [ "host"]})
      event = LogStash::Event.new(
              "host" => "machine4711",
              "services" => [ {"name" => "cpu-user", "value" => 42}, {"name" => "cpu-system", "value" => 23}, {"name" => "memory-free", "value" => 4711}],
              "ip" => "10.1.2.3")
      outcome = filter.filter(event)
      expect {outcome[0].['ip']}.to eq("10.1.2.3") # test that original event is still in there
      expect {outcome[1].['name']}.to eq("cpu-user")
      expect {outcome[2].['name']}.to eq("cpu-system")
      expect {outcome[2].['value']}.to eq(23)
      expect {outcome[3].['value']}.to eq(4711)
      expect {outcome[3].['host']}.to eq("machine4711")
      expect {outcome[1].['host']}.to eq("machine4711")
    end
  end



=begin

  context "when field is nil" do
    it "should not raise exception" do
      filter = LogStash::Filters::Denormalize.new({"source" => "my_array"})
      event = LogStash::Event.new("my_array" => nil)
      expect {filter.filter(event)}.not_to raise_error
    end
  end

 describe "array input" do
    config <<-CONFIG
      filter {
        denormalize { "source" => "message"}
      }
    CONFIG

    sample ["cheese", "bacon"] do
      puts subject.inspect # TODO
      insist { subject.length } == 2
      insist { subject[0]["message"] } == "cheese"
      insist { subject[1]["message"] } == "bacon"
    end
  end

  context "when field is not iterable" do
    it "should not raise exception" do
      filter = LogStash::Filters::Denormalize.new({"source" => "my_array"})
      event = LogStash::Event.new("my_array" => "ipsum lorem")
      expect {filter.filter(event)}.not_to raise_error
    end
  end



  describe "change target name" do
    config <<-CONFIG
      filter {
        denormalize { 
          "source" => "message"
          "target" => "new_key"
        }
      }
    CONFIG

    sample ["cheese", "bacon"] do
      puts subject.inspect # TODO
      insist { subject.length } == 2
      insist { subject[0]["new_key"] } == "cheese"
      insist { subject[1]["new_key"] } == "bacon"
    end
  end


  describe "hash input" do
    config <<-CONFIG
      filter {
        denormalize { "source" => "message"}
      }
    CONFIG

    sample {"foo" => "bar", "unicorn" => "magic"} do
      insist { subject.length } == 2
      insist { subject[0]["foo"] }      == "bar"
      insist { subject[1]["unicorn"] }  == "magic"
    end
  end

  describe "hash input with target name" do
    config <<-CONFIG
      filter {
        denormalize { 
          "source" => "message"
          "target" => "new_key"
        }
      }
    CONFIG

    sample {"foo" => "bar", "unicorn" => "magic"} do
      insist { subject.length } == 2
      insist { subject[0]["new_key"] }      == "bar"
      insist { subject[1]["new_key"] }  == "magic"
    end
  end
=end

end