/* Program solving Powell 20 problem
 * using COBYLA2 nonlinear optimization solver
 * 
 * author: perciax
 * created: 2017-12-01
 *
 * Compiling: chpl -o powell20 powell20.chpl
 * Running: ./powell20 [options]
 * Options:
 * 		--n 	(int, default: 2, max 1000) 
 *			number of variables for Powell 20 problem
 */

// C files required to run this program
require "cobyla2c/cobyla.h", "cobyla2c/cobyla.c", "powell20.c";

// definition of powell20 function solving Powell 20 problem
// function defined in powell20.c file
extern proc powell20(n :int) : int;

// nuber of variables
config const n: int = 2;

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

t.start();
rc = powell20(n);
t.stop();

writeln("================================ End of C program output ============================================");

if (rc==0) then{
	writeln("Returning from C program succesfully");
};

writeln("Time elapsed (solving): ", t.elapsed(TimeUnits.milliseconds), " milliseconds\n");

//===============================================================================================================
