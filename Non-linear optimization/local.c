#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#include "cobyla2c/cobyla.h"

cobyla_function calcfc;

typedef struct
{
  double i;
  double mod;
} lambdas_state;

/* ------------------------------------------------------------------------- */
/* Program solving local task of decomposed powell 20 problem using COBYLA solver
/* Description and License of COBYLA in file cobyla2c/cobyla.h
/* ------------------------------------------------------------------------- */
int localtask(int _n, int _p, int _i, double _lambdai, double _lambdamod)
{
  /* Local variables */
  int l;
	int i, n, p, N; 
  double rhoend, rhobeg;
  double x[1000];
  int m; 
  int maxfun, message, rc;
  lambdas_state lambdas;

	/* number of all variables */
  n = _n;

  /* number of subvectors */
  p = _p;

  /* number of current subvector (group) */
  i = _i;

  /* number of variables in on subvector */
  N = (int)(n/p);
  
  /* lambdas */
  lambdas.i = _lambdai;  
  lambdas.mod = _lambdamod;

  /* Printing */
  fprintf(stderr, "Number of all variables: n = %d \n", n);
  fprintf(stderr, "Number of subvectors: p = %d \n", p);
  fprintf(stderr, "Number of current subvector: i = %d \n", i);
  fprintf(stderr, "Number of variables in subvector: N = %d \n", N);
  fprintf(stderr, "Lambda = %f \n", lambdas.i);
  fprintf(stderr, "Lambda mod = %f \n", lambdas.mod);
	
  /* number of constarints */
  m = 0;
  
	/* initialize variables with value 1 */
	for (l = 0; l < N; ++l) {
	  x[l] = 1.;
  }

	/* Beginnign step for optimization */
  rhobeg = .5;

	/* Required accuracy */
  rhoend = 1e-8;
	
	/* Message for COBYLA: 1 - printing just exit info and results */
	message = 1;

	/* Maximum number of function evaluations */      
  maxfun = 3500;

  rc = cobyla(N, m, x, rhobeg, rhoend, message, &maxfun, calcfc, &lambdas);

  return rc;
}

/* ------------------------------------------------------------------------- */
int calcfc(int n, int m, double *x, double *f, double *con, void *state_)
{
	int l;
  lambdas_state *lambdas = (lambdas_state *)state_;	

	/* temp function value */	
	double f_temp = 0.0;

  /* move array pointer for indexing variables from 1 */
	--x;

	/* move array pointer for indexing constraints from 1 */
	--con;

  /* summ of squares of variables */
	for(l=1; l<=n; ++l){
		f_temp=f_temp+.5*x[l]*x[l]+(lambdas->i)*x[n]+(lambdas->mod)*x[1];
	}

	/* return function */
   *f = f_temp;
	
	/* return */
  return 0;
}
