#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

{.push stackTrace: off, profiler: off.}

import ../driver/vga

type
  Interrupt {.pure, size: uint32.sizeof.} = enum
    DivByZero,
    Debug,
    NonMask,
    Breakpoint,
    IntoDetectedOverflow,
    OutOfBounds,
    InvalidOpcode,
    NoCoprocessor,
    DoubleFaut,
    CoprocessorOverrun,
    BasdTSS,
    NoSegement,
    StackFault,
    GPFault,
    PageFault,
    UnknownInterrupt,
    CoprocessorFault,
    AlignmentCheck,
    MachineCheck,
    Reserved_19,
    Reserved_20,
    Reserved_22,
    Reserved_23,
    Reserved_24,
    Reserved_25,
    Reserved_26,
    Reserved_27,
    Reserved_28,
    Reserved_29,
    Reserved_30,
    Reserved_31,

  IDTEntry {.packed.} = object
    baseLo: uint16
    sel: uint16
    zero: uint8
    flags: uint8
    baseHi: uint16

  IDTPtr {.packed.} = object
    limit: uint16
    base: uint32
  
  Registers = object
    ds: uint32
    edi, esi, ebp, esp, ebx, edx, ecx, eax: uint32
    intNo: Interrupt
    errCode: uint32
    eip, cs, eflags, useresp, ss: uint32

var
  idtEntries: array[256, IDTEntry]
  idtPointer: IDTPtr  

include interupts

proc flush(idt: ptr IDTPtr) {.asmNoStackFrame.} =
  asm """lidt 4%0
    : :"m"(`idt`)
  """
  asm "ret"

proc setGate(idx: uint8, base: uint32, sel: uint16, flags: uint8) =
  idtEntries[idx].baseLo = uint16(base and 0xFFFF)
  idtEntries[idx].baseHi = uint16((base shr 16) and 0xFFFF)

  idtEntries[idx].sel = sel
  idtEntries[idx].zero = 0

  idtEntries[idx].flags = flags # or 0x60

proc init*() =
  idtPointer.limit = uint16(IDTEntry.sizeof() * idtEntries.len - 1)
  idtPointer.base = cast[uint32](addr idtEntries[0])

  setGate(00, cast[uint32](isr00), 0x08, 0x8E)
  setGate(01, cast[uint32](isr01), 0x08, 0x8E)
  setGate(02, cast[uint32](isr02), 0x08, 0x8E)
  setGate(03, cast[uint32](isr03), 0x08, 0x8E)
  setGate(04, cast[uint32](isr04), 0x08, 0x8E)
  setGate(05, cast[uint32](isr05), 0x08, 0x8E)
  setGate(06, cast[uint32](isr06), 0x08, 0x8E)
  setGate(07, cast[uint32](isr07), 0x08, 0x8E)
  setGate(08, cast[uint32](isr08), 0x08, 0x8E)
  setGate(09, cast[uint32](isr09), 0x08, 0x8E)
  setGate(10, cast[uint32](isr10), 0x08, 0x8E)
  setGate(11, cast[uint32](isr11), 0x08, 0x8E)
  setGate(12, cast[uint32](isr12), 0x08, 0x8E)
  setGate(13, cast[uint32](isr13), 0x08, 0x8E)
  setGate(14, cast[uint32](isr14), 0x08, 0x8E)
  setGate(15, cast[uint32](isr15), 0x08, 0x8E)
  setGate(16, cast[uint32](isr16), 0x08, 0x8E)
  setGate(17, cast[uint32](isr17), 0x08, 0x8E)
  setGate(18, cast[uint32](isr18), 0x08, 0x8E)
  setGate(19, cast[uint32](isr19), 0x08, 0x8E)
  setGate(20, cast[uint32](isr20), 0x08, 0x8E)
  setGate(22, cast[uint32](isr22), 0x08, 0x8E)
  setGate(23, cast[uint32](isr23), 0x08, 0x8E)
  setGate(24, cast[uint32](isr24), 0x08, 0x8E)
  setGate(25, cast[uint32](isr25), 0x08, 0x8E)
  setGate(26, cast[uint32](isr26), 0x08, 0x8E)
  setGate(27, cast[uint32](isr27), 0x08, 0x8E)
  setGate(28, cast[uint32](isr28), 0x08, 0x8E)
  setGate(29, cast[uint32](isr29), 0x08, 0x8E)
  setGate(30, cast[uint32](isr30), 0x08, 0x8E)
  setGate(31, cast[uint32](isr31), 0x08, 0x8E)

  flush(addr idtPointer)

proc isrHandler(regs: Registers) {.exportc.} =
  vga.write("recieved interrupt: ")
  vga.putDec(ord(regs.intNo))

{.pop.}
