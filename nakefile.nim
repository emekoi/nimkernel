#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import nake
import os

task "clean", "removes build files.":
  removeDir("src/nimcache")
  removeDir("nimcache")
  removeDir("bin")

task "setup", "creates build directories.":
  runTask "clean"
  createDir "bin"

task "build", "build the kernel.":
  runTask "setup"
  direShell "nim c -d:release -o:bin/main.bin src/main.nim"

task "build-debug", "build the kernel in debug mode.":
  runTask "setup"
  direShell "nim c -o:bin/main-debug.bin src/main.nim"

task "run", "run the kernel using QEMU.":
  if "bin/main.bin".needsRefresh("src"):
    "build".runTask()
  if existsFile("qemu.log"): removeFile("qemu.log")
  direShell "qemu-system-i386 -kernel bin/main.bin -d cpu_reset -D ./qemu.log"

task "run-debug", "run the kernel using QEMU in debug mode.":
  if "bin/main-debug.bin".needsRefresh("src"):
    "build-debug".runTask()
  if existsFile("qemu.log"): removeFile("qemu.log")
  direShell "qemu-system-i386 -kernel bin/main-debug.bin -d cpu_reset -D ./qemu.log"

task "run-gdb", "run the kernel using QEMU in debug mode.":
  if "bin/main-debug.bin".needsRefresh("src"):
    "build-debug".runTask()
  if existsFile("qemu.log"): removeFile("qemu.log")
  direShell "qemu-system-i386 -s -S -kernel bin/main-debug.bin -d cpu_reset -D ./qemu.log"
