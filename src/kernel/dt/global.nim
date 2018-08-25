#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

{.push stackTrace: off, profiler: off.}

import util

type
  Entry {.packed.} = object
    limit_low: uint16
    base_low: uint16
    base_middle: uint8
    access: uint8
    granularity: uint8
    base_high: uint8

var
  gdtEntries: array[5, Entry]
  gdtPointer: Pointer

proc flush(gdt: uint32) {.asmNoStackFrame.} =
  asm """lgdt %0
    :"=r"(`gdt`)
  """
  asm "mov 0x10, %ax"       # 0x10 is the offset in the GDT to our data segment
  asm "mov %ds, %ax"        # Load all data segment selectors
  asm "mov %es, %ax"
  asm "mov %fs, %ax"
  asm "mov %gs, %ax"
  asm "mov %ss, %ax"
  asm "jmp $0x08, $flush_cs" # 0x08 is the offset to our code segment: Far jump!
  asm "flush_cs:"
  asm "  ret"

proc setGate(num: int32, base, limit: uint32, access, gran: uint8) =
  gdtEntries[num].base_low    = uint16(base and 0xFFFF)
  gdtEntries[num].base_middle = uint8((base shr 16) and 0xFF)
  gdtEntries[num].base_high   = uint8((base shr 24) and 0xFF)

  gdtEntries[num].limit_low   = uint16(limit and 0xFFFF)
  gdtEntries[num].granularity = uint8((limit shr 16) and 0x0F)

  gdtEntries[num].granularity = gdtEntries[num].granularity or (gran and 0xF0)
  gdtEntries[num].access      = access


proc init*() =
  gdtPointer.limit = uint16((sizeof(Entry) * 5) - 1)
  gdtPointer.base = cast[uint32](gdtEntries.addr)

  setGate(0, 0x0, 0x00000000'u32, 0x00, 0x00)
  setGate(1, 0x0, 0xFFFFFFFF'u32, 0x9A, 0xCF)
  setGate(2, 0x0, 0xFFFFFFFF'u32, 0x92, 0xCF)
  setGate(3, 0x0, 0xFFFFFFFF'u32, 0xFA, 0xCF)
  setGate(4, 0x0, 0xFFFFFFFF'u32, 0xF2, 0xCF)

  flush(cast[uint32](gdtPointer.addr))



# proc read*(port: Port): uint8 =
#   asm """inb %1, %0
#     :"=a"(`result`)
#     :"Nd"(`port`)
#   """

{.pop.}
