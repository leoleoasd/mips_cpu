all: test

tests := ifu_test alu_test

ifu_test := im_1k.v

alu_test :=  

# All things below are generic.

$(foreach test,$(tests), $(eval $(test)+=$(test:_test=).v $(test).v defines.v))

test: $(tests)

define test_template
$1: $1.out
	./$1.out | grep -A 5 "ERROR" && exit 1 || exit 0
$1.out: $$($1)
	iverilog -g2012 -o $1.out $$^
endef

$(foreach test, $(tests), $(eval $(call test_template,$(test))))


.PHONY : clean
clean :
	-rm $(foreach test, $(tests), $(test).out)
