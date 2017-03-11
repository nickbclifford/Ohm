#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "smaz.h"

#include "ruby.h"

VALUE BadCompression = Qnil;
VALUE Ohm = Qnil;
VALUE Helpers = Qnil;
VALUE Smaz = Qnil;

// Prototypes
void Init_smaz_ohm();
VALUE method_compress(VALUE self, VALUE str);
VALUE method_decompress(VALUE self, VALUE compressed);

void Init_smaz_ohm() {
	Ohm = rb_const_get(rb_cObject, rb_intern("Ohm"));
	Helpers = rb_const_get(Ohm, rb_intern("Helpers"));
	Smaz = rb_define_module_under(Ohm, "Smaz");
	BadCompression = rb_define_class_under(Smaz, "BadCompression", rb_const_get(rb_cObject, rb_intern("StandardError")));

	rb_define_module_function(Smaz, "compress", method_compress, 1);
	rb_define_module_function(Smaz, "decompress", method_decompress, 1);
}

VALUE method_compress(VALUE self, VALUE str) {
	char* str_c = RSTRING_PTR(str);
	int len = RSTRING_LEN(str);
	char* output = malloc(len); // This'll be plenty of space, especially since this will be compressed

	int out_size = smaz_compress(str_c, len, output, len);
	if(out_size > len)
		rb_raise(BadCompression, "compressed string is longer than uncompressed");

	char* hex = malloc(out_size * 2);

	int i;
	for(i = 0; i < len; i++)
		sprintf(hex + i * 2, "%02X", output[i]);

	// Convert big hex string to a number...
	VALUE num = LONG2NUM(strtol(hex, NULL, 16));

	// ...which then gets converted to Ohm's base 220
	return rb_funcall(Helpers, rb_intern("to_base"), 2, num, INT2FIX(220));
}

VALUE method_decompress(VALUE self, VALUE compressed) {
	char* compressed_c = RSTRING_PTR(compressed);
	int len = RSTRING_LEN(compressed);

	// TODO: the rest of this lmao

	return Qnil;
}
