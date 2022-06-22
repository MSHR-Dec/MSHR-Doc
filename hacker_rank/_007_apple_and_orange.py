"""
Sample Input 0

7 11
5 15
3 2
-2 2 1
5 -6
Sample Output 0

1
1
"""


def countApplesAndOranges(s, t, a, b, apples, oranges):
    apples_in_the_house = sum([1 for _, apple in enumerate(apples) if s <= apple + a <= t])
    oranges_in_the_house = sum([1 for _, orange in enumerate(oranges) if s <= orange + b <= t])

    print(apples_in_the_house)
    print(oranges_in_the_house)
