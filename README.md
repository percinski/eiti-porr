Program solving linear equation system
using Gauss-Jordan elimination algorithm

Solves equation set definied as Ax=b, where:

    A - NxN matrix,
    b - N-size vector,
    x - unkown N-size vector

Reads problem definition from file with structure:

 	N
	a11 a12 ... a1N b1
	a21 a22 ... a2N b2
	.   .   ... .   .
	aN1 aN2 ... aNN bN

 Compiling: 
 
    chpl -o gje gje.chpl
 
 Running: 
 
    ./gje --fname="path-to-file"
 
 Optional flags:

 		--debug (bool, default: true) 
			set false to avoid lot of printing
 		--quiet (bool, default: false)
 			set true to avoid any printing(incl. timers) 

