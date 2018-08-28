#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

{.push stackTrace: off, profiler: off.}

import port, util

type
  VGAPort {.pure.} = enum
    COMMAND = 0x3D4
    DATA = 0x3D5

  VGACommand {.pure.} = enum
    HI = 0xE
    LO = 0xF

  Color* {.pure, size: sizeof(uint8).} = enum
    BLACK = 0,
    BLUE = 1,
    GREEN = 2,
    CYAN = 3,
    RED = 4,
    MAGENTA = 5,
    BROWN = 6,
    LIGHT_GREY = 7,
    DARK_GREY = 8,
    LIGHT_BLUE = 9,
    LIGHT_GREEN = 10,
    LIGHT_CYAN = 11,
    LIGHT_RED = 12,
    LIGHT_MAGENTA = 13,
    YELLOW = 14,
    WHITE = 15

const
  WIDTH* = 80
  HEIGHT* = 25
  ESCAPES = { '\b', '\n', '\r', '\t' }

var
  terminalBuffer {.volatile.}: ptr array[WIDTH * HEIGHT, uint16]
  terminalRow: range[0 .. (HEIGHT - 1)]
  terminalColumn: range[0 .. (WIDTH - 1)]
  terminalForeGround: Color
  terminalBackGround: Color
  terminalColor: uint8

proc entryColor(fg, bg: Color): uint8 =
  return fg.uint8 or (bg.uint8 shl 4)

proc entry(uc: char, color: uint8): uint16 =
  return uc.uint16 or (color.uint16 shl 8)

proc moveCursor(x, y: int) =
  let pos = uint16(y * WIDTH + x)
  VGAPort.COMMAND.write Command(VGACommand.HI)
  VGAPort.DATA.write Command((pos shr 8) and 0x00FF)
  
  VGAPort.COMMAND.write Command(VGACommand.LO)
  VGAPort.DATA.write Command(pos and 0x00FF)

proc updateCursor() =
  moveCursor(terminalColumn, terminalRow)

proc clear*() =
  for i in 0 .. (HEIGHT * WIDTH - 1):
    terminalBuffer[i] = entry(' ', terminalColor)

proc init() =
  terminalRow = 0
  terminalColumn = 0
  terminalForeGround = Color.LIGHT_GREY
  terminalBackGround = Color.DARK_GREY
  terminalColor = entryColor(terminalForeGround, terminalBackGround)
  terminalBuffer = cast[ptr array[WIDTH * HEIGHT, uint16]](0xB8000)
  clear()

proc setForeGround*(color: Color) =
  terminalForeGround = color
  terminalColor = entryColor(terminalForeGround, terminalBackGround)

proc setBackGround*(color: Color) =
  terminalBackGround = color
  terminalColor = entryColor(terminalForeGround, terminalBackGround)

proc setColor*(fg, bg: Color) =
  terminalForeGround = fg
  terminalBackGround = bg
  terminalColor = entryColor(terminalForeGround, terminalBackGround)

proc setRow*(row: range[0 .. (HEIGHT - 1)]) =
  terminalRow = row
  updateCursor()

proc setColumn*(col: range[0 .. (WIDTH - 1)]) =
  terminalColumn = col
  updateCursor()

proc getForeGround*(): Color =
  terminalForeGround

proc getBackGround*(): Color =
  terminalBackGround

proc getColor*(): (Color, Color) =
  (
    terminalForeGround,
    terminalBackGround
  )

proc getRow*(): range[0 .. (HEIGHT - 1)] =
  terminalRow

proc getColumn*(): range[0 .. (WIDTH - 1)] =
  terminalColumn

proc putEntryAt(c: char, x, y: int) =
  terminalBuffer[y * WIDTH + x] = entry(c, terminalColor)

proc handleEscape(c: char) =
  case c:
    of '\b':
      terminalColumn.dec
    of '\n':
      terminalRow.inc
      terminalColumn = 0
    of '\r':
      terminalColumn = 0
      for x in 0 .. (WIDTH - 1):
        terminalBuffer[terminalRow * WIDTH + x] = entry(' ', terminalColor)
    of '\t':
      terminalColumn.inc 4
    else:
      discard

proc putChar*(c: char) =
  if c in ESCAPES:
    handleEscape(c)
  else:
    putEntryAt(c, terminalColumn, terminalRow)
    terminalColumn.inc

  if terminalColumn >= WIDTH:
    terminalColumn = 0
    terminalRow.inc

  if terminalRow >= HEIGHT:
    let
      blank = entry(' ', terminalColor)
      line = (HEIGHT - 1) * WIDTH

    for i in 0 .. (line - 1):
      terminalBuffer[i] = terminalBuffer[i + 80]

    for i in line .. (HEIGHT * WIDTH - 1):
      terminalBuffer[i] = blank

    terminalRow = HEIGHT - 1

  updateCursor()

proc write*(data: string) =
  for c in cstring(data):
    putChar(c)

proc writeLine*(data: string) =
  write(data)
  terminalRow.inc
  terminalColumn = 0

proc putDec*[T: SomeInteger](num: T) =
  var
    num = num
    temp = num
    factor = T(1)
  
  while temp != T(0):
    temp = temp div T(10)
    factor = factor * T(10)
  
  while factor > T(1):
    factor = factor div T(10)
    putChar(chr((num div factor) + T(48)))
    num = num mod factor
  
  putChar('\n')

proc putHex*[T: SomeUnsignedInt](num: T) =
  var
    num = num
    temp = num
    factor = T(0x01)
  
  write("0x")

  if num == T(0x01):
    putChar(HEXTABLE[0])
  else:
    while temp != T(0x00):
      temp = temp div T(0x10)
      factor = factor * T(0x10)
    
    while factor > T(0x01):
      factor = factor div T(0x10)
      putChar(HEXTABLE[num div factor])
      num = num mod factor
  
  putChar('\n')

init()

{.pop.}
