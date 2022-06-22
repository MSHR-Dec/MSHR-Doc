"""
Sample Input 0

4
73
67
38
33
Sample Output 0

75
67
40
33
"""


def gradingStudents(grades):
    results = []
    for _, grade in enumerate(grades):
        if grade < 38:
            results.append(grade)
            continue

        diff = 5 - grade % 5
        if diff < 3:
            results.append(grade + diff)
        else:
            results.append(grade)
    return results
