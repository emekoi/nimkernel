#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

{.push stackTrace: off, profiler: off.}

import port, util, vga

type
  COMPort* {.pure.} = enum
    COM4 = 0x2E8
    COM2 = 0x2F8
    COM3 = 0x3E8
    COM1 = 0x3F8  
  
  COMCommand {.pure.} = enum
    LINE_ENABLE_DLAB

template serialData(base: COMPort): Port =
  Port(base)

template serialFifo(base: COMPort): Port =
  Port(base) + Port(2)

template serialLine(base: COMPort): Port =
  Port(base) + Port(3)

template serialModem(base: COMPort): Port =
  Port(base) + Port(4)

template serialStatus(base: COMPort): Port =
  Port(base) + Port(5)

proc configureBaud(com: COMPort, divisor: uint16) =
  serialLine(com).write Command(COMCommand.LINE_ENABLE_DLAB)
  serialData(com).write Command((divisor shr 8) and 0x00FF)
  serialData(com).write Command(divisor and 0x00FF)

proc configureLine(com: COMPort) =
  serialLine(com).write Command(0x03)

proc configureFifo(com: COMPort) =
  serialFifo(com).write Command(0xC7)

proc configureModem(com: COMPort) =
  serialModem(com).write Command(0x03)

proc init*(com: COMPort) =
  com.configureBaud(1)
  com.configureLine()
  com.configureFifo()
  com.configureModem()

proc isEmpty(com: COMPort): bool =
  (serialStatus(com).read() and 0x20) != 0

proc putChar*(com: COMPort, c: char) =
  while not com.isEmpty(): cpuRelax()
  serialData(com).write Command(c)
  
proc write*(com: COMPort, data: string) =
  for c in cstring(data):
    com.putChar(c)

proc writeLine*(com: COMPort, data: string) =
  com.write(data)
  com.putChar('\n')

proc putDec*[T: SomeInteger](com: COMPort, num: T) =
  var
    num = num
    temp = num
    factor = T(1)
  
  while temp != T(0):
    temp = temp div T(10)
    factor = factor * T(10)
  
  while factor > T(1):
    factor = factor div T(10)
    com.putChar(chr((num div factor) + T(48)))
    num = num mod factor
  
  com.putChar('\n')

proc putHex*[T: SomeUnsignedInt](com: COMPort, num: T) =
  var
    num = num
    temp = num
    factor = T(0x01)
  
  com.write("0x")

  if num == T(0x01):
    com.putChar(HEXTABLE[0])
  else:
    while temp != T(0x00):
      temp = temp div T(0x10)
      factor = factor * T(0x10)
    
    while factor > T(0x01):
      factor = factor div T(0x10)
      com.putChar(HEXTABLE[num div factor])
      num = num mod factor
  
  com.putChar('\n')

{.pop.}
