`define OPCODE_SPECIAL 6'b000000
`define OPCODE_ORI 6'b001101
`define OPCODE_LW 6'b100011
`define OPCODE_SW 6'b101011
`define OPCODE_BEQ 6'b000100
`define OPCODE_LUI 6'b001111
`define OPCODE_J 6'b000010
`define OPCODE_ADDI 6'b001000
`define OPCODE_ADDIU 6'b001001
`define OPCODE_JAL 6'b000011

`define FUNCT_ADDU 6'b100001
`define FUNCT_SUBU 6'b100011
`define FUNCT_SLT 6'b101010
`define FUNCT_JR 6'b001000

`define word 

`define IFU_SEL_NORM 0 // pc += 4
`define IFU_SEL_RELATIVE 1 // pc = pc + 4 + sign_extend(inst[15:0])
`define IFU_SEL_IRRELATIVE 2 // pc = {(pc+4)[31:30], inst[25:0],2'0}
`define IFU_SEL_REGISTER 3 // pc = npc

`define ALU_SEL_ADD 0
`define ALU_SEL_SUB 1
`define ALU_SEL_OR 2
`define ALU_SEL_SLT 3

`define EXT_SEL_ZERO 0
`define EXT_SEL_SIGN 1
`define EXT_SEL_LUI 2
`define EXT_SEL_RESERVED 3
