require 'mkmf'

$CFLAGS << ' -w' # Suppress warnings from Smaz because I'm not sure how to fix them
create_makefile('smaz_ohm')
