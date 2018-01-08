/* Program solving linear equation system
 * using Gauss-Jordan elimination algorithm in distributed data-parallel mode 
 * 
 * author: perciax
 * created: 2018-01-07
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
 * Running: ./gje --fname="path-to-file" --numLocales=2
 *          Specifying file name and numebr of locales is required
 *
 * Optional flags:
 * 		--debug 	(bool, default: true) 
 *				set false to avoid lot of printing
 * 		--quiet 	(bool, default: false)
 * 				set true to avoid any printing(only computation timing) 
 *		--time		( seconds | milliseconds | microseconds )
 *				set time quant to print elapsed time
 */

    use CyclicDist;
	use Time;

	config const debug: bool = true;
	config const quiet: bool = false;
	config const parallel: bool = false;

	config const time: string = "milliseconds";

	// default name of file with task definition
	config const fname: string = "";

		// timer declaration
		var t: Timer;

		// if file name is empty print usage to user
		if (fname=="") then{
			writeln("Usage: ge --fname=\"path-to-file\" [Options]\n");
			writeln("\t Options:");
			writeln("\t\t --debug [true|false]\t - to avoid a lot of priting");
			writeln("\t\t --quiet [true|false]\t - to avoid any printig (except computation time)");
			writeln("\t\t --time [seconds|milliseconds|microseconds]\t - time quant to print elapsed time");
			writeln("\t\t --parallel [true|false]\t - to perfrom computation using data parallelism\n");
			exit();

		}

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
			select(time){
				when "microseconds" {
					writeln("Time elapsed (loading): ", t.elapsed(TimeUnits.microseconds), " microseconds\n");
				}
				when "milliseconds" {
					writeln("Time elapsed (loading): ", t.elapsed(TimeUnits.milliseconds), " milliseconds\n");
				}
				when "seconds" {
					writeln("Time elapsed (loading): ", t.elapsed(), " seconds\n");
				}
			}
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
		for k in {1..N}{		// eliminating rows loop

			    const columns = {1..N} dmapped Cyclic(startIdx=1);

				forall i in columns do eliminate(i,k);
			
		}

		// unknown vector declaration
		var x : [1..N] real;

		// calculating unknowns
		for k in {1..N}{
			x[k]=b[k]/A[k,k];
		}

		// =================================================================

		t.stop(); //stop timer

		if debug && !quiet then{
			// print A matrix
			writeln("Matrix A: \n", A);
			// print b vector
			writeln("Vector b: \n", b);
		}


		writeln("Equations solved.");
		select(time){
			when "microseconds" {
				writeln("Time elapsed (solving): ", t.elapsed(TimeUnits.microseconds), " microseconds\n");
			}
			when "milliseconds" {
				writeln("Time elapsed (solving): ", t.elapsed(TimeUnits.milliseconds), " milliseconds\n");
			}
			when "seconds" {
				writeln("Time elapsed (solving): ", t.elapsed(), " seconds\n");
			}
		}

		if !quiet then{
			// print vector x;
			writeln("Vector x: \n", x);	
		}else{
			writeln("[Set --quiet=false (default) to see result]");
		}
	

proc eliminate(i: int, k: int) :void
{
        
		if(i==k) then return;

        if debug && !quiet then{
            writeln("Eliminating:\t row:", k, " col:", i, "\ton locale:", here.id, " of ", numLocales);
        }

		var alpha = A[i,k]/A[k,k]; // rows quotient
	
		for j in {k..N}{
			A[i,j]=A[i,j]-alpha*A[k,j];
		}
	
		b[i]=b[i]-alpha*b[k];
 
}
