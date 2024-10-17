import numbers
import decimal

## exercise 1
#x = 10
#while x > 0:
#    print(x)
#    x -= 1
#
## exercise 2
#my_dict = {'a': 1, 'b': 2, 'c': 3}
#for key, value in my_dict.items():
#    print(value)

#print(is_even('non int'))

# exercise 4

my_first_list = ['apple', 1, 'banana', 2] 
cal_lookup = {'apple': 95, 'banana': 105, 'orange': 45}

for x in my_first_list: 
    if isinstance(x, numbers.Number): 
        print(f'''square of {x} is: {x**2}''')
    elif isinstance(x, str):
        print(f'''calories for {x} are: {cal_lookup[x]}''')
    else:
        print('Neither number nor fruit')

def square_value_in_dict(my_dict):
    for key,value in my_dict.items(): 
        print(f'''square of {key} is: {value**2}''')

square_value_in_dict(cal_lookup)