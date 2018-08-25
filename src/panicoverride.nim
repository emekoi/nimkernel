#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

{.push stack_trace: off, profiler:off.}
import kernel/driver/vga

proc rawoutput(s: string) =
  vga.writeLine s

proc panic(s: string) =
  let
    row = vga.getRow()
    col = vga.getColumn()
    (fg, bg) = vga.getColor()

  vga.setRow(vga.HEIGHT - 1)
  vga.setColumn(0)
  vga.setColor(Color.RED, Color.WHITE)
  # vga.clear()

  rawoutput s

  vga.setRow(row)
  vga.setColumn(col)
  vga.setColor(fg, bg)

{.pop.}
