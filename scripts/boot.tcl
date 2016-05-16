set project_name [lindex $argv 0]

set fileId [open proj/boot.bif "w"]
puts $fileId "img:{\[bootloader\] proj/$project_name.fsbl/executable.elf proj/$project_name.bit $::env(MY_RP)/misc/u-boot.elf}"
close $fileId
exec bootgen -image proj/boot.bif -w -o i proj/boot.bin >&@stdout
