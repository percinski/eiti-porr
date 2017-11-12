/* Program solving linear equation system
 * using Gauss-Jordan elimination algorithm
 * 
 * author: perciax
 * created: 2017-11-11
 * 
 * Solves equation set definied as Ax=b, where:
 * 	A - NxN matrix,
 *	b - N-size vector,
 * 	x - unkown N-size vector
 *
 * Reads problem definition from file with structure:
 * 	N
 *	a11 a12 ... a1N b1
 *	a21 a22 ... a2N b2
 *	.   .   ... .   .
 *	aN1 aN2 ... aNN bN
 *
 * Compiling: chpl -o gje gje.chpl
 * Running: ./gje --fname="path-to-file"
 * Optional flags:
 * 		--debug (bool, default: true) 
 *			set false to avoid lot of printing
 * 		--quiet (bool, default: false)
 * 			set true to avoid any printing(incl. timers) 
 */

use Time;

config const debug: bool = true;
config const quiet: bool = false;


// default name of file with task definition
config const fname = "data/3x4.txt";

// timer declaration
var t: Timer;

// print on screen
if debug && !quiet then{
	writeln("=== Gauss-Jordan elimination ===");
	writeln("Solving equations set: Ax=b");
}

// start timer
t.start();

// ==================== FILE READING ==============================

// open reader
var reader = open(fname, iomode.r).reader();

// read N (variables / equation number)
var N: int;
reader.read(N);

// read matrix A as array
var array: [1..N, 1..N+1] real;
reader.read(array);
reader.close();

// take last column of array read as vector b
var b: [1..N] real;
b = array[1..N, N+1];

// cut off last column from array read and save in A
var A: [1..N, 1..N] real;
A = array[1..N, 1..N];

// ================================================================

t.stop(); //stop timer

if !quiet then{
	writeln("Data from file loaded.");
	writeln("Time elapsed (loading): ", t.elapsed(TimeUnits.microseconds), " microseconds\n");
}

if debug && !quiet then{
	writeln("N = " + N);
	writeln("Array from file " + fname + ":\n", array, "\n");
	writeln("Vector b: \n", b, "\n");
	writeln("Matrix A: \n", A, "\n");
	writeln("Algorithm starting...");
}

t.clear(); // clear timer
t.start(); // start timer

// ================== SOLVING ====================================

// foward elimination
for k in {1..N-1}{		// eliminating rows loop
	for i in {k+1..N}{	// modified rows loop
		var alpha = A[i,k]/A[k,k]; // rows quotient
		
		for j in {k..N}{
			A[i,j]=A[i,j]-alpha*A[k,j];
		}
		
		b[i]=b[i]-alpha*b[k];	
	}
}

// backward substitution

// unknown vector declaration
var x : [1..N] real;

// calculating last unkown
x[N]=b[N]/A[N,N];

// calculating others unknowns
for i in {1..N-1}{
	var k : int = N-i; 	// iterating from last row
	x[k]=b[k];
	for j in {k+1..N}{
		x[k]=x[k]-A[k,j]*x[j];
	}
	x[k]=x[k]/A[k,k];
}

// =================================================================

t.stop(); //stop timer

if debug && !quiet then{
	// print A matrix
	writeln("Matrix A: \n", A);
	// print b vector
	writeln("Vector b: \n", b);
}

if !quiet then{
	writeln("Equations solved.");
	writeln("Time elapsed (solving): ", t.elapsed(TimeUnits.microseconds), " microseconds\n");
	
	// print vector x;
	writeln("Vector x: \n", x);
}

