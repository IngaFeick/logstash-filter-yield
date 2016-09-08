# Logstash denormalize Filter Plugin


This is a plugin for [Logstash](https://github.com/elastic/logstash).

It is fully free and fully open source. The license is Apache 2.0, meaning you are pretty much free to use it however you want in whatever way.

## Installation

You can download the plugin from [rubygems](https://rubygems.org/gems/logstash-filter-yield) and install it from your logstash home directory like so:

	bin/plugin install logstash-filter-yield-$VERSION.gem

## Purpose

This filter will multiply an event into many. It is used for events which have an array field, if you want every entry in that array to become a separate event. 
One usecase would be to separate lists of objects into separate elasticsearch documents for better aggregation.

### Examples
  
Input event: 
{
	"host" => "machine4711"
	"services" => [ {"name" => "cpu-user", "value" => 42}, {"name" => "cpu-system", "value" => 23}, {"name" => "memory-free", "value" => 4711}]
	"ip" => "10.1.2.3"
}

Output events:

# the original event:
	{
		"host" => "machine4711"
		"services" => [ {"name" => "cpu-user", "value" => 42}, {"name" => "cpu-system", "value" => 23}, {"name" => "memory-free", "value" => 4711}]
		"ip" => "10.1.2.3"
	}
# the new events
	{
		"name" => "cpu-user"
		"value" => 42
	}
	{
		"name" => "cpu-system"
		"value" => 23
	}
	{
		"name" => "memory-free"
		"value" => 4711
	}

You can add fields from the original event to the yielded documents, for example the host name:

Output events:

	# the original event:
	{
		"host" => "machine4711"
		"services" => [ {"name" => "cpu-user", "value" => 42}, {"name" => "cpu-system", "value" => 23}, {"name" => "memory-free", "value" => 4711}]
		"ip" => "10.1.2.3"
	}
	# the new events
	{
		"host" => "machine4711"
		"name" => "cpu-user"
		"value" => 42
	}
	{
		"host" => "machine4711"
		"name" => "cpu-system"
		"value" => 23
	}
	{
		"host" => "machine4711"
		"name" => "memory-free"
		"value" => 4711
	}

## Configuration

* source 				: name of the field that the filter should split on. Must be an array and contain objects (will not work on string arrays e.g.)
* copy					: list of field names that should be copied into the new events (in the above example this would be "host")

It is recommended to also use the config add_tag so that you can separate the yielded from the original documents and send them to different outputs.
# TODO example


## Contributing

All contributions are welcome: ideas, patches, documentation, bug reports, complaints, and even something you drew up on a napkin.

Programming is not a required skill. Whatever you've seen about open source and maintainers or community members  saying "send patches or die" - you will not see that here.

It is more important to the community that you are able to contribute.

For more information about contributing, see the [CONTRIBUTING](https://github.com/elastic/logstash/blob/master/CONTRIBUTING.md) file.