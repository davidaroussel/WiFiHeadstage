

if __name__ == '__main__':
    value = 0X7062

    reg0 = value & 0x01
    reg1 = value & 0x02
    reg2 = value & 0x04
    reg3 = value & 0x08
    reg4 = value & 0x10
    reg5 = value & 0x20
    reg6 = value & 0x40
    reg7 = value & 0x80
    reg8 = value & 0x100
    reg9 = value & 0x200
    reg10 = value & 0x400
    reg11 = value & 0x800
    reg12 = value & 0x1000
    reg13 = value & 0x2000
    reg14 = value & 0x4000
    reg15 = value & 0x8000

    if reg0 > 0:
        reg0 = 1

    if reg1 > 0:
        reg1 = 1

    if reg2 > 0:
        reg2 = 1

    if reg3 > 0:
        reg3 = 1

    if reg4 > 0:
        reg4 = 1

    if reg5 > 0:
        reg5 = 1

    if reg6 > 0:
        reg6 = 1

    if reg7 > 0:
        reg7 = 1

    if reg8 > 0:
        reg8 = 1

    if reg9 > 0:
        reg9 = 1

    if reg10 > 0:
        reg10 = 1

    if reg11 > 0:
        reg11 = 1

    if reg12 > 0:
        reg12 = 1

    if reg13 > 0:
        reg13 = 1

    if reg14 > 0:
        reg14 = 1

    if reg15 > 0:
        reg15 = 1

    print("Reg15:14 ", reg15, reg14 )
    print("Reg13    ", reg13 )
    print("Reg12    ", reg12 )
    print("Reg11    ", reg11 )
    print("Reg10    ", reg10 )
    print("Reg9     ", reg9)
    print("Reg8     ", reg8)
    print("Reg7     ", reg7 )
    print("Reg6     ", reg6 )
    print("Reg5     ", reg5 )
    print("Reg4     ", reg4 )
    print("Reg3     ", reg3 )
    print("Reg2     ", reg2 )
    print("Reg1     ", reg1 )
    print("Reg0     ", reg0 )






