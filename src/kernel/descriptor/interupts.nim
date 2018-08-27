template isr_NoErrCode(blk: untyped): untyped =
  asm "cli"
  asm "push 0"
  blk
  asm "jmp isrCommonStub"

template isrErrCode(blk: untyped): untyped =
  asm "cli"
  blk
  asm "jmp isrCommonStub"

{.push exportc, cdecl, asmNoStackFrame.}

proc isr00() =
  isrNoErrCode:
    asm "push $0"

proc isr01() =
  isrNoErrCode:
    asm "push $1"

proc isr02() =
  isrNoErrCode:
    asm "push $2"

proc isr03() =
  isrNoErrCode:
    asm "push $3"

proc isr04() =
  isrNoErrCode:
    asm "push $4"

proc isr05() =
  isrNoErrCode:
    asm "push $5"

proc isr06() =
  isrNoErrCode:
    asm "push $6"

proc isr07() =
  isrNoErrCode:
    asm "push $7"

proc isr08() =
  isrErrCode:
    asm "push $8"

proc isr09() =
  isrNoErrCode:
    asm "push $9"

proc isr10() =
  isrErrCode:
    asm "push $10"

proc isr11() =
  isrErrCode:
    asm "push $11"

proc isr12() =
  isrErrCode:
    asm "push $12"

proc isr13() =
  isrErrCode:
    asm "push $13"

proc isr14() =
  isrErrCode:
    asm "push $14"

proc isr15() =
  isrNoErrCode:
    asm "push $15"

proc isr16() =
  isrNoErrCode:
    asm "push $16"

proc isr17() =
  isrNoErrCode:
    asm "push $17"

proc isr18() =
  isrNoErrCode:
    asm "push $18"

proc isr19() =
  isrNoErrCode:
    asm "push $19"

proc isr20() =
  isrNoErrCode:
    asm "push $20"

proc isr22() =
  isrNoErrCode:
    asm "push $22"

proc isr23() =
  isrNoErrCode:
    asm "push $23"

proc isr24() =
  isrNoErrCode:
    asm "push $24"

proc isr25() =
  isrNoErrCode:
    asm "push $25"

proc isr26() =
  isrNoErrCode:
    asm "push $26"

proc isr27() =
  isrNoErrCode:
    asm "push $27"

proc isr28() =
  isrNoErrCode:
    asm "push $28"

proc isr29() =
  isrNoErrCode:
    asm "push $29"

proc isr30() =
  isrNoErrCode:
    asm "push $30"

proc isr31() =
  isrNoErrCode:
    asm "push $31"

proc isrCommonStub() =
  # asm """
  #   pusha
  #   mov %ds, %ax
  #   push %eax
  #   mov $0x10, %ax
  #   mov %ax, %ds
  #   mov %ax, %es
  #   mov %ax, %fs
  #   mov %ax, %gs
  #   call isrHandler
  #   pop %eax
  #   mov %ax, %ds
  #   mov %ax, %es
  #   mov %ax, %fs
  #   mov %ax, %gs
  #   popa
  #   add $8, %esp
  #   sti
  #   iret
  # """
  asm "iret"

{.pop.}
