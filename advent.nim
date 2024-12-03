import strformat
import solutions / [day1, day2]

proc solve(day: int, part: int): int {.exportc.} =
  case fmt"{day} - {part}":
    of "1 - 1": return day1.solvePart1()
    of "1 - 2": return day1.solvePart2()
    of "2 - 1": return day2.solvePart1()
    of "2 - 2": return day2.solvePart2()
    else: return -1

echo solve(2, 2)
