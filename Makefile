Z_TOOLS	= ./z_tools/
INPACH 	= ./z_tools/haribote/

NASK 	= $(Z_TOOLS)nask
CC1 	= $(Z_TOOLS)gocc1 -I$(INCPATH) -Os -Wall -quiet
GAS2NASK= $(Z_TOOLS)gas2nask -a
OBJ2BIM = $(Z_TOOLS)obj2bim
MAKEFONT= $(Z_TOOLS)makefont
BIN2OBJ = $(Z_TOOLS)bin2obj
BIM2HRB	= $(Z_TOOLS)bim2hrb
RULEFILE= haribote.rul
EDIMG 	= $(Z_TOOLS)edimg
HARITOL	= $(Z_TOOLS)haritol
# デフォルト動作

default :
	make img

%.bin : %.nas Makefile
	$(NASK) $*.nas $*.bin $*.lst

%.gas : %.c Makefile
	$(CC1) -o $*.gas $*.c

%.nas : %.gas Makefile
	$(GAS2NASK) $*.gas $*.nas

%.obj : %.nas Makefile
	$(NASK) $*.nas $*.obj $*.lst

hankaku.bin : hankaku.txt Makefile
	$(MAKEFONT) hankaku.txt hankaku.bin

hankaku.obj : hankaku.bin Makefile
	$(BIN2OBJ) hankaku.bin hankaku.obj _hankaku

bootpack.bim : bootpack.obj graphic.obj dsctbl.obj naskfunc.obj hankaku.obj int.obj fifo.obj keyboard.obj mouse.obj sheet.obj memory.obj timer.obj Makefile
	$(OBJ2BIM) @$(RULEFILE) out:bootpack.bim stack:3136k map:bootpack.map \
	  bootpack.obj graphic.obj dsctbl.obj naskfunc.obj hankaku.obj int.obj fifo.obj keyboard.obj mouse.obj sheet.obj memory.obj timer.obj

bootpack.hrb : bootpack.bim Makefile
	$(BIM2HRB) bootpack.bim bootpack.hrb 0

haribote.sys : asmhead.bin bootpack.hrb Makefile
	$(HARITOL) concat haribote.sys asmhead.bin bootpack.hrb

haribote.img : ipl.bin haribote.sys Makefile
	$(EDIMG) imgin:./z_tools/fdimg0at.tek \
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
	rm *.bin
	rm *.lst
	rm *.obj
	rm *.gas
	rm bootpack.hrb
	rm bootpack.map
	rm bootpack.bim
	rm haribote.sys

src_only :
	make clean
	rm haribote.img
