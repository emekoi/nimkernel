template isrNoErrCode(err: Interrupt) =
  asm """
    cli
    push 0
    push %0
    jmp isr_common_stub
    : :"i"(err)
  """

template isrErrCode(err: Interrupt) =
  asm """
    cli
    push %0
    jmp isr_common_stub
    : :"i"(err)
  """

{.push exportc, cdecl, asmNoStackFrame.}

proc isr00() =
  isrNoErrCode(Interrupt.DivByZero)

proc isr01() =
  isrNoErrCode(Interrupt.Debug)

proc isr02() =
  isrNoErrCode(Interrupt.NonMask)

proc isr03() =
  isrNoErrCode(Interrupt.Breakpoint)

proc isr04() =
  isrNoErrCode(Interrupt.IntoDetectedOverflow)

proc isr05() =
  isrNoErrCode(Interrupt.OutOfBounds)

proc isr06() =
  isrNoErrCode(Interrupt.InvalidOpcode)

proc isr07() =
  isrNoErrCode(Interrupt.NoCoprocessor)

proc isr08() =
  isrErrCode(Interrupt.DoubleFaut)

proc isr09() =
  isrNoErrCode(Interrupt.CoprocessorOverrun)

proc isr10() =
  isrErrCode(Interrupt.BasdTSS)

proc isr11() =
  isrErrCode(Interrupt.NoSegement)

proc isr12() =
  isrErrCode(Interrupt.StackFault)

proc isr13() =
  isrErrCode(Interrupt.GPFault)

proc isr14() =
  isrErrCode(Interrupt.PageFault)

proc isr15() =
  isrNoErrCode(Interrupt.UnknownInterrupt)

proc isr16() =
  isrNoErrCode(Interrupt.CoprocessorFault)

proc isr17() =
  isrNoErrCode(Interrupt.AlignmentCheck)

proc isr18() =
  isrNoErrCode(Interrupt.MachineCheck)

proc isr19() =
  isrNoErrCode(Interrupt.Reserved_19)

proc isr20() =
  isrNoErrCode(Interrupt.Reserved_20)

proc isr22() =
  isrNoErrCode(Interrupt.Reserved_22)

proc isr23() =
  isrNoErrCode(Interrupt.Reserved_23)

proc isr24() =
  isrNoErrCode(Interrupt.Reserved_24)

proc isr25() =
  isrNoErrCode(Interrupt.Reserved_25)

proc isr26() =
  isrNoErrCode(Interrupt.Reserved_26)

proc isr27() =
  isrNoErrCode(Interrupt.Reserved_27)

proc isr28() =
  isrNoErrCode(Interrupt.Reserved_28)

proc isr29() =
  isrNoErrCode(Interrupt.Reserved_29)

proc isr30() =
  isrNoErrCode(Interrupt.Reserved_30)

proc isr31() =
  isrNoErrCode(Interrupt.Reserved_31)

proc isr_common_stub() =
  asm """
    pusha
    mov %ds, %ax
    push %eax
    mov $0x10, %ax,
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    call isrHandler
    pop %eax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    popa
    add $8, %esp
    sti
    iret
  """

{.pop.}
