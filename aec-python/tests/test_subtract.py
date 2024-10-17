import unittest 
from calc import aec_subtract

class TestSubtract(unittest.TestCase):
    
    def test_subtract(self):
            arg_ints = [20,5]
            result = aec_subtract(arg_ints)
            self.assertEqual(result,15)

    def test_max_numbers(self):
            arg_ints = [20,5,20]
            with self.assertRaises(Exception) as context:
                result = aec_subtract(arg_ints)
            self.assertTrue('this function takes a max of 2 numbers' in str(context.exception))

if __name__ == '__main__': 
    unittest.main()