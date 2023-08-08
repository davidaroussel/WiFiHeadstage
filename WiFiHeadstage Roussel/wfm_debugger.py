if __name__ == '__main__':
    value = 0x02040600


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
    reg16 = value & 0x10000
    reg17 = value & 0x20000
    reg18 = value & 0x40000


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

    if reg16 > 0:
        reg16 = 1

    if reg17 > 0:
        reg17 = 1

    if reg18 > 0:
        reg18 = 1


    print("Reg18    ", reg18 , "     SPI: Dout_posegde_enable (1: enable, 0: disable))")
    print("Reg17:16 ", reg17, reg16, "   00: both irq’s disabled, 01: data irq enable, 10: wlan rdy irq enable, 11: both irq’s enabled")
    print("Reg15    ", reg15 )
    print("Reg14    ", reg14, "     Cpu_reset (1: cpu reset, 0: cpu non_reset)")
    print("Reg13    ", reg13 )
    print("Reg12    ", reg12, "     Cpu_clk_disable (1: disable clk, 0: enable clk)" )
    print("Reg11    ", reg11 )
    print("Reg10    ", reg10, "     Direct_access_mode (0: queue mode, 1: direct access mode)")
    print("Reg9:8   ", reg9, reg8, "   SPI: Dont care" )
    print("Reg7     ", reg7 )
    print("Reg6     ", reg6 )
    print("Reg5     ", reg5 )
    print("Reg4     ", reg4 )
    print("Reg3     ", reg3 )
    print("Reg2     ", reg2 )
    print("Reg1     ", reg1 )
    print("Reg0     ", reg0 , "     SPI: Err 0 (1: CSN Framing error ,0: no error)")





