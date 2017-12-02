#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#include "cobyla2c/cobyla.h"

cobyla_function calcfc;

/* ------------------------------------------------------------------------- */
/* Program solving powell 20 problem using COBYLA solver
/* Description and License of COBYLA in file cobyla2c/cobyla.h
/* ------------------------------------------------------------------------- */
int powell20(int varnumb)
{
  /* Local variables */
	int i;  
  double rhoend, rhobeg;
  double x[1000];
  int m, n; 
  int maxfun, message, rc;

	/* number of variables */
	n = varnumb;

	/* Printing */
  fprintf(stderr, "Output from Powell 20 problem for %d variables\n", n);
  
	/* number of constarints */
  m = n;
  
	/* initialize variables with value 1 */
	for (i = 1; i < n; ++i) {
	  x[i] = 1.;
  }

	/* Beginnign step for optimization */
  rhobeg = .5;

	/* Required accuracy */
  rhoend = 1e-8;
	
	/* Message for COBYLA: 1 - printing just exit info and results */
	message = 1;

	/* Maximum number of function evaluations */      
  maxfun = 3500;

  rc = cobyla(n, m, x, rhobeg, rhoend, message, &maxfun, calcfc, NULL);

  return rc;
}

/* ------------------------------------------------------------------------- */
int calcfc(int n, int m, double *x, double *f, double *con, void *state_)
{
	int i,k;	

	/* temp function value */	
	double f_temp = 0.0;

  /* move array pointer for indexing variables from 1 */
	--x;

	/* move array pointer for indexing constraints from 1 */
	--con;

  /* summ of squares of variables */
	for(i=1; i<=n; ++i){
		f_temp=f_temp+x[i]*x[i];
	}

	/* return function */
   *f = 0.5*f_temp;

	/* constraints */
	for(k=1; k<=m-1; ++k){
		con[k]=(x[k+1]-x[k])-(-.5+pow(-1.,k)*k);
	}

	con[m]=(x[1]-x[n])-(n-.5);
	
	/* return */
  return 0;
}
