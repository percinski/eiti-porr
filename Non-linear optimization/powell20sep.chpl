/* Program solving Powell 20 problem decomposed into local and dual tasks (separable)
 * Local optimization solved using COBYLA2 (nonlinear optimization solver)
 * Outer (dual) task solved with gradient method
 *
 * author: perciax
 * created: 2017-12-03
 *
 * Compiling: chpl -o powell20sep.o powell20sep.chpl
 * Running: ./powell20.sep [options]
 * Options:
 * 		--n 	    (int, default: 4, max 1000) 
 *			        number of variables for Powell 20 problem
 * 		--p 	    (int, default: 2, max 500) 
 *			        number of subvectors in Powell 20 problem
 *      --parallel  (bool, default: false)
 *                  set if task local task should be performed in parallel
 *      --maxIter   (int, default: 10)
 *                  numb of iteration for gradient descent algorithm
 */

// C files required to run this program
require "cobyla2c/cobyla.h", "cobyla2c/cobyla.c", "local.c";

// definition of lo function solving decomposed Powell 20 local task
// function defined in local.c file
extern proc localtask(n :int, p :int, i :int, lambdai:real(64), lambdamod : real(64)) : int;

extern proc getArrayValByPtr(i:int, a: c_ptr(c_double));

// nuber of variables
config const n: int = 4;
// number of sub vectors
config const p: int = 2;
//
config const maxIter: int = 10;
//
config const parallel: bool = false;

// alfa for gradient
param alpha = 0.1;

use Time;

//writeln("================================ Powell 20 problem solver ===========================================");

// n config param validation
if (n>1000) then{
	writeln("Number of variables cannot exceed 1000");
	exit();
}
if (n<2) then{
	writeln("Number of variables cannot be lower than 2");
	exit();
}

// variables
var t: Timer;
var rc: int;
var mod : int;
var lambdai: real(64);
var lambdamod: real(64);
var lambdas : [1..p] real(64);
var lambdasOld : [1..p] real(64);

var x : [1..n] real(64);

var N: int = n/p;

for i in {1..n}{
    x[i]= 1.0;
}

for i in {1..p}{
    lambdas[i]= 1.0;
}

var stop: real = 1;

//writeln("=================================== C program output ================================================");

t.start();

var e :real =1000.0;
var k :int =0;

while(e>stop){

    if !parallel then{

        for i in {1..p}{
            solvelocal(i);
        }

    }else{
        forall i in 1..p do solvelocal(i);
    }
    
    lambdasOld=lambdas;

    for i in {1..p}{
        mod = i%p + 1;
        var c: real(64) = -.5 + (-1)^(i*N)*i*N;
        //writeln("c = " + c);
        lambdas[i]=lambdas[i]+alpha*(x[i+N]-x[mod+1]+c);
    }

    e=0.0;
    for j in {1..p}{ e=e+(lambdas[j]-lambdasOld[j])*(lambdas[j]-lambdasOld[j]); }
    e=e/p;
    //writeln("MSE for lambdas between iterations: " + e);

    k=k+1;
    if (k>=maxIter) then{
        writeln("Maximum number of iterations reached!");
        break;
    }
}
writeln("MSE for lambdas between iterations: " + e);
for k in {1..maxIter}{
    
   
}

t.stop();

//writeln("================================ End of C program output ============================================");

writeln("\nx: ");
writeln(x);
writeln("\nlambdas: ");
writeln(lambdas);

writeln("\nTime elapsed (solving): ", t.elapsed(), " seconds\n");

//===============================================================================================================

proc solvelocal(i: int) :void
{
		lambdai = lambdas[i];
        mod = (p-2+i)%p+1;
        lambdamod = lambdas[mod];

        rc = localtask(n,p,i, lambdai, lambdamod);

        for j in {1..N}{
            getArrayValByPtr(j-1,c_ptrTo(x[(i-1)*N+j]));
        }
}
