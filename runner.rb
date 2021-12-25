require 'yaml'
require 'json'
require 'tempfile'
x = File.read ARGV[0]
y = YAML.load x
if y['id']
   Dir.mkdir "snippet" rescue 1
   File.write "snippet/#{y['id']}", x
elsif y['load']
   Dir.mkdir "snippet" rescue 1
   puts (File.read("snippet/#{y['load']}") rescue "")
   exit
end

sh = y['sh'] || ""
exit if sh == ""
code = y['code'] || ""
files = y['fs'] || {}
befores = y['before'] || []
Dir.mktmpdir ("/tmp") do |dir|
    Dir.chdir dir do
        files.each{|k, v|
            File.write k, v
        }
        log = ""
        befores.each{|q|
            log += `#{q} 2>&1` + "\n" 
        }
        File.write 'code', code
        log += `#{sh}`
        puts log
    end
end
