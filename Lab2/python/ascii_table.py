def print_ascii_table():
    print("ASCII Table for the English Alphabet")
    print("Character  |  Decimal  |  Hexadecimal")
    print("--------------------------------------")

    # Print uppercase letters
    for char in range(ord('A'), ord('Z') + 1):
        print(f"   {chr(char)}       |    {char:3}     |     {char:02X}")

    # Print lowercase letters
    for char in range(ord('a'), ord('z') + 1):
        print(f"   {chr(char)}       |    {char:3}     |     {char:02X}")


# Call the function to print the ASCII table
print_ascii_table()
