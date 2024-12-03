import strformat
import strutils
import regex
import std/algorithm
import std/sequtils
import math

func getInput(): string

func getLevels(): seq[seq[int]] =
  var levels: seq[seq[int]] = @[]
  for line in getInput().splitlines():
    if line == "":
      break
    levels.add(split(line, re2"\s+").map(parseInt))
  return levels

func safe1(levels: seq[int]): bool =
  if levels.len == 0:
    return true
  let differences = zip(levels[0 ..< levels.len - 1], levels[1 ..< levels.len]).map(proc (ab: (int, int)): int = ab[1] - ab[0])
  let increasing = all(differences, proc (x: int): bool = x > 0)
  let decreasing = all(differences, proc (x: int): bool = x < 0)
  if not increasing and not decreasing:
    return false
  if max(differences) > 3 or min(differences) < -3:
    return false
  return true

func safe2part(levels: seq[int]): bool =
  var last = levels[0]
  var increasing = false
  var decreasing = false
  var skippedOutlier = false
  let maxdifference = 3
  for i in 1 ..< levels.len:
    let difference = levels[i] - last
    # Ignore any difference that is greater than the max (but only if we haven't already found such a difference)
    if difference > maxdifference or difference < -maxdifference or difference == 0:
      if not skippedOutlier:
        skippedOutlier = true
        continue
      else:
        return false
      # last value should stay the same
    else:
      if increasing and difference < 0:
        if not skippedOutlier:
          skippedOutlier = true
          continue
        else:
          return false
      if decreasing and difference > 0:
        if not skippedOutlier:
          skippedOutlier = true
          continue
        else:
          return false
      if not increasing and not decreasing:
        increasing = difference > 0
        decreasing = difference < 0
      last = levels[i]
  return true

proc safe2(levels: seq[int]): bool =
  echo safe2part(levels)
  echo safe1(levels[1..<levels.len])
  return safe2part(levels) or safe1(levels[1..<levels.len])

proc safe3(levels: seq[int]): bool =
  if safe1(levels):
    return true
  for i in 0 ..< levels.len:
    let firstArr = levels[0 ..< i]
    let secondArr = levels[i + 1 ..< levels.len]
    let newArr = firstArr & secondArr
    let newArrSafe = safe1(newArr)
    # echo "First arr" & $firstArr & ", second arr: " & $secondArr & ", newArr: " & $newArr & ", newArr safe: " & $newArrSafe
    if newArrSafe:
      return true
  return false

proc solvePart1*(): int =
  let levels = getLevels()
  let numSafe = levels.filter(safe1).len
  return numSafe

proc solvePart2*(): int =
  let levels = getLevels()
  let numSafe = levels.filter(safe2).len

  for l in levels:
    let s = safe2(l)
    let differences = zip(l[0 ..< l.len - 1], l[1 ..< l.len]).map(proc (ab: (int, int)): int = ab[1] - ab[0])
    echo fmt"{s}: {l}, {differences}"

  return numSafe

func getInput(): string =
  return """
76 73 77 79 80 82
"""