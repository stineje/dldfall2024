# Python3 code to demonstrate working of
# Convert String list to ASCII values
 
# initialize list with text
test_list = ['Hello, SHA-256!']
 
# printing original list 
print("The original list : " + str(test_list))
 
# Convert String list to ascii values
# using loop + ord()
res = []
for ele in test_list:
    res.extend(hex(ord(num)) for num in ele)
 
# printing result
print("The ascii list is : " + str(res))
