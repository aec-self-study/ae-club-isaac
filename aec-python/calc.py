# calc.py

import argparse
from functools import reduce

parser = argparse.ArgumentParser(description="CLI Calculator.")

subparsers = parser.add_subparsers(help="sub-command help", dest="command")

add = subparsers.add_parser("add", help="sum arbitrary number of integers")
add.add_argument("ints_to_sum", nargs="*", type=int)

sub = subparsers.add_parser("sub", help="subtract first input integer from second")
sub.add_argument("ints_to_sub", nargs="*", type=int)

mult = subparsers.add_parser("mult", help="multiply arbitrary number of integers")
mult.add_argument("ints_to_mult", nargs="*", type=int)

div = subparsers.add_parser("div", help="divide first input integer by second")
div.add_argument("ints_to_div", nargs="*", type=int)


def aec_subtract(ints_to_sub):
    if len(ints_to_sub) > 2:
        raise Exception("this function takes a max of 2 numbers")

    our_sub = ints_to_sub[0] - ints_to_sub[1]
    print(f"the subtracted result of values is: {our_sub}")
    return our_sub


def aec_divide(ints_to_divide):
    if len(ints_to_divide) > 2:
        raise Exception("this function takes a max of 2 numbers")

    if ints_to_divide[1] == 0:
        print("cannot divide by zero")
        return 0
    else:
        quotient = ints_to_divide[0] / ints_to_divide[1]
        print(f"The quotient of the inputs is {quotient}")
        return quotient


if __name__ == "__main__":

    args = parser.parse_args()

    if args.command == "add":
        our_sum = sum(args.ints_to_sum)
        print(f"the sum of values is: {our_sum}")

    if args.command == "sub":
        aec_subtract(args.ints_to_sub)

    if args.command == "mult":
        our_product = reduce(lambda x, y: x * y, list(args.ints_to_mult))
        print(f"The product of the inputs is  {our_product}")

    if args.command == "div":
        aec_divide(args.ints_to_div)
