#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

{.push stackTrace: off, profiler: off.}

type
  GDTEntry {.packed.} = object
    limitLow: uint16
    baseLow: uint16
    baseMiddle: uint8
    access: uint8
    granularity: uint8
    baseHigh: uint8
  
  GDTPtr {.packed.} = object
    limit: uint16
    base: uint32

var
  gdtEntries: array[5, GDTEntry]
  gdtPointer: GDTPtr

proc flush(gdt: ptr GDTPtr) {.asmNoStackFrame.} =
  asm """lgdt %0
    : :"m"(`gdt`)
  """

  asm "mov $0x10, %ax"       # 0x10 is the offset in the GDT to our data segment
  asm "mov %ds, %ax"         # Load all data segment selectors
  asm "mov %es, %ax"
  asm "mov %fs, %ax"
  asm "mov %gs, %ax"
  asm "mov %ss, %ax"

  # asm "jmp $0x08, $flush_cs" # 0x08 is the offset to our code segment: Far jump!
  # asm "ljmp $0x8, $flush_cs"

  # asm "push $0x08"
  # asm "mov $flush_cs, %eax"
  # asm "push %eax"
  asm "ljmp $0x8, $flush_cs"
  asm "flush_cs:"
  asm "  lret"


proc setGate(idx: int32, base, limit: uint32, access, gran: uint8) =
  gdtEntries[idx].baseLow = uint16(base and 0xFFFF)
  gdtEntries[idx].baseMiddle = uint8((base shr 16) and 0xFF)
  gdtEntries[idx].baseHigh = uint8((base shr 24) and 0xFF)

  gdtEntries[idx].limitLow = uint16(limit and 0xFFFF)
  gdtEntries[idx].granularity = uint8((limit shr 16) and 0x0F)

  gdtEntries[idx].granularity = gdtEntries[idx].granularity or (gran and 0xF0)
  gdtEntries[idx].access = access

proc init*() =
  gdtPointer.limit = uint16(GDTEntry.sizeof() * (gdtEntries.len - 1))
  gdtPointer.base = cast[uint32](addr gdtEntries[0])

  setGate(0, 0x0, 0x00000000'u32, 0x00, 0x00)
  setGate(1, 0x0, 0xFFFFFFFF'u32, 0x9A, 0xCF)
  setGate(2, 0x0, 0xFFFFFFFF'u32, 0x92, 0xCF)
  setGate(3, 0x0, 0xFFFFFFFF'u32, 0xFA, 0xCF)
  setGate(4, 0x0, 0xFFFFFFFF'u32, 0xF2, 0xCF)

  flush(addr gdtPointer)

{.pop.}
