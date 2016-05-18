# Victor Forbes - 9293394

all:
	cp src/initial.asm ./backup/initial.asm
	cp src/screens.asm ./backup/screens.asm
	cp src/utils.asm ./backup/utils.asm
	cp src/nave.asm ./backup/nave.asm
	cat src/initial.asm src/screens.asm src/utils.asm src/nave.asm > src/main.asm
	./montador src/main.asm mif/main.mif
run:
	./sim mif/main.mif mif/charmap.mif
clean:
	rm mif/main.mif
zip:
	zip -r 9293394.zip *