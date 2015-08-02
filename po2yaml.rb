#!/usr/bin/env ruby
#
# po2yaml, for converting gettext .po to the RoR translation YAML
#
# Developed from scripts found in http://git.openstreetmap.org/rails.git/tree/HEAD:/script/locale
#
# Usage:
#  - To create a language's yaml from a given po file
#    po2yaml de.po de.yml
#
#
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



def add_translation(translations, path, string)
  key = path.shift
  if path.empty?
    translations[key] = string
  else
    translations[key] = {} unless translations.has_key? key
    add_translation(translations[key], path, string)
  end
  translations
end



def po2hash(pofile)
  translations = {}
  path = []
  string = ''
  pofile.each_line do |line|
    line.strip!
    if /^msgctxt "(?<msgctxt>.*)"$/ =~ line
      path = msgctxt.split(':')
    elsif /^msgstr "(?<msgstr>.*)"$/ =~ line
      string = msgstr
    end

    if !path.empty? and !string.empty?
      add_translation(translations, path, string)
    end
  end
  translations
end



def generate_yaml(pofile_name, ymlfile_name)
  if File.exists? pofile_name
    File.open(pofile_name, "r") do |pofile|
      langcode = File.basename(pofile_name, '.po')
      translations = {langcode => po2hash(pofile)}
      File.open(ymlfile_name, "w") { |outfile| outfile.puts(translations.to_yaml) }
    end
  else
    $stderr.puts("\nError: Specified PO file \"#{pofile_name}\" does not exist.\n\n")
  end
end



def print_usage()
  puts("\nUsage:\n")
  puts("  - To create a language's yaml from a given po file\n")
  puts("    po2yaml de.po de.yml\n\n")
end



if ARGV.size == 2
  generate_yaml(ARGV[0], ARGV[1])
  exit
end

print_usage()
