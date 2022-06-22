"""
Sample Input 0

07:05:45PM
Sample Output 0

19:05:45
"""


def timeConversion(s: str) -> str:
    hms_list = s.split(':')
    if hms_list[0] != "12" and "AM" in hms_list[2]:
        return s.replace("AM", "")

    if hms_list[0] == "12":
        if "PM" in hms_list[2]:
            return s.replace("PM", "")
        else:
            return "00:" + hms_list[1] + ":" + hms_list[2].replace("AM", "")

    return str(int(hms_list[0]) + 12) + ":" + hms_list[1] + ":" + hms_list[2].replace("PM", "")
