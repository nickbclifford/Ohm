#define MAX_COMP_LEN 1024

#include "ruby.h"
#include "smaz.h"
#include <string.h>

VALUE Ohm = Qnil;
VALUE Smaz = Qnil;
VALUE BadCompression = Qnil;
VALUE TooLongError = Qnil;

// Prototypes
void Init_smaz_ohm();
VALUE method_compress_c(VALUE self, VALUE str);
VALUE method_decompress_c(VALUE self, VALUE compressed);

void Init_smaz_ohm() {
	Ohm = rb_const_get(rb_cObject, rb_intern("Ohm"));
	Smaz = rb_define_module_under(Ohm, "Smaz");
	BadCompression = rb_define_class_under(Smaz, "BadCompression", rb_const_get(rb_cObject, rb_intern("StandardError")));
	TooLongError = rb_define_class_under(Smaz, "TooLongError", rb_const_get(rb_cObject, rb_intern("StandardError")));

	rb_define_module_function(Smaz, "compress_c", method_compress_c, 1);
	rb_define_module_function(Smaz, "decompress_c", method_decompress_c, 1);
}

VALUE method_compress_c(VALUE self, VALUE str) {
	// We use Ruby's ALLOC macro instead of C's native malloc() so that it gets garbage collected.
	// Still kind of broken though :^)
	char* output = ALLOC(char);
	int len = RSTRING_LEN(str);

	int out_size = smaz_compress(RSTRING_PTR(str), len, output, len);
	if(out_size > len)
		rb_raise(BadCompression, "compressed string is longer than uncompressed");

	return rb_str_new_cstr(output);
}

VALUE method_decompress_c(VALUE self, VALUE compressed) {
	char* output = ALLOC(char);

	int out_size = smaz_decompress(RSTRING_PTR(compressed), RSTRING_LEN(compressed), output, MAX_COMP_LEN);
	if(out_size > MAX_COMP_LEN)
		rb_raise(TooLongError, "decompressed string is longer than maximum length (%d bytes)", MAX_COMP_LEN);

	return rb_str_new_cstr(output);
}
