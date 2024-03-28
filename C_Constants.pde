// Engine
final int FRAME_RATE = 75;

// Data/Files
final int US_LINE_BYTE_SIZE = 32;
final int WORLD_LINE_BYTE_SIZE = 6;
final String DATA_DIRECTOR_PATH = "/data/Preprocessed Data/";

// Debug Options
final boolean DEBUG_MODE = true; // Turns on various stats or console logging
final int DEBUG_FPS_COUNTER_STORAGE = 30;
final boolean DEBUG_FPS_ENABLED = true;
final boolean DEBUG_QUICK_LOAD_3D = false; // Turns off the earth shader for quick 3D loading

// Color Palette
final int CP_RED = #FF407D;
final int CP_PINK = #FFCAD4;
final int CP_BLUE = #40679E;
final int CP_NAVY = #1B3C73;
final int CP_WHITE = #F8F4EC;
final int CP_BLACK = #000000;
final int CP_LIGHT_BLUE = #589EF0;

final int COLOR_BACKGROUND = #272838;
final int COLOR_FOREGROUND = #7e7f9a;
final int COLOR_TEXT = #f9f8f8;
final int COLOR_HIGHTLIGHT_1 = #f3de8a;
final int COLOR_HIGHTLIGHT_2 = #eb9486;

// Scene
final int DEFAULT_FOREGROUND_COLOUR = CP_WHITE;
final int DEFAULT_BACKGROUND_COLOUR = COLOR_BACKGROUND;
final int DEFAULT_OUTLINE_COLOUR = COLOR_FOREGROUND;
final int DEFAULT_HIGHLIGHT_COLOR = COLOR_HIGHTLIGHT_1;
final int DEFAULT_CHECKBOX_CHECKED_COLOUR = CP_RED;
final int DEFAULT_RADIOBUTTON_CHECKED_COLOUR = CP_RED;
final int DEFAULT_SLIDER_FILLED_COLOUR = CP_BLUE;
final int DEFAULT_TEXT_COLOUR_INSIDE = COLOR_TEXT;
final int DEFAULT_TEXT_COLOUR_OUTSIDE = COLOR_TEXT;
final int DEFAULT_SCREEN_COLOUR = COLOR_BACKGROUND;
final int DEFAULT_WIDGET_ROUNDNESS_1 = 15;
final int DEFAULT_WIDGET_ROUNDNESS_2 = 40;
final float DEFAULT_WIDGET_STROKE = 3;
final float WIDGET_GROW_MODE_MULT = 1.1f;
final float SWITCH_SCREEN_DUR_3D = 1000.0f;

// IDs
final String SCREEN_1_ID = "Screen 1";
final String SCREEN_TWOD_MAP_ID = "Screen Flight Map 2D";
final String SCREEN_FLIGHT_MAP_ID = "Screen Flight Map";
final String SCREEN_CHARTS_ID = "Screen Charts";

// Math
final long MILLI_TO_NANO = 1_000_000;
final long SECOND_TO_NANO = 1_000_000_000;
final PVector UP_VECTOR = new PVector(0, 1, 0);
final PVector RIGHT_VECTOR = new PVector(1, 0, 0);
final PVector FORWARD_VECTOR = new PVector(0, 0, 1);

// 3D Flight Map
final int EARTH_Z_3D = -20;
final float VERTICAL_SCROLL_LIMIT_3D = 0.9f;
final float VERTICAL_DRAG_SPEED_3D = 0.000003f;
final float EARTH_FRICTION_3D = 0.99f;
final float ARC_HEIGHT_MULT_3D = 0.5f;
final int ARC_SIZE_3D = 1;
final float MARKER_SIZE_3D = 1f;
final int TEXT_SIZE_3D = 12;
final PVector TEXT_DISPLACEMENT_3D = new PVector(0, 10, 10);
final boolean DITHER_MODE_3D = false;
final float MOUSE_SCROLL_STRENGTH_3D = 15;

// Descending code authorship changes:
// F. Wright, Set up constants for the Engine and Debug, 8pm 23/02/24
// F. Wright, Added InputClass related constants such as INPUT_ARRAY_LENGTH, 9pm 23/02/24
// F. Wright, Moved some default colour constants from classes to Constants tab, 6pm 04/03/24
// F. Wright, Created time related math constants for conversions, 2pm 06/03/24
// F. Wright, Added a lot of 3D flight map related constants, 2pm 09/03/24
// CKM, Updated dataset constants, 23:00 11/03
// CKM, Added datasets for 2D map, 00:00 12/03
// CKM, Updated 3D dataset constants, 10:00 13/03
// M. Orlowski, Added Screen ID for 2D map, 11:00 13/03
// CKM, slimmed down unessecary constants to prevent issues like earlier 00:00 15/03
// F. Wright, Added more 3D constants and changed their names to have suffix "_3D", 10am 15/03/24
