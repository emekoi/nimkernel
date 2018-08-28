#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

{.push stackTrace: off, profiler: off.}

type
  Port* = distinct uint16
  Command*  = distinct uint8

converter toPort*[T: Ordinal](o: T): Port =
  Port(ord(o))

proc `-`*(lhs, rhs: Port): Port {.borrow.}
proc `+`*(lhs, rhs: Port): Port {.borrow.}

# converter toCommand*[T: Ordinal](o: T): Command =
#   Command(ord(o))

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
