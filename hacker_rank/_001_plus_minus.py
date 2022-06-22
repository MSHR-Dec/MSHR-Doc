"""
Sample Input

STDIN           Function
-----           --------
6               arr[] size n = 6
-4 3 -9 0 4 1   arr = [-4, 3, -9, 0, 4, 1]
Sample Output

0.500000
0.333333
0.166667
"""


def plusMinus(arr):
    positive = 0
    negative = 0
    zero = 0

    for _, num in enumerate(arr):
        if num > 0:
            positive += 1
        elif num < 0:
            negative += 1
        else:
            zero += 1

    print(round((positive / len(arr)), 6))
    print(round((negative / len(arr)), 6))
    print(round((zero / len(arr)), 6))
