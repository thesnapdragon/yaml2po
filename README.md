# yaml2po and po2yaml

**yaml2po** is a script for converting YML or YAML translation files to Gettext PO or POT

**po2yaml** is a script for converting to Gettext PO to YML or YAML translation files

* [PO file format reference](https://www.gnu.org/software/gettext/manual/html_node/PO-Files.html)
* [YML file format reference](http://www.yaml.org/)

Developed from the homonymous scripts found in http://git.openstreetmap.org/rails.git/tree/HEAD:/script/locale

## yaml2po usage mode

 * Create a language's POT from a given YML file

~~~ {.bash}
 $ yaml2po en.yml en.pot
~~~


## po2yaml usage mode

 * Create a language's YML from a given PO file

~~~ {.bash}
 $ po2yaml en.po en.yml
~~~

## License

This software is licensed under the GNU General Public License 2.0 (http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt), a copy of which can be found in the LICENSE file.
