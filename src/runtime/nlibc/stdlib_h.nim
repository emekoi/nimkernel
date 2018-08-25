#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

when defined(standalone):
  {.push exportc, cdecl, stackTrace: off, profiler: off.}

when hostOS == "standalone":
  import "$projectpath/panicoverride"

proc abort() {.noReturn.} =
  panic("an error has occured")
  while true: discard

proc exit(status: int) {.noReturn.} =
  case status:
    of QuitSuccess:
      panic("exit: success")
    of QuitFailure:
      panic("exit: failure")
    else: discard
  while true: discard

when defined(standalone):
  {.pop.}
