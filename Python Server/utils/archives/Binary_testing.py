
def binary_and(bin_str1, bin_str2):
    int1 = int(bin_str1, 2)
    int2 = int(bin_str2, 2)
    result = int1 & int2
    return bin(result)[2:].zfill(max(len(bin_str1), len(bin_str2)))


if __name__ == "__main__":
    # Example usage:
    bin1 = '0b10101011'
    bin2 = '0b00100001'
    and_result = binary_and(bin1, bin2)


    str_value = '00001100'
    # requires (value, 2) to have complement Two binary
    int_value = int(str_value, 2)
    bin_converted = bin(int_value)

    bin_value1 = 0b1001
    bin_value2 = 0b0101
    bin_total = bin_value1 + bin_value2
    bin_and = bin_value1 & bin_value2

    # AND equivalent
    and1 = bin_value1 & bin_value2
    and2 = bin(bin_value1 & bin_value2)

    # OR equivalent
    or1 = bin_value1 | bin_value2
    or2 = bin(bin_value1 | bin_value2)

    # XOR equivalent
    xor1 = bin_value1 ^ bin_value2
    xor2 = bin(bin_value1 ^ bin_value2)

    # NOT equivalent
    not1 = ~bin_value1
    not2 = bin(~bin_value1)

    binary_data = bytes([0b11001100, 0b10101010])  # Equivalent to b'\xcc\xaa'
    print(binary_data)  # Output: b'\xcc\xaa'

    print('Debug')
