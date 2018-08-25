#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

{.push exportc, stackTrace: off, profiler: off.}

import port
import util

const
  IDT_SIZE* = 256

type Entry* = object
  lo: uint16
  selector: uint16
  zero: uint8
  type_attr: uint8
  hi: uint16

proc init*() =
  var
    keyboardAddr: uint32
    idtAddr: uint32
    idtPtr: array[2, uint32]

{.pop.}
