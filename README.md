# Nagi

A Ruby DSL for writing Nagios plugins. It handles the tedium of argument
parsing, exit statuses, output formatting and such, and lets you focus on
writing the actual check.

Written by Erik Grinaker &lt;erik@bengler.no&gt;, and licensed under the
GNU GPL v3.

## Example

A typical plugin looks like this:

```ruby
#!/usr/bin/env ruby

require 'nagi'
require Resolv

Nagi do
  name 'check_dns'
  version '0.1'
  prefix 'DNS'
  argument :hostname
  switch :ip, '-i', '--ip IP', 'Expected IP address'

  check do |args|
    begin
      ip = Resolv.getaddress(args[:hostname])
    rescue Resolv::ResolvError => e
      critical e.message
    end

    if args[:ip] and ip != args[:ip]
      critical "#{args[:hostname]} resolves to #{ip}, expected #{args[:ip]}
    else
      ok "#{args[:hostname]} resolves to #{ip}"
    end
  end
end
```

Here we first set up some basic info like name and version, and specify a few
command-line options. Then we write a block of code containing the actual
check, which is given the parsed command-line options as a hash, and returns a
status via methods like `ok` and `critical`.

To run the plugin, type `./check_dns.rb --ip 127.0.0.1 localhost`, or try
`./check_dns.rb --help` for more info.

## Reference

### Metadata

These describe the program, and are usually given first, if necessary.

* `name` *name*: the program name.
* `version` *version*: the program version.
* `prefix` *prefix*: a prefix for the check output.

### Command-line arguments

Command-line arguments can be specified, and will be parsed automatically and
passed to the `check` method as a hash, with keys given by the argument name.

* `argument` *name*: a mandatory, positional argument.
* `switch` *name*, *args*: an optional switch. *args* are passed directory to
  the standard Ruby OptionParser class - see its documentation for details.

Command-line arguments for -h/--help and -V/--version are added and handled
automatically.

### Check

The check is given as a code block to the `check` method, and is passed the
parsed command-line arguments as a hash. It should use one of the methods `ok`,
`warning`, `critical`, or `unknown` to return a status. If no status is given,
or the block raises an unhandled exception, an Unknown status will be returned.

* `check` *block*: the code block the the check. Parsed command-line arguments
  are passed as a hash.
* `ok` *message*: returns an OK status.
* `warning` *message*: returns a Warning status.
* `critical` *message*: returns a Critical status.
* `unknown` *message*: returns an Unknown status.
* `execute` *command*: executes a shell command, and returns any output (both
  stdout and stderr). If the command exits with a non-zero status, it will
  throw an exception. The shell is set to use the `pipefail` option, so non-zero
  exit statuses in pipelines are detected as well.

## License

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
