FLAGS=-fopenmp -w -O3

# CXX=icpc

RM=rm -f

EXEC=serial

all: $(EXEC)

$(EXEC):
	$(CXX) $(FLAGS) $(EXEC).cpp -c -o $(EXEC).o
	$(CXX) $(FLAGS) $(EXEC).o -o $(EXEC)

	$(CXX) $(FLAGS) parallel.cpp -c -o parallel.o
	$(CXX) $(FLAGS) parallel.o -o parallel

clean:
	$(RM) $(EXEC).o $(EXEC)
