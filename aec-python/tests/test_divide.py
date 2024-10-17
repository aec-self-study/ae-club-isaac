import unittest 
from calc import aec_divide

class TestDivide(unittest.TestCase):
    
    def test_divide(self):
        arg_ints = [20,5]
        result = aec_divide(arg_ints)
        self.assertEqual(result,4)

    def test_divide_zero_case(self):
        arg_ints = [20,0]
        result = aec_divide(arg_ints)
        self.assertEqual(result,0)

    def test_max_numbers(self):
        arg_ints = [20,5,20]
        with self.assertRaises(Exception) as context:
            result = aec_divide(arg_ints)
        self.assertTrue('this function takes a max of 2 numbers' in str(context.exception))

if __name__ == '__main__': 
    unittest.main()