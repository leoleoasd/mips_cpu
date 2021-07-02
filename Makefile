all: test

tests := ifu_test alu_test dm_test extender_test

ifu_test := im_1k.v

# All things below are generic.

# add common dependences.
$(foreach test,$(tests), $(eval $(test)+=$(test:_test=).v $(test).v defines.v))

.PHONY : test
test: $(tests)

build: $(tests:=.out)

# generate targets and requiremnts for tests.
define test_template
$1: $1.out
	./$1.out | grep -A 5 "ERROR" && exit 1 || exit 0
$1.out: $$($1)
	iverilog -g2012 -o $1.out $1.v
endef

$(foreach test, $(tests), $(eval $(call test_template,$(test))))


.PHONY : clean
clean :
	-rm $(foreach test, $(tests), $(test).out)
