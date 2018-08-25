#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

{.push stackTrace: off, profiler: off.}

type
  Port* {.pure, size: sizeof(uint16).} = enum
    VGA_COMMAND = 0x3D4
    VGA_DATA = 0x3D5

  Command*  = distinct uint8

proc read*(port: Port): uint8 =
  asm """inb %1, %0
    :"=a"(`result`)
    :"Nd"(`port`)
  """

proc write*(port: Port, value: Command) =
  asm """outb %0, %1
    : :"a"(`value`), "Nd"(`port`)
  """

{.pop.}
