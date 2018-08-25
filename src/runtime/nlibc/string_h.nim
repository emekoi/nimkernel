#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

when defined(standalone):
  {.push exportc, cdecl, stackTrace: off, profiler: off.}

proc strlen*(str: cstring): csize =
  var i = 0
  while str[i] != '\0':
    inc result
    inc i

proc memcmp*(s1, s2: pointer, n: csize): cint =
  result = 0
  let
    s1 = cast[ptr UncheckedArray[cuchar]](s1)
    s2 = cast[ptr UncheckedArray[cuchar]](s2)
  for idx in countup(0, n - 1):
    if s1[idx] != s2[idx]:
      return cint(s1[idx]) - cint(s2[idx])

proc memcpy*(dest, src: pointer, n: csize): pointer =
  result = dest
  let
    dest = cast[ptr UncheckedArray[cuchar]](dest)
    src = cast[ptr UncheckedArray[cuchar]](src)
  for idx in countup(0, n - 1):
    dest[idx] = src[idx]

proc memset*(s: pointer, c: cint, n: csize): pointer  =
  result = s
  let str = cast[ptr UncheckedArray[cuchar]](s)
  for idx in countup(0, n - 1):
    str[idx] = cast[cuchar](c)

proc memmove*(dest, src: pointer, n: csize): pointer =
  result = dest
  let
    direction = src < dest
    dest = cast[ptr UncheckedArray[cuchar]](dest)
    src = cast[ptr UncheckedArray[cuchar]](src)

  if direction: # copy from end
    for idx in countdown(n - 1, 0):
      dest[idx] = src[idx]
  else: # copy from beginning
    for idx in countup(0, n - 1):
      dest[idx] = src[idx]

when defined(standalone):
  {.pop.}
