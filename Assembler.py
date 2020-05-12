RegDict = {"R0": "000",
"R1": "001",
"R2": "010",
"R3": "011",
"R4": "100",
"R5": "101",
"R6": "110",
"R7": "111" ,
",R0": "000",
",R1": "001",
",R2": "010",
",R3": "011",
",R4": "100",
",R5": "101",
",R6": "110",
",R7": "111"}


OneOP = {"NOP": "000",
"NOT": "001",
"INC": "010",
"DEC": "011",
"OUT": "100",
"IN": "101"}

TwoOp = {"SWAP": "000",
         "ADD": "001",
         "SUB": "011",
         "AND": "100" ,
         "OR": "101"}

TwoOpValue = {"IADD": "010" , "SHL": "110" , "SHR": "111"}

BrOp = {"JZ": "000","JMP": "001","CALL": "010"}
BrOpNo = {"RET": "011","RTI": "100"}

InSig = {"Reset": "0", "Interrupt": "1"}

MemOp = {"PUSH": "000" , "POP": "001" , "LDM": "010"}
MemEff = {"LDD": "011" , "STD": "100"}


def AddessMaker(x):
    res = bin(int(x, 16)).zfill(33)
    return res.replace('b','0')[1:]

def ValueMaker(x):
    res = bin(int(x, 16)).zfill(17)
    return res.replace('b','0')[1:]

def Effectiveaddress(x):
    res = bin(int(x, 16)).zfill(21)
    return res.replace('b', '0')[1:]


name = input ("Enter file name: ")
code = open(name, "r")
lines = list()
for line in code:
    lines.append(line.strip())


print(lines)

out = open("asm.data","w+")

assembly = list()
for i in range(len(lines)):
    words = lines[i].split()
    if  lines[i] == "":
        pass

    elif lines[i][0] == '#':
        pass

    elif words[0] == ".ORG"  and words[1] == "0":
        i += 1
        #assuming the input numbers are HEX
        add = AddessMaker(lines[i])
        assembly.insert(1,add[0:16])
        assembly.insert(0, add[16:])
    elif words[0] == ".ORG"  and words[1] == "2":
        i+=1
        add = AddessMaker(lines[i])
        assembly.insert(3, add[0:16])
        assembly.insert(2, add[16:])
    elif words[0] == ".ORG" and not words[1] == "2" and not words[1] == "0":
        l =len(assembly)
        for j in range( l , int (words[1],16)):
            assembly.append("0000000000000000")

    elif words[0] in OneOP.keys():
        if words[0] == "NOP":
            assembly.append("000" + OneOP[words[0]] + "000" + "0000000")
        else:
            assembly.append("000" + OneOP[words[0]] + RegDict[words[1]]+ "0000000")

    elif words[0] in BrOp.keys():
        assembly.append("011" + BrOp[words[0]] + RegDict[words[1]] + "0000000")

    elif words[0] in BrOpNo.keys():
        assembly.append("011" + BrOpNo[words[0]] + "000" + "0000000")

    elif words[0] in InSig.keys():
        assembly.append("100" + InSig[words[0]] + "10" + "0000000000")

    elif words[0] in TwoOp.keys():
        if words[0] == "SWAP":
            assembly.append("001" + TwoOp["SWAP"] +  RegDict[words[2]] + "000" +RegDict[words[1]] + "0")
        else:
            assembly.append("001" + TwoOp[words[0]] +  RegDict[words[3]] + RegDict[words[2]] + RegDict[words[1]] + "0")

    elif words[0] in TwoOpValue.keys():
        words = words
        if words[0] == "IADD":
            assembly.append("001010" + RegDict[words[2]] + "000" + RegDict[words[1]] + '0')
            imm = ValueMaker(words[3][1:])
            assembly.append(imm)
        else:
            assembly.append("001" + TwoOpValue[words[0]] + RegDict[words[1]] + "0000000")
            imm = ValueMaker(words[2][1:])
            assembly.append(imm)

    elif words[0] in MemOp.keys():
        if words[0] == "LDM":
            assembly.append("010" + MemOp["LDM"] + RegDict[words[1]] + "0000000")
            imm = ValueMaker(words[2][1:])
            assembly.append(imm)
        else:
            assembly.append("010" + MemOp[words[0]] + RegDict[words[1]] + "0000000")

    elif words[0] in MemEff.keys():
        eff = Effectiveaddress(words[2][1:])
        assembly.append("010" + MemEff[words[0]] + RegDict[words[1]] + "000" + eff[0:4]) #MSB
        assembly.append(eff[4:])
    else:
        pass


for o in assembly:
    out.write(o + "\n")
for o in range (2**12 - len(assembly)):
    out.write("0"*16 + "\n")