## Activating Virtualization for Legion Y720T

My computer has very weird BIOS settings for virtualization. The CPU, a Ryzen 1700x, supports virtualization and the motherboard does as well.

Despite this, the actual setting for virtualization is not found *at all* in the BIOS, and the reason for this is because the motherboard comes with a pre-built system, which very likely doesn't have users that frequently use virtual machines.

To enable virtualization, you have to forcefully enable it with a program. I found this thread that dealt with the issue:

https://forums.lenovo.com/t5/Gaming-Desktops/Legion-Y720T-AMD-Hardware-virtualization/m-p/3993516

That lead to another thread:

https://www.bios-mods.com/forum/Thread-Request-Bios-unlock-for-Lenovo-Legion-Y720T-34ASU

then another:

https://www.bios-mods.com/forum/Thread-READ-FIRST-Access-Advanced-settings-through-EFI-shell

Which finally led me to the solution. This is what you have to do:

1. Go to http://www.mediafire.com/file/81vegw2aw0pxcib/EFI_Shell.rar/file and download the archive.
2. Format a USB to FAT32 and copy that archive on it.
3. Boot up your computer to run that usb.
4. In the shell, run "setup_var 0x145 0x01" to turn on the virtualization option manually; This changes a 0 to a 1.

And you're done!


