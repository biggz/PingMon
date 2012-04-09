require 'sinatra'
require 'haml'

#Flot JS generator
require_relative 'javascript'

#Webrick options
set :server, 'webrick'
set :port => 8080
set :environment => :production

#Ocra is creating an exe.
if defined?(Ocra)
	puts "Ocra building .exe"
	exit
end

#Disable Webrick logging to console
$stderr = StringIO.new

def print_stats
	system("cls")
	puts "View graph at http://localhost:8080/"
	puts ""
	puts "Monitoring #{@@host} since #{@start_up_time.strftime("%H:%M %d %b %Y")} | Ping retry time #{@@ping_retry.to_s} seconds"
	puts @@data.length.to_s << " pings collected"
	puts "Last ping: #{@@data.last[1]}"
	puts ""
	puts "Control + C to exit"

end

#If no IP argument is given, print error and exit
unless ARGV[0]
 	puts "You must specify an IP address to monitor."
 	puts "Example: pingmon.exe 192.168.0.1"
 	puts "For help: pingmon.exe /?"
 	exit
end
if (ARGV[0] == '/?')
	puts "Usage:"
	puts "pingmon.exe <ip> <ping retry>"
	puts "<ip> IP address, not DNS!"
	puts "<ping retry> Ping retry time inseconds, between 20 - 360. Default 20."
	puts "Example:"
	puts "pingmon.exe 8.8.8.8 20"
else
	#Check that the given argument matches a valid IP address. Print error and exit if not.
	temp = ARGV[0].match(/\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/)
	if temp == nil
		puts "You must specify a valid IP address to monitor"
		puts "Example: pingmon.exe 192.168.0.1"
		exit
	end
end

#Set ping retry time
unless ARGV[1] #No parameter given. Default to 20 seconds
	@@ping_retry = 20
else
	temp = ARGV[1].match(/\d+/)
	if temp == nil #Didnt match a number
		@@ping_retry = 20  #Set as default
	elsif temp[0].to_i < 20 #Less than min
		@@ping_retry = 20
	elsif temp[0].to_i > 360 #Greater than max
		@@ping_retry = 360
	else
		@@ping_retry = temp[0].to_i
	end
	
end

@@host = ARGV[0]
@@data = Array.new
@start_up_time = Time.now
average_ms =''
Thread.new {
	while true
		#Run ping command
		ping_command = IO.popen("ping -n 3 #{@@host}")
		#create array of strings for the command result
		ping_result = ping_command.readlines
		ping_command.close
		timestamp = Time.now.to_f.floor * 1000 #Timestamp needs to be Javascript timestamp, which is UNIX timestamp * 1000
		#Find the line containing the Average ping time
		ping_result.each do |line|		
			if line.match(/Average = \d+ms/)
				#Line found, set average_ms to the time
				average_ms = line.match(/\d+/)
				break
			elsif line.match(/100% loss/)
				#No Average ms found, therefore there's 100% loss
				average_ms = -1
			end
		end
		@@data << [timestamp,average_ms[0].to_i]
		print_stats
		ping_result = ""
		sleep @@ping_retry
	end
}

get '/' do
	@refresh = print_refresh
	return haml(:index)
end

get '/graph' do
	@graph = print_graph
	return haml(:graph)
end