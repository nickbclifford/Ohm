#define MAX_COMP_LEN 1024

#include "ruby.h"
#include "smaz.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

VALUE Smaz = Qnil;
VALUE BadCompression = Qnil;
VALUE TooLongError = Qnil;

// Prototypes
void Init_smaz_ohm();
VALUE method_compress_c(VALUE self, VALUE str);
VALUE method_decompress_c(VALUE self, VALUE compressed);

void Init_smaz_ohm() {
	Smaz = rb_define_module_under(rb_const_get(rb_cObject, rb_intern("Ohm")), "Smaz");
	BadCompression = rb_define_class_under(Smaz, "BadCompression", rb_const_get(rb_cObject, rb_intern("StandardError")));
	TooLongError = rb_define_class_under(Smaz, "TooLongError", rb_const_get(rb_cObject, rb_intern("StandardError")));

	rb_define_module_function(Smaz, "compress_c", method_compress_c, 1);
	rb_define_module_function(Smaz, "decompress_c", method_decompress_c, 1);
}

VALUE method_compress_c(VALUE self, VALUE str) {
	char* str_c = StringValueCStr(str);
	int len = strlen(str_c);

	// We use Ruby's ALLOC macro instead of C's native malloc() so that it invokes the garbage collector.
	char* output = ALLOC(char);

	int out_size = smaz_compress(str_c, len, output, len);
	if(out_size > len)
		rb_raise(BadCompression, "compressed string is longer than uncompressed");

	free(output);

	return rb_str_new_cstr(output);
}

VALUE method_decompress_c(VALUE self, VALUE compressed) {
	char* comp_c = StringValueCStr(compressed);

	char* output = ALLOC(char);

	// This is slightly broken, not sure why. Compression still works fine?
	int out_size = smaz_decompress(comp_c, strlen(comp_c), output, MAX_COMP_LEN);
	if(out_size > MAX_COMP_LEN)
		rb_raise(TooLongError, "decompressed string is longer than maximum length (%d bytes)", MAX_COMP_LEN);

	free(output);

	return rb_str_new_cstr(output);
}
