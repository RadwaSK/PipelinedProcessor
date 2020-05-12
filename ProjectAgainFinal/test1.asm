#this is a comment 

.ORG 0
10
.ORG 2
10

#this program has no logical function 
.ORG 10
INC R0 #try comment beside code
DEC R1
NOP
NOT R5
OUT R2
CALL R4
JMP R6
IN R7
JZ R0
RET
RTI
NOP
NOP
Interrupt

SWAP R0 ,R1
#please consider the spaces or it will be an error
ADD R5 ,R6 ,R1
SUB R5 ,R6 ,R1
AND R5 ,R7 ,R1
OR R0 ,R2 ,R6


IADD R5 ,R6 ,5
SHL R4 ,4
SHR R2 ,6


PUSH R0
POP R1
LDM R2 ,30

LDD R6 ,10021
STD R3 ,110C0