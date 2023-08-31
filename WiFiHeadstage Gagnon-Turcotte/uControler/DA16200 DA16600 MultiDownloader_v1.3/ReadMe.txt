Files in package

DA16200 DA16600 MultiDownloader.exe: executable file
settings.txt: setting values for OS type, predefined module type, flash size and image file path/address/size
cmd: command history in console window
flash_id.info: flash id information of each flash model

Known Limitation
The Windows message box does not support long file path (over 260 byte). So image file with long file path cannot be used in this tool.

Release note:

V1.0
First release

V1.1 
Fixed incorrect drag and drop when directory name has specific string.

V1.2
1. Support FreeRTOS SDK.
2. Added functions for checking flash ID in RAM, flash and bootloader.
3. Support erase.
4. Separated drag and drop area.
5. Removed auto bootloader download for adesto and winbond flash at DA16600.

V1.3
1. Fixed incorrect download when flash ID of flash and bootloader is different.
		