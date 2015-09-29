Gem::Specification.new do |s|
  s.name = "yaml2po"
  s.version = "1.0.0"
  s.date = "2015-09-29"
  s.summary = "Script for converting YML or YAML translation files to Gettext PO or POT"
  s.description   = <<-TEXT
yaml2po is a script for converting YML or YAML translation files to Gettext PO or POT.
po2yaml is a script for converting to Gettext PO to YML or YAML translation files.
TEXT
  s.authors = ["Milan Unicsovics"]
  s.email = "milan.unicsovics@emarsys.com"
  s.files = `git ls-files`.split("\n")
  s.executables = ["po2yaml", "yaml2po"]
  s.require_paths = ["bin"]
  s.homepage = "https://github.com/thesnapdragon/yaml2po"
  s.license = "GPL2"

  s.required_ruby_version = ">= 2.0.0"

  s.add_runtime_dependency "slop", "~> 4"
end