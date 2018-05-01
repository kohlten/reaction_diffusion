DC=dmd
OUT=bin/mines

$(OUT): DSFMLC
	dub build --compiler=$(DC)

DSFMLC:
	-git clone https://github.com/Jebbs/DSFMLC.git
	-cd DSFMLC && cmake . && make
	cp -rf DSFMLC/extlibs/libs-osx/Frameworks .
	cp DSFMLC/lib/* Frameworks

clean:
	dub clean
	-rm -rf bin/*

fclean: clean
	-rm dub.selections.json
	-rm -rf .dub
	-rm -rf DSFMLC
	-rm -rf Frameworks

re: clean $(OUT)

.PHONY: clean fclean
