all: test

tests := ifu alu dm extender gpr alu_src_mux gpr_write_mux mips

# define extra dependences.
ifu := im_1k.v npc.v
mips := alu.v alu_src_mux.v controller.v decoder.v defines.v dm.v extender.v gpr.v gpr_write_addr_mux.v gpr_write_mux.v ifu.v im_1k.v mips.v
# All things below are generic.

# add common dependences.
$(foreach test,$(tests), $(eval $(test)+=$(test).v $(test)_test.v defines.v))

.PHONY : test
test: $(tests:=_test)

build: $(tests:=_test.out)

# generate targets and requiremnts for tests.
define test_template
$1_test: $1_test.out
	./$1_test.out | grep -A 5 "ERROR" && exit 1 || exit 0
$1_test.out: $$($1)
	iverilog -g2012 -o $1_test.out $1_test.v
endef

$(foreach test, $(tests), $(eval $(call test_template,$(test))))


.PHONY : clean
clean :
	-rm $(foreach test, $(tests), $(test)_test.out)
