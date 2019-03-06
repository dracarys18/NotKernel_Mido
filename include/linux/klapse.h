#ifndef _KLAPSE_H
#define _KLAPSE_H

/* KLAPSE_MDSS : Use 1 if using with MDSS */
#define KLAPSE_MDSS 1

/* set_rgb_slider : Interface function for brightness-mode */
typedef int bl_type_t;
extern void set_rgb_slider(bl_type_t bl_lvl);

/* Variable type for rgb */
typedef unsigned short col_type_t;

void kcal_ext_apply_values(int red, int green, int blue);
int kcal_ext_get_value(int color);

enum rgb {
	KCAL_RED = 0,
	KCAL_GREEN,
	KCAL_BLUE,
};

#define KCAL_COLOR(x) (kcal_ext_get_value(x))
#define K_RED KCAL_COLOR(KCAL_RED)
#define K_GREEN KCAL_COLOR(KCAL_GREEN)
#define K_BLUE KCAL_COLOR(KCAL_BLUE)
/* Constants - Customize as needed */
#define DEFAULT_ENABLE 0 /* 0 = off, 1 = time-based, 2 = brightness-based */

#define MAX_SCALE 256 /* Maximum value of RGB possible */

#define MIN_SCALE 20 /* Minimum value of RGB recommended */

#define MAX_BRIGHTNESS 1023 /* Maximum display brightness */

#define MIN_BRIGHTNESS 2 /* Minimum display brightness */

#define UPPER_BL_LVL 400 /* Upper target for brightness-dependent mode */

#define LOWER_BL_LVL 2 /* Lower target for brightness-dependent mode */

#define DEFAULT_FLOW_FREQ 360 /* Flow delays for rapid pushes in mode 2 */

#endif  /* _KLAPSE_H */
