switch("path", ".")

switch("cc", "gcc")
switch("cpu", "i386")

switch("gc", "none")
switch("os", "standalone")
switch("boundChecks", "on")

switch("deadCodeElim", "on")

switch("gcc.exe", "i686-elf-gcc")
switch("gcc.linkerexe", "i686-elf-gcc")
switch("lib", "src/runtime")
switch("cincludes", "runtime/nlibc/include")

switch("passL", "-T linker.ld -m32 -ffreestanding -fno-stack-protector -nostdlib")
switch("passC", "-m32 -ffreestanding -fno-stack-protector -nostdlib -Wall -Wextra")
