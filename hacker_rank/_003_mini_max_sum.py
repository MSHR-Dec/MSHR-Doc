"""
Sample Input

1 2 3 4 5
Sample Output

10 14
"""


def miniMaxSum(arr):
    arr.sort()
    print(sum(arr[:4]), sum(arr[1:]))
