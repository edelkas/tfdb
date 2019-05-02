# Generic file for database manipulation

require 'fileutils'
require 'json'
require 'terminal-table'
require 'text-table'
require 'yaml'

CONFIG_ENV = 'production'
CONFIG = YAML.load_file('config.yml')[CONFIG_ENV]

$database = {}

# Auxiliary methods

def time
  Time.now.strftime("%Y%m%d%H%M%S") # %N for nanoseconds
end

def short_time
  Time.now.strftime("%Y%m%d")
end

def format_time
  Time.now.strftime("[%Y-%m-%d %H:%M:%S] ")
end

def filename
  CONFIG['json'].remove(".json").concat(".json")
end

def backup_filename
  filename.remove(".json").concat("_%s.json" % [time])
end

def autobackup_filename
  filename.remove(".json").concat("_%s.json" % [short_time])
end

def message(type, text)
  format_time + type.upcase + ": " + text + "\n"
end

# File manipulation methods

def backup(auto = false)
  begin
    old = (auto ? autobackup_filename : backup_filename)
    if File.file?(filename) then FileUtils.cp(filename, old) end
  rescue
    log("ERROR", "Realizando la copia de seguridad de la base de datos.")
  ensure
    return old
  end
end

def autobackup
  backup(true) if CONFIG['autobackup'] && !File.file?(autobackup_filename)
rescue
  log("ERROR", "Realizando la copia de seguridad automática.")
else
  log("INFO", "Copia de seguridad automática realizada.")
end

def save
  backup_name = backup
  begin
    File.delete(filename) if File.file?(filename)
    File.open(filename, "w") do |f|
      f.write($database.to_json)
    end
  rescue
    File.delete(filename) if File.file?(filename)
    File.rename(backup_name, filename) if File.file?(backup_name)
    log("ERROR", "Guardando la base de datos.")
  else
    File.delete(backup_name) if File.file?(backup_name)
  end
end

def access
  File.file?(filename) ? $database = JSON.parse(File.read(filename), :symbolize_names => true) : $database = JSON.parse("[]")
rescue
  log("ERROR", "Cargando la base de datos.")
else
  log("INFO", "Base de datos cargada, hay %i entradas." % [$database.size])
end

def log(type, text, output = true)
  print(message(type, text)) if output
  if CONFIG['autolog'] || CONFIG['autolog'] == nil
    begin
      File.file?("log.txt") ? FileUtils.cp("log.txt", "log_backup.txt") : new_log = true
      File.open("log.txt", "a") do |f|
        f.write(message("info", "Creado nuevo fichero de log de #{CONFIG['program'].upcase}, v#{CONFIG['version']}.\n\n")) if new_log
        f.write(message(type, text))
      end
    rescue
      if File.file?("log.txt") && File.file?("log_backup.txt")
        File.delete("log.txt")
        File.rename("log_backup.txt", "log.txt")
      end
      print(message("error", "Actualizando el log."))
    else
      File.delete("log_backup.txt") if File.file?("log_backup.txt")
    end
  end
end
