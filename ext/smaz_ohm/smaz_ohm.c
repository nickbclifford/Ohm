#define MAX_COMP_LEN 1024

#include "ruby.h"
#include "smaz.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

VALUE Ohm = Qnil;
VALUE Smaz = Qnil;
VALUE BadCompression = Qnil;
VALUE TooLongError = Qnil;

// Prototypes
void Init_smaz_ohm();
VALUE method_compress(VALUE self, VALUE str);
VALUE method_decompress(VALUE self, VALUE compressed);

void Init_smaz_ohm() {
	Ohm = rb_const_get(rb_cObject, rb_intern("Ohm"));
	Smaz = rb_define_module_under(Ohm, "Smaz");
	BadCompression = rb_define_class_under(Smaz, "BadCompression", rb_const_get(rb_cObject, rb_intern("StandardError")));
	TooLongError = rb_define_class_under(Smaz, "TooLongError", rb_const_get(rb_cObject, rb_intern("StandardError")));

	rb_define_module_function(Smaz, "compress", method_compress, 1);
	rb_define_module_function(Smaz, "decompress", method_decompress, 1);
}

VALUE method_compress(VALUE self, VALUE str) {
	char* str_c = RSTRING_PTR(str);
	int len = strlen(str_c);
	char* output = malloc(len); // This'll be plenty of space, especially since this will be compressed

	int out_size = smaz_compress(str_c, len, output, len);
	if(out_size > len)
		rb_raise(BadCompression, "compressed string is longer than uncompressed");

	return rb_str_new_cstr(output);
}

VALUE method_decompress(VALUE self, VALUE compressed) {
	char* output = malloc(MAX_COMP_LEN);

	int out_size = smaz_decompress(RSTRING_PTR(compressed), RSTRING_LEN(compressed), output, MAX_COMP_LEN);
	if(out_size > MAX_COMP_LEN)
		rb_raise(TooLongError, "decompressed string is longer than maximum length (%d bytes)", MAX_COMP_LEN);

	return rb_str_new_cstr(output);
}
