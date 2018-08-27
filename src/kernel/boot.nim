#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

{.push stackTrace: off, profiler: off.}

import descriptor

proc kernel_setup() =
  descriptor.init()

proc kernel_start() {.exportc, asmNoStackFrame.} =

  # Declare constants for the multiboot header.
  asm ".set ALIGN,    1 << 0"           # align loaded modules on page boundaries
  asm ".set MEMINFO,  1 << 1"           # provide memory map
  asm ".set FLAGS,    ALIGN | MEMINFO"  # this is the Multiboot 'flag' field
  asm ".set MAGIC,    0x1BADB002"       # 'magic number' lets bootloader find the header
  asm ".set CHECKSUM, -(MAGIC + FLAGS)" # checksum of above, to prove we are multiboot

  # Declare a multiboot header that marks the program as a kernel. These are magic
  # values that are documented in the multiboot standard. The bootloader will
  # search for this signature in the first 8 KiB of the kernel file, aligned at a
  # 32-bit boundary. The signature is in its own section so the header can be
  # forced to be within the first 8 KiB of the kernel file.

  asm ".section .multiboot"
  asm ".align 4"
  asm ".long MAGIC"
  asm ".long FLAGS"
  asm ".long CHECKSUM"

  # The multiboot standard does not define the value of the stack pointer register
  # (esp) and it is up to the kernel to provide a stack. This allocates room for a
  # small stack by creating a symbol at the bottom of it, then allocating 16384
  # bytes for it, and finally creating a symbol at the top. The stack grows
  # downwards on x86. The stack is in its own section so it can be marked nobits,
  # which means the kernel file is smaller because it does not contain an
  # uninitialized stack. The stack on x86 must be 16-byte aligned according to the
  # System V ABI standard and de-facto extensions. The compiler will assume the
  # stack is properly aligned and failure to align the stack will result in
  # undefined behavior.

  asm ".section .bss"
  asm ".align 16"
  asm "stack_bottom:"
  asm ".skip 0x8000" # 32 KiB
  asm "stack_top:"

  # The linker script specifies kernel_start as the entry point to the kernel and the
  # bootloader will jump to this position once the kernel has been loaded. It
  # doesn't make sense to return from this function as the bootloader is gone.

  asm ".section .text"
  asm ".global kernel_start"
  asm ".type kernel_start, @function"
  asm "kernel_start:"

  # The bootloader has loaded us into 32-bit protected mode on a x86
  # machine. Interrupts are disabled. Paging is disabled. The processor
  # state is as defined in the multiboot standard. The kernel has full
  # control of the CPU. The kernel can only make use of hardware features
  # and any code it provides as part of itself. There's no printf
  # function, unless the kernel provides its own <stdio.h> header and a
  # printf implementation. There are no security restrictions, no
  # safeguards, no debugging mechanisms, only what the kernel provides
  # itself. It has absolute and complete power over the
  # machine.

  # To set up a stack, we set the esp register to point to the top of our
  # stack (as it grows downwards on x86 systems). This is necessarily done
  # in assembly as languages such as C cannot function without a stack.

  asm "  mov $stack_top, %esp"

  # This is a good place to initialize crucial processor state before the
  # high-level kernel is entered. It's best to minimize the early
  # environment where crucial features are offline. Note that the
  # processor is not fully initialized yet: Features such as floating
  # point instructions and instruction set extensions are not initialized
  # yet. The GDT should be loaded here. Paging should be enabled here.
  # C++ features such as global constructors and exceptions will require
  # runtime support to work as well.

  kernel_setup()

  # Enter the high-level kernel. The ABI requires the stack is 16-byte
  # aligned at the time of the call instruction (which afterwards pushes
  # the return pointer of size 4 bytes). The stack was originally 16-byte
  # aligned above and we've since pushed a multiple of 16 bytes to the
  # stack since (pushed 0 bytes so far) and the alignment is thus
  # preserved and the call is well defined.

  asm "  call main"

  # If the system has nothing more to do, put the computer into an
  # infinite loop. To do that:
  # 1) Disable interrupts with cli (clear interrupt enable in eflags).
  #    They are already disabled by the bootloader, so this is not needed.
  #    Mind that you might later enable interrupts and return from
  #    kernel_main (which is sort of nonsensical to do).
  # 2) Wait for the next interrupt to arrive with hlt (halt instruction).
  #    Since they are disabled, this will lock up the computer.
  # 3) Jump to the hlt instruction if it ever wakes up due to a
  #    non-maskable interrupt occurring or due to system management mode.

  asm "  cli"
  asm "1:	hlt"
  asm "  jmp 1b"

  # Set the size of the kernel_start symbol to the current location '.' minus its start.
  # This is useful when debugging or when you implement call tracing.

  asm ".size kernel_start, . - kernel_start"

{.pop.}
