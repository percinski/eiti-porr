/* cobyla : contrained optimization by linear approximation */
/* Example driver */

/*
 * Copyright (c) 1992, Michael J. D. Powell (M.J.D.Powell@damtp.cam.ac.uk)
 * Copyright (c) 2004, Jean-Sebastien Roy (js@jeannot.org)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

/*
 * This software is a C version of COBYLA, contrained optimization by linear
 * approximation package originally developed by Michael J. D. Powell in
 * Fortran.
 *
 * The original source code can be found at :
 * http://plato.la.asu.edu/topics/problems/nlores.html
 */

static char const rcsid[] =
  "@(#) $Jeannot: example.c,v 1.10 2004/04/17 23:19:15 js Exp $";

#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#include "cobyla.h"

cobyla_function calcfc;

typedef struct
{
  int nprob;
} example_state;

/* ------------------------------------------------------------------------- */
/* Main program of test problems in Report DAMTP 1992/NA5. */
/* ------------------------------------------------------------------------- */
int example()
{
  /* System generated locals */
  int i__1;
  double d__1;

  /* Local variables */
  double rhoend;
  double temp, xopt[10];
  double x[10], tempa, tempb, tempc, tempd, rhobeg;
  int i__, m = 0, n = 0, icase;
  int maxfun, iprint, rc;
  example_state state;

/* Minimization of a simple quadratic function of two variables. */

      fprintf(stderr, "\n       Output from test problem 1 (Simple quadratic)\n");
      n = 2;
      m = 0;
      xopt[0] = -1.;
      xopt[1] = 0.;

      i__1 = n;
      for (i__ = 1; i__ <= i__1; ++i__) {
        x[i__ - 1] = 1.;
      }
      rhobeg = .5;
      rhoend = 1e-6;
	iprint = 1;
      
      maxfun = 3500;
      rc = cobyla(n, m, x, rhobeg, rhoend, iprint, &maxfun, calcfc, &state);

      temp = 0.;
      i__1 = n;
      for (i__ = 1; i__ <= i__1; ++i__) {
        d__1 = x[i__ - 1] - xopt[i__ - 1];
        temp += d__1 * d__1;
      }
      fprintf(stderr, "\n     Least squares error in variables =    %.6E\n", sqrt(temp));
  return 0;
} /* main */

/* ------------------------------------------------------------------------- */
int calcfc(int n, int m, double *x, double *f, double *con, void *state_)
{
  /* System generated locals */
  double d__1, d__2, d__3, d__4, d__5, d__6, d__7;

  /* Parameter adjustments */
  --con;
  --x;

  /* Function Body */

/* Test problem 1 (Simple quadratic) */

    d__1 = x[1] + 1.;
    d__2 = x[2];
    *f = d__1 * d__1 * 10. + d__2 * d__2;

  return 0;
} /* calcfc */
