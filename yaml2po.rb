#!/usr/bin/env ruby
#
# yaml2po, for converting RoR translation YAML to the standard gettext for
#          eventual use with a translation site such as Transifex or a CAT tool
#
# Developed from scripts found in http://git.openstreetmap.org/rails.git/tree/HEAD:/script/locale
#
# Usage:
#  - To create a 'master' .pot
#    yaml2po -i en.yml -o en.pot
#
# Copyright (C) 2015 Milan Unicsovics <u.milan AT gmail DOT com>
# Copyright (C) 2012 Leandro Regueiro <leandro.regueiro AT gmail DOT com>
# Copyright (C) 2009 Thomas Wood
# Copyright (C) 2009 Tom Hughes
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require 'rubygems'
require 'bundler/setup'

require 'yaml'
require 'time'
require 'slop'



def add_header(potfile, language_code)
  current_time = Time.now.strftime('%Y-%m-%-d %H:%M%z')
  header = <<HEADER
# SOME DESCRIPTIVE TITLE.
# Copyright (C) YEAR THE PACKAGE\'S COPYRIGHT HOLDER
# This file is distributed under the same license as the PACKAGE package.
# FIRST AUTHOR <EMAIL@ADDRESS>, YEAR.
#
msgid ""
msgstr ""
"Project-Id-Version: PACKAGE VERSION\\n"
"Report-Msgid-Bugs-To: <EMAIL@ADDRESS>\\n"
"POT-Creation-Date: #{current_time}\\n"
"PO-Revision-Date: YEAR-MO-DA HO:MI+ZONE\\n"
"Last-Translator: FULL NAME <EMAIL@ADDRESS>\\n"
"Language-Team: #{language_code} <#{language_code}@li.org>\\n"
"MIME-Version: 1.0\\n"
"Content-Type: text/plain; charset=UTF-8\\n"
"Content-Transfer-Encoding: 8bit\\n"

HEADER
  potfile.write header
end



def flatten_hash(my_hash, parent = [])
  my_hash.flat_map do |key, value|
    case value
      when Hash then
        flatten_hash(value, parent+[key])
      else
        [(parent+[key]).join(':'), value]
    end
  end
end



def escape(string)
  new_string = string.gsub("\"", "\\\"")
  new_string.gsub("\n", "\"\n\"")
end



def generate_pot(ymlfile_name, potfile_name)
  pot_language_code = File.basename(potfile_name, File.extname(potfile_name))
  yml = YAML.load_file(ymlfile_name)[pot_language_code]
  translations = Hash[*flatten_hash(yml)]
  File.open(potfile_name, 'w') do |potfile|
    add_header(potfile, pot_language_code)
    translations.each do |path, translation|
      if translation.is_a? String
        potfile.puts "msgctxt \"#{escape(path)}\""
        potfile.puts "msgid \"#{escape(translation)}\""
        potfile.puts "msgstr \"#{escape(translation)}\""
        potfile.puts ''
      end
    end
  end
end



def options_checked(options)
  if File.readable? options[:input]
    if File.writable? Dir.pwd
      return true
    else
      $stderr.puts "Error: Specified POT file #{options[:output]} can not be created."
    end
  else
    $stderr.puts "Error: Specified YML file #{options[:input]} is not readable."
  end
  false
end



begin
  options = Slop.parse do |option|
    option.string '-i', '--input', 'input YML file'
    option.string '-o', '--output', 'output POT file'
    option.separator ''
    option.separator 'other options:'
    option.on '-v', '--version' do
      puts '1.0'
      exit
    end
    option.on '-h', '--help' do
      puts option
      exit
    end
  end
  options = options.to_hash
  if options[:input].nil? or options[:output].nil?
    raise Slop::Error, 'missing argument for input or output'
  else
    generate_pot(options[:input], options[:output]) if options_checked(options)
  end
rescue Slop::Error => error
  puts error.message
end
