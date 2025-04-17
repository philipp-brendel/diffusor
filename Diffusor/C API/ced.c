#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <ctype.h>
#include "ip.h"

#define STD_SIGMA 0.5f
#define STD_RHO 4.0f
#define STD_C 1.0f
#define STD_ALPHA 0.001f
#define STD_TAU 0.24f
#define STD_ITERATIONS 1

int perform_ced(FILE *in, FILE *out, float sigma, float rho, float C, float alpha, float tau, int iterations, const char *comment, BOOL binary);

int perform_ced(FILE *in, FILE *out, float sigma, float rho, float C, float alpha, float tau, int iterations, const char *comment, BOOL binary) {
  int nx = 0, ny = 0;
  float **f = ip_load_image(in, &nx, &ny, NULL);

  if (!f)
    return ~0;

  ip_gaussian_smooth(sigma, nx, ny, f);

  int i;
  for (i = 0; i < iterations; ++i) {
    ip_ced(C, rho, alpha, tau, nx, ny, f);
  }

  ip_save_image(out, nx, ny, f, comment, binary);

  ip_deallocate_image(nx, ny, f);

  return 0;
}
