switch("path", ".")

switch("cc", "gcc")
switch("cpu", "i386")

# switch("noMain")
switch("noLinking")

switch("gc", "none")
switch("os", "standalone")
switch("boundChecks", "on")

switch("deadCodeElim", "on")
# switch("experimental", "notnil")

switch("gcc.exe", "i686-elf-gcc")
switch("lib", "src/runtime")
switch("cincludes", "runtime/include")

switch("passL", "linker.ld")
switch("passC", "-m32 -std=gnu99 -ffreestanding -fno-stack-protector -nostdlib -O2 -Wall -Wextra")
