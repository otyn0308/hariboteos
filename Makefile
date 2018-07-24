Z_TOOLS = ./z_tools/
NASK = $(Z_TOOLS)nask
EDIMG = $(Z_TOOLS)edimg

# デフォルト動作

default :
	make img

ipl.bin : ipl.nas Makefile
	$(NASK) ipl.nas ipl.bin ipl.lst

helloos.img : ipl.bin Makefile
	$(EDIMG) imgin:$(Z_TOOLS)fdimg0at.tek \
		wbinimg src:ipl.bin len:512 from:0 to:0 imgout:helloos.img

# コマンド

asm :
	make -r ipl.bin

img :
	make -r helloos.img

run :
	make img
	qemu-system-i386 -fda helloos.img

clean :
	rm ipl.bin
	rm ipl.lst

src_only :
	make clean
	rm helloos.img
