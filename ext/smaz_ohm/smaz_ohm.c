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
	char* output = ALLOC_N(char, len + 1);
	output[len] = '\0';

	int out_size = smaz_compress(str_c, len, output, len);
	if(out_size > len)
		rb_raise(BadCompression, "compressed string is longer than uncompressed");

	xfree(output);

	return rb_str_new_cstr(output);
}

VALUE method_decompress_c(VALUE self, VALUE compressed) {
	char* comp_c = StringValueCStr(compressed);
	char* output;
	int out_size = 1;
	int len;

	// FIXME: For some reason, the smaz_decompress function stops incrementing out_size after the first iteration, so it goes into an infinite loop.
	do {
		output = REALLOC_N(output, char, out_size + 1);
		output[out_size] = '\0';
		len = strlen(output);
		printf("before decomp | output: %s, len: %d, out_size: %d\n", output, len, out_size);
		out_size = smaz_decompress(comp_c, strlen(comp_c), output, len);
		printf("after decomp | output: %s, len: %d, out_size: %d\n", output, len, out_size);
	} while(out_size > len);

	xfree(output);

	return rb_str_new_cstr(output);
}
