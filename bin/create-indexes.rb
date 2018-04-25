require 'rubygems'
require 'bundler'
Bundler.require :default

INDEX_PREFIX="oa"

client = Elasticsearch::Client.new

#Create index template, new templates will follow this pattern
template = JSON.parse( File.read( ARGV[1] ) )

client.indices.put_template name: INDEX_PREFIX, body: template
$stderr.puts "Added oa index template using #{ARGV[1]}"

#Create indexes
datasets = JSON.parse( File.read(ARGV[0]) )

datasets.keys.each do |dataset|
  index_name = "#{INDEX_PREFIX}-#{dataset}"
  if (client.indices.exists? index: index_name)
    $stderr.puts "Index #{index_name} already exists, skipping"
  else
    client.indices.create index: index_name
    $stderr.puts "Created index #{index_name} for #{datasets[dataset]["title"]}"
  end
end
