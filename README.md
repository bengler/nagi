# Nagi

A Ruby DSL for writing Nagios plugins. It handles the tedium of argument
parsing, exit statuses, output formatting and such, and lets you focus on
writing the actual check.

Written by Erik Grinaker &lt;erik@bengler.no&gt;, and licensed under the
GNU GPL v3.

## Example

A very simple plugin looks like this:

```ruby
#!/usr/bin/env ruby
require 'nagi'

Nagi do
  name 'check_true'
  version '0.1'
  prefix 'TRUE'

  check do |args|
    if true
      ok 'True is still true'
    else
      critical 'Uh oh'
    end
  end
end
```

The first few methods just set some basic info for the plugin - the name,
version, and a prefix for the check output. These are all optional.

Next, the check block is defined, which runs the actual Nagios check. `args`
will contains any options (see command-line parsing below), and the methods ok,
warning, critical, and unknown are used to return the check status. A missing
status or uncaught exception will result in an 'unknown' status.

The plugin is run as any regular script - save it as a file, make it executable
and run it:

```
$ ./test.rb 
TRUE OK: True is still true
```

### Command-line options

Nagi can automatically parse command-line arguments when requested, and provide
them as input to the check block. Here is a simple example:

```ruby
#!/usr/bin/env ruby
require 'nagi'
require 'resolv'

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
      critical "#{args[:hostname]} resolves to #{ip}, expected #{args[:ip]}"
    else
      ok "#{args[:hostname]} resolves to #{ip}"
    end
  end
end
```

The `argument` method specifies a required positional argument, and only takes
the name of the argument. `switch` specifies an optional switch, which may or
may not take an argument of its own. The first `switch` parameter is its name,
while the rest are passed to the standard Ruby OptionParser.on method - see its
documentation for details.

The parsed arguments are passed to the `check` block via the `args` parameter,
which is a hash containing argument names and values. In the case of a switch
with no argument of its own, the value will be `true`.

A few usage examples of this plugin:

```
$ ./check_dns.rb 
Error: Argument 'hostname' not given

Usage: ./check_dns.rb [options] <hostname>
    -i, --ip IP                      Expected IP address
    -h, --help                       Display this help message
    -V, --version                    Display version information

$ ./check_dns.rb www.google.com
DNS OK: www.google.com resolves to 173.194.35.148

$ ./check_dns.rb -i 1.2.3.4 www.google.com
DNS CRITICAL: www.google.com resolves to 173.194.35.148, expected 1.2.3.4
```

Nagi will automatically set up the -h/--help and -V/--version switches and
handle them appropriately.

### Handling multiple statuses

In some cases it is useful to collect several statuses and return the most
severe, rather than returning the first status encountered. This is typically
used when monitoring multiple resources with a single check.

The `collect` setting tells Nagi to continue running the check when a status
is given. It can be set to either `:severe`, in which case the most severe
status will be returned at the end, or `:all` which will use the most severe
status code but also combine all status messages into one.

However, one can still force a status to return from the check, and ignore
the collected statues, by setting the second parameter (`force`) to `true`
for the status methods.

This example checks used space on all disk drives, and returns critical if
any of the drives are above a threshold:

```ruby
#!/usr/bin/env ruby
require 'nagi'

Nagi do
  name 'check_df'
  version '0.1'
  prefix 'DF'
  argument :percentage
  collect :all

  check do |args|
    begin
      output = execute 'df'
    rescue StandardError => e
      critical "df failed: #{e.message}", true
    end
    output.lines.each do |line|
      if line =~ /^.*?(\d+)%\s*(.*)$/
        if $1.to_i > args[:percentage].to_i
          critical "#{$2} #{$1}% used"
        else
          ok "#{$2} #{$1}% used"
        end
      end
    end
  end
end
```

When run, it will output something like this:

```
$ ./check_df.rb 90
DF OK: / 80% used, /Volumes/Media 57% used

$ ./check_df.rb 70
DF CRITICAL: / 80% used, /Volumes/Media 57% used
```

## Reference

### Plugin info

These describe the program, and are usually given first, if necessary.

* `name` *name*: the program name.
* `version` *version*: the program version.
* `prefix` *prefix*: a prefix for the check output.
* `collect` *type*: collect statuses and continue the check, rather than
  returning. *type* can be either `:severe` or `:all` - `:severe` will
  return the last, most severe status, and `:all` will use the most severe
  status but join all the status messages together into one.
* `fallback` *status*, *message*: a default status to return if the check
  doesn't explicitly return one. *status* can be `:ok`, `:warning`, `:critical`,
  or `:unknown`.

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

The `collect` setting (see above) can be used to collect statuses and continue
the check, rather than returning the first status encountered. However, if
`true` is passed as the second parameter of the status method, it will
return the status regardless of the `collect` setting.

* `check` *block*: the code block the the check. Parsed command-line arguments
  are passed as a hash.
* `ok` *message*, *force=false*: returns an OK status.
* `warning` *message*, *force=false*: returns a Warning status.
* `critical` *message*, *force=false*: returns a Critical status.
* `unknown` *message*, *force=false*: returns an Unknown status.
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
