require 'json'

require_relative 'modules'
require_relative 'database'

def startup
  log("", "----------------------------------------------------------", false)
  print("\n")
  print(format_time + "x============================x===========================x\n")
  print(format_time + "|                       TFDB v1.0                        |\n")
  print(format_time + "x============================x===========================x\n")
  log("INFO", "Executed.")
  access
  autobackup
  print(format_time + "x============================x===========================x\n")
end

startup
