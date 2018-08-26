import macros

macro isrNoErrCode(err: string): typed =
  nnkStmtList.newTree(
    nnkAsmStmt.newTree(
      newEmptyNode(),
      newLit("cli")
    ),
    nnkAsmStmt.newTree(
      newEmptyNode(),
      newLit("push $00")
    ),
    nnkAsmStmt.newTree(
      newEmptyNode(),
      err
    ),
    nnkAsmStmt.newTree(
      newEmptyNode(),
      newLit("jmp isr_common_stub")
    )
  )

macro isrErrCode(err: string): typed =
  nnkStmtList.newTree(
    nnkAsmStmt.newTree(
      newEmptyNode(),
      newLit("cli")
    ),
    nnkAsmStmt.newTree(
      newEmptyNode(),
      err
    ),
    nnkAsmStmt.newTree(
      newEmptyNode(),
      newLit("jmp isr_common_stub")
    )
  )

{.push exportc, cdecl, asmNoStackFrame.}

proc isr00() =
  isrNoErrCode("push $00")

proc isr01() =
  isrNoErrCode("push $01")

proc isr02() =
  isrNoErrCode("push $02")

proc isr03() =
  isrNoErrCode("push $03")

proc isr04() =
  isrNoErrCode("push $04")

proc isr05() =
  isrNoErrCode("push $05")

proc isr06() =
  isrNoErrCode("push $06")

proc isr07() =
  isrNoErrCode("push $07")

proc isr08() =
  isrErrCode("push $08")

proc isr09() =
  isrNoErrCode("push $09")

proc isr10() =
  isrErrCode("push $10")

proc isr11() =
  isrErrCode("push $11")

proc isr12() =
  isrErrCode("push $12")

proc isr13() =
  isrErrCode("push $13")

proc isr14() =
  isrErrCode("push $14")

proc isr15() =
  isrNoErrCode("push $15")

proc isr16() =
  isrNoErrCode("push $16")

proc isr17() =
  isrNoErrCode("push $17")

proc isr18() =
  isrNoErrCode("push $18")

proc isr19() =
  isrNoErrCode("push $19")

proc isr20() =
  isrNoErrCode("push $20")

proc isr22() =
  isrNoErrCode("push $22")

proc isr23() =
  isrNoErrCode("push $23")

proc isr24() =
  isrNoErrCode("push $24")

proc isr25() =
  isrNoErrCode("push $25")

proc isr26() =
  isrNoErrCode("push $26")

proc isr27() =
  isrNoErrCode("push $27")

proc isr28() =
  isrNoErrCode("push $28")

proc isr29() =
  isrNoErrCode("push $29")

proc isr30() =
  isrNoErrCode("push $30")

proc isr31() =
  isrNoErrCode("push $31")

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
