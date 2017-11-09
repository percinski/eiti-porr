/* Program solving linear equation system
 * using Gauss-Jordan elimination algorithm
 * 
 * author: perciax
 * created: 
 */

// print on screen
writeln("=== Gauss-Jordan elimination ===");
writeln("Solving equations set: Ax=b");

// equations and variables number
const N: int = 3;

// domain (matrix A indexing) declaration 
var Adomain: domain(2) = {1..N,1..N};

// matrix A declaration (array)
var A: [Adomain] real;

A[1,1] = 1;
A[1,2] = 1;
A[1,3] = 1;
A[2,1] = 2;
A[2,2] = 3;
A[2,3] = 7;
A[3,1] = 1;
A[3,2] = 3;
A[3,3] = -2;

// vector b declaration
var b : [1..N] real = [3,0,17];

//for i in Adomain.dim(1){
//	for j in Adomain.dim(2){
//		A[i,j] = 3;
//	}
//} 

// print A matrix
writeln("Matrix A; ");
writeln(A);

// print b vector
writeln("Vector b:");
writeln(b); 

// foward elimination
writeln();
writeln("Forward elimination...");

for k in {1..N-1}{		// eliminating rows loop
	for i in {k+1..N}{	// modified rows loop
		var alpha = A[i,k]/A[k,k]; // rows quotient
		
		for j in {k..N}{
			A[i,j]=A[i,j]-alpha*A[k,j];
		}
		
		b[i]=b[i]-alpha*b[k];	
	}
}

// print A matrix
writeln("Matrix A; ");
writeln(A);

// print b vector
writeln("Vector b:");
writeln(b);

// backward substitution
writeln();
writeln("Backward substitution...");

// variables vector declaration
var x : [1..N] real;

x[N]=b[N]/A[N,N];
for i in {0..N-1}{
	var k : int = N-1-i; 	// iterating from last row
	writeln(k);
}
