/* Program solving Powell 20 problem decomposed into local and dual tasks (separable)
 * Local optimization solved using COBYLA2 (nonlinear optimization solver)
 * Outer (dual) task solved with gradient method
 *
 * author: perciax
 * created: 2017-12-02
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
 */

// C files required to run this program
require "cobyla2c/cobyla.h", "cobyla2c/cobyla.c", "local.c";

// definition of lo function solving decomposed Powell 20 local task
// function defined in local.c file
extern proc localtask(n :int, p :int, i :int, lambdai:real(64), lambdamod : real(64)) : int;

// nuber of variables
config const n: int = 4;
// number of sub vectors
config const p: int = 2;

use Time;

writeln("================================ Powell 20 problem solver ===========================================");

// n config param validation
if (n>1000) then{
	writeln("Number of variables cannot exceed 1000");
	exit();
}
if (n<2) then{
	writeln("Number of variables cannot be lower than 2");
	exit();
}

var t: Timer;

writeln("=================================== C program output ================================================");

var rc: int;
var i: int = 1;
var lambdai: real(64) = 5.0;
var lambdamod: real(64) = 4.6;

t.start();
rc = localtask(n,p,i, lambdai, lambdamod);
t.stop();

writeln("================================ End of C program output ============================================");

if (rc==0) then{
	writeln("Returning from C program succesfully");
};

writeln("Time elapsed (solving): ", t.elapsed(TimeUnits.milliseconds), " milliseconds\n");

//===============================================================================================================
