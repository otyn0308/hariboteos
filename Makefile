Z_TOOLS = ./z_tools/
NASK = $(Z_TOOLS)nask
EDIMG = $(Z_TOOLS)edimg

# デフォルト動作

default :
	make img

ipl.bin : ipl.nas Makefile
	$(NASK) ipl.nas ipl.bin ipl.lst

haribote.sys : haribote.nas Makefile
	$(NASK) haribote.nas haribote.sys haribote.lst

haribote.img : ipl.bin haribote.sys Makefile
	$(EDIMG) imgin:$(Z_TOOLS)fdimg0at.tek \
		wbinimg src:ipl.bin len:512 from:0 to:0 \
		copy from:haribote.sys to:@: \
		imgout:haribote.img

# コマンド
asm :
	make -r ipl.bin

img :
	make -r haribote.img

run :
	make img
	qemu-system-i386 -fda haribote.img

clean :
	rm ipl.bin
	rm ipl.lst
	rm haribote.sys
	rm haribote.lst

src_only :
	make clean
	rm helloos.img
