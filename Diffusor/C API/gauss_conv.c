#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <ctype.h>
#include "ip.h"

#define STD_SIGMA 1.0f
#define STD_KY 9
#define STD_KX 9

int perform_convolution(FILE *in, FILE *out, float sigma, int kx, int ky, const char *comment, BOOL binary);

int perform_convolution(FILE *in, FILE *out, float sigma, int kx, int ky, const char *comment, BOOL binary) {
  int ux = 0, uy = 0;
  float **u = ip_load_image(in, &ux, &uy, NULL);

  if (!u)
    return 4;

  float **kernel = gaussian_kernel(kx, ky, sigma);

  if (!kernel) {
    ip_deallocate_image(ux, uy, u);
    return 5;
  }

  // TODO Schummlung entfernen
  dummies(u, ux, uy);
  float **v = convolve(ux + 2, uy + 2, u, kx, ky, kernel);

  ip_deallocate_image(ux, uy, u);
  ip_deallocate_image(kx, ky, kernel);

  if (!v)
    return 6;

  ip_save_image(out, ux, uy, v, comment, binary);

  ip_deallocate_image(ux, uy, v);

  return 0;
}
