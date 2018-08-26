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

task "build-verbose", "build the kernel in verbose mode.":
  runTask "setup"
  direShell "nim c -d:release -o:bin/main.bin --verbosity:3 src/main.nim"

task "run", "run the kernel using QEMU.":
  if "bin/main.bin".needsRefresh("src"):
    "build".runTask()
  if existsFile("qemu.log"): removeFile("qemu.log")
  direShell "qemu-system-i386 -kernel bin/main.bin -d cpu_reset -D ./qemu.log"

task "run-stdout", "run the kernel using QEMU using stdout for logging.":
  if "bin/main.bin".needsRefresh("src"):
    "build".runTask()
  direShell "qemu-system-i386 -kernel bin/main.bin -d cpu_reset -D /dev/stdout"
