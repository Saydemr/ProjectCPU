

16-bit Instruction Word (IW) of ProjectCPU:

                              IW 
               |----------------------------------|
  bit position |15    13 | 12                    0|
               |----------------------------------|
    field name | opcode |           A             |
               |----------------------------------|
     bit width |   3b   |          13b            |
               |----------------------------------|
	       
			   
(Every memory location and W are 16 bits)

Instruction Set of ProjectCPU:

ADD   -> unsigned Add
         opcode = 0
         W = W + (*A)
         write(readFromAddress(A) +W) to W
         *A = value (content of) address A = mem[A] (mem means memory)
         = means write (assign)

NOR   -> bitwise NOR
         opcode = 1                  
         W = ~(W | (*A))             

SRRL  -> Shift Rotate Right or Left
         opcode = 2
         if((*A) is less than 16) W = W >> (*A)   
		 else if((*A) is between 16 and 31) W = W << lower4bits(*A)
		 else if((*A) is between 32 and 47) W = RotateRight W by lower4bits(*A)
		 else W = RotateLeft W by lower4bits(*A)

GT    -> Unsigned Greater Than
         opcode = 3
         W = W > (*A)            

SZ    -> Skip on Zero
         opcode = 4
         PC = ((*A) == 0) ? (PC+2) : (PC+1)
		 
CP2W  -> Copy to W
         opcode = 5
         W = *A           

CPfW  -> Copy from W    CPfW 0         
         opcode = 6                     
         *A = W

JMP   -> Jump
         opcode = 7
         PC = lower13bits(*A)
		 
INDIRECT ADRESSING

There are no special instructions for indirect addressing. Instead, every instruction
can operate in indirect addressing mode.

That is, if A==0, replace *A above with **2.

Every program starts like this:

0: JMP 1
1: 3
2: // indirection register
3: // program actually starts here
