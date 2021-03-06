require "logstash/devutils/rspec/spec_helper"
require "logstash/filters/environment"

describe LogStash::Filters::Environment do


  describe "add a field from the environment" do
    # The logstash config goes here.
    # At this time, only filters are supported.
    config <<-CONFIG
      filter {
        environment {
          add_metadata_from_env => [ "newfield", "MY_ENV_VAR" ]
        }
      }
    CONFIG

    ENV["MY_ENV_VAR"] = "hello world"

    sample "example" do
      insist { subject["@metadata"]["newfield"] } == "hello world"
    end
  end

  describe "does nothing on non-matching events" do
    # The logstash config goes here.
    # At this time, only filters are supported.
    config <<-CONFIG
      filter {
        environment {
          type => "foo"
          add_metadata_from_env => [ "newfield", "MY_ENV_VAR" ]
        }
      }
    CONFIG

    ENV["MY_ENV_VAR"] = "hello world"

    sample("type" => "bar", "message" => "fizz") do
      insist { subject["@metadata"]["newfield"] }.nil?
    end
  end
end
