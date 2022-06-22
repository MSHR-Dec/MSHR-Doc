"""
Constraints

Sample Input 0

0 3 4 2
Sample Output 0

YES

Sample Input 1

0 2 5 3
Sample Output 1

NO
"""


def kangaroo(x1, v1, x2, v2):
    if v1 <= v2:
        return "NO"

    if (x2 - x1) % (v1 - v2) == 0:
        return "YES"

    return "NO"
