// Engine
final int FRAME_RATE = 60;
final int FIXED_FRAME_INCREMENT = 50;
final int INPUT_ARRAY_LENGTH = 70000;
final boolean FULLSCREEN_ENABLED = true;

// Data/Files
final int LINE_BYTE_SIZE = 24;
final int NUMBER_OF_FLIGHT_FULL_LINES = 638995;
final int NUMBER_OF_AIRPORTS = 374;
final String DATA_DIRECTOR_PATH = "/data/Preprocessed Data/";

// Debug Options
final boolean DEBUG_MODE = true; // Turns on various stats or console logging
final int DEBUG_FPS_COUNTER_STORAGE = 30;
final boolean DEBUG_DATA_LOADING = true;
final boolean DEBUG_FPS_ENABLED = true;
final boolean DEBUG_PRINT_3D_LOADING = false;

// Color Palette
final int CP_RED = #FF407D;
final int CP_PINK = #FFCAD4;
final int CP_BLUE = #40679E;
final int CP_NAVY = #1B3C73;
final int CP_WHITE = #F8F4EC;
final int CP_BLACK = #000000;
final int CP_LIGHT_BLUE = #589EF0;

// Scene
final int DEFAULT_FOREGROUND_COLOUR = CP_WHITE;
final int DEFAULT_BACKGROUND_COLOUR = CP_WHITE;
final int DEFAULT_OUTLINE_COLOUR = CP_PINK;
final int DEFAULT_CHECKBOX_CHECKED_COLOUR = CP_RED;
final int DEFAULT_RADIOBUTTON_CHECKED_COLOUR = CP_RED;
final int DEFAULT_SLIDER_FILLED_COLOUR = CP_BLUE;
final int DEFAULT_TEXT_COLOUR_INSIDE = CP_BLACK;
final int DEFAULT_TEXT_COLOUR_OUTSIDE = CP_WHITE;
final int DEFAULT_SCREEN_COLOUR = CP_LIGHT_BLUE;

// IDs
final String SCREEN_1_ID = "Screen 1";
final String SCREEN_2_ID = "Screen 2";
final String SWITCH_TO_DEMO_ID = "Barchart demo screen";
final String SCREEN_TWOD_MAP_ID = "Screen Flight Map 2D";
final String SCREEN_FLIGHT_MAP_ID = "Screen Flight Map";
final String ALEX_TESTING_ID = "Alex testing";

// Math
final long MILLI_TO_NANO = 1_000_000;
final long SECOND_TO_NANO = 1_000_000_000;
final PVector UP_VECTOR = new PVector(0, 1, 0);
final PVector RIGHT_VECTOR = new PVector(1, 0, 0);
final PVector FORWARD_VECTOR = new PVector(0, 0, 1);

// 2D Flight Map
final int NORTHERN_LOWER_48 = 50;
final int SOUTHERN_LOWER_48 = 24;
final int EASTERN_LOWER_48 = -66;
final int WESTERN_LOWER_48 = -125;
final int NORTHERN_ALL_50 = 72;
final int SOUTHERN_ALL_50 = -14;
final int EASTERN_ALL_50 = -64;
final int WESTERN_ALL_50 = 144;
final int WESTERN_ALL_50_ALT = 216;

// 3D Flight Map
final boolean DEBUG_3D_FAST_LOADING = false;
final int EARTH_Z = -20;
final int EARTH_SPHERE_SIZE = 400;
final float DAY_CYCLE_SPEED = 0.00005f;
final float VERTICAL_SCROLL_LIMIT = 0.6f;
final float VERTICAL_DRAG_SPEED = 0.000003f;
final int ARC_SEGMENTS = DEBUG_3D_FAST_LOADING ? 6 : 15;
final float ARC_HEIGHT_MULT = 0.5f;
final int ARC_SIZE = 1;
final float MARKER_SIZE = 1f;
final int TEXT_SIZE_3D = 12;
final PVector TEXT_DISPLACEMENT_3D = new PVector(0, 10, 10); 
final boolean DITHER_MODE = false;
final int MAX_DATA_LOADED = 700000;

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
