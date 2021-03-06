# TTCrypt thrift cryptoutuls package
# Copyright (C) 2014 by Thrift.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>. 

require "mkmf"


abort 'missing malloc()' unless have_func 'malloc'
abort 'missing free()' unless have_func 'free'

# Give it a name
extension_name = 'ttcrypt'


dir_config(extension_name)
ok = true

unless have_header('gmp.h')
  $stderr.puts "can't find gmp.h, try --with-gmp-include=<path>"
  ok = false
end

unless have_library('gmp', '__gmpz_init')
  $stderr.puts "can't find -lgmp, try --with-gmp-lib=<path>"
  ok = false
end


# This test is actually due to a Clang 3.3 shortcoming, included in OS X 10.9,
# fixed in Clang 3.4:
# http://llvm.org/releases/3.4/tools/clang/docs/ReleaseNotes.html#new-compiler-flags
if try_compile('', '-O6')
  $CFLAGS += ' -Wall -W -O6 -g'
else
  $CFLAGS += ' -Wall -W -O3 -g'
end

cxx11flag = " --std=c++11"

$CXXFLAGS = CONFIG["CXXFLAGS"] unless defined?($CXXFLAGS)
$CXXFLAGS += cxx11flag unless $CXXFLAGS.include?(cxx11flag)

if ok
  create_makefile(extension_name)
else
  $stderr.puts "*********************************************************************"
  $stderr.puts "Your compiler was unable to link to GMP while installing the gmp gem."
  $stderr.puts "Please install GMP before installing the gmp gem."
  $stderr.puts "*********************************************************************"

  raise "Unable to build, correct above errors and rerun"
end

