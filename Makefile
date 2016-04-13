CC=openscad
CFLAGS=
FNAME=openpiboi
FTYPE=stl

$(FNAME).$(FTYPE):
	$(CC) $(CFLAGS) -o $(FNAME).$(FTYPE) $(FNAME).scad

clean:
	rm $(FNAME).$(FTYPE)
