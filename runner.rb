require 'yaml'
require 'json'
require 'tempfile'


def ofcode(a)
   if a[0] == '@'
   begin       
       File.read(a[1..-1])
   rescue
       puts "Can not open #{a}"
       ""
   end
   else
       a
   end
end

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
            File.write k, ofcode(v)
        }
        File.write 'code', ofcode(code)
        log = ""
        befores.each{|q|
            log += `#{ofcode(q)} 2>&1` + "\n" 
        }
        
        log += `#{ofcode(sh)}`
        puts log
    end
end
