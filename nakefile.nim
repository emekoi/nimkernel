#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import nake
import os

const
  CC = "i686-elf-gcc"

task "clean", "removes build files.":
  removeDir("src/nimcache")
  removeDir("nimcache")
  removeDir("bin")

task "setup", "creates build directories.":
  runTask "clean"
  createDir "bin"

task "build", "build the kernel.":
  runTask "setup"
  direShell "nim c -d:release src/main.nim"
  direShell CC, " -T linker.ld -o bin/main.bin -m32 -std=gnu99 -ffreestanding -fno-stack-protector -nostdinc -nostdlib src/nimcache/*.o"

task "build-verbose", "build the kernel in verbose mode.":
  runTask "setup"
  direShell "nim c -d:release --verbosity:3 src/main.nim"
  direShell CC, " -T linker.ld -o bin/main.bin -m32 -std=gnu99 -ffreestanding -fno-stack-protector -nostdinc -nostdlib src/nimcache/*.o"

task "run", "run the kernel using QEMU.":
  if "bin/main.bin".needsRefresh("src"):
    "build".runTask()
  if existsFile("qemu.log"): removeFile("qemu.log")
  direShell "qemu-system-i386 -kernel bin/main.bin -d cpu_reset -D ./qemu.log"

task "run-stdout", "run the kernel using QEMU using stdout for logging.":
  if "bin/main.bin".needsRefresh("src"):
    "build".runTask()
  direShell "qemu-system-i386 -kernel bin/main.bin -d cpu_reset -D /dev/stdout"
