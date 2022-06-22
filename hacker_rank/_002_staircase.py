"""
Sample Input

6
Sample Output

     #
    ##
   ###
  ####
 #####
######
"""


def staircase(n):
    for i in range(n):
        print(f'{"#" * (i + 1):{" "}>{n}}')
