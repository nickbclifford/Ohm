#include <stdio.h>
#include <string.h>
#include "smaz.h"

#include "ruby.h"

VALUE BadCompression = Qnil;
VALUE Ohm = Qnil;
VALUE Smaz = Qnil;

// Prototypes
void Init_smaz_ohm();
VALUE method_compress(VALUE self, VALUE str);
VALUE method_decompress(VALUE self, VALUE compressed);

void Init_smaz_ohm() {
	Ohm = rb_const_get(rb_cObject, rb_intern("Ohm"));
	Smaz = rb_define_module_under(Ohm, "Smaz");
	BadCompression = rb_define_class_under(Smaz, "BadCompression", rb_const_get(rb_cObject, rb_intern("StandardError")));

	rb_define_module_function(Smaz, "compress", method_compress, 1);
	rb_define_module_function(Smaz, "decompress", method_decompress, 1);
}

VALUE method_compress(VALUE self, VALUE str) {
	char* output = "";
	int len =  RSTRING_LEN(str);

	// FIXME: At runtime, the following line causes a segfault on my machine.
	int out_size = smaz_compress(RSTRING_PTR(str), len, output, len);
	rb_raise(BadCompression, "this is a test %d: %s", out_size, output);

	return Qnil;
}

VALUE method_decompress(VALUE self, VALUE compressed) {
	return compressed;
}
