#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import kernel/boot
import kernel/driver/[vga, serial]
import kernel/descriptor/idt

proc main() =
  COMPort.COM1.init()
  echo "this is a test"
  echo "of a kernel in nim"
  idt.dumpIDT()
  # var reg: Registers
  # reg.isrHandler()
  idt.isrCommonStub()
  # asm "debug_point:"
  # asm "int $0x3"

main()
