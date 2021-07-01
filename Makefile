all: test

test: ifu_test

ifu_test: ifu_test.out
	./ifu_test.out | grep -A 5 "ERROR" || exit 0

ifu_test.out: ifu.v test.v im_1k.v defines.v
	iverilog -g2012 -o ifu_test.out defines.v ifu.v im_1k.v test.v
