#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import kernel/driver/vga

{.push debugger: off.}

proc echoBinSafe(args: openArray[string]) {.compilerProc.} =
  for data in args:
    vga.write(data)
  vga.write("\n")

{.pop.}
