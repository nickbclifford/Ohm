require 'mkmf'

$CFLAGS << ' -w' # Suppress warnings from Smaz
create_makefile('smaz_ohm')
