
 all : cacl houzhui
 .PHONY:all,clean,run1,run2
cacl:
	bison -d cacl.y
	gcc -o cacl.out cacl.tab.c

houzhui:
	bison -d houzhui.y
	gcc -o houzhui.out houzhui.tab.c
run1:
	./cacl.out 
run2:
	./houzhui.out
clean:
	-rm -f *.c *.h *.out 
