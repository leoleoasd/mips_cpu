all: test

tests := ifu alu dm extender gpr alu_src_mux gpr_write_mux

# define extra dependences.
ifu := im_1k.v

# All things below are generic.

# add common dependences.
$(foreach test,$(tests), $(eval $(test)+=$(test).v $(test)_test.v defines.v))

.PHONY : test
test: $(tests:=_test)

build: $(tests:=.out)

# generate targets and requiremnts for tests.
define test_template
$1_test: $1_test.out
	./$1.out | grep -A 5 "ERROR" && exit 1 || exit 0
$1_test.out: $$($1)
	iverilog -g2012 -o $1.out $1.v
endef

$(foreach test, $(tests), $(eval $(call test_template,$(test))))


.PHONY : clean
clean :
	-rm $(foreach test, $(tests), $(test)_test.out)
