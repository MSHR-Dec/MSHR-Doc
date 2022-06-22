"""
Sample Input 0

4
3 2 1 3
Sample Output 0

2
"""


def birthdayCakeCandles(candles: list[int]) -> int:
    tallest = max(candles)
    return candles.count(tallest)
