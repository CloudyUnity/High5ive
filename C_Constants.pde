// Engine
final int FRAME_RATE = 60;
final int FIXED_FRAME_INCREMENT = 50;
final int INPUT_ARRAY_LENGTH = 70000;
final boolean FULLSCREEN_ENABLED = false;

// Data/Files
final int LINE_BYTE_SIZE = 19;
final int NUMBER_OF_FLIGHT_FULL_LINES = 563737;
final int NUMBER_OF_AIRPORTS = 369;
final String DATA_DIRECTOR_PATH = "/data/Preprocessed Data/";

// Debug Options
final boolean DEBUG_MODE = true; // Turns on various stats or console logging
final int DEBUG_FPS_COUNTER_STORAGE = 30;
final boolean DEBUG_DATA_LOADING = true;
final boolean DEBUG_FPS_ENABLED = true;

// Scene
final int DEFAULT_FOREGROUND_COLOUR = #000000;
final int DEFAULT_BACKGROUND_COLOUR = #F9F9F9;
final int DEFAULT_OUTLINE_COLOUR = #000000;
final int DEFAULT_CHECKBOX_CHECKED_COLOUR = #FF0000;
final int DEFAULT_RADIOBUTTON_CHECKED_COLOUR = #00BCD4;
final int DEFAULT_SLIDER_FILLED_COLOUR = #00BCD4;

// IDs
final String SCREEN_1_ID = "Screen 1";
final String SCREEN_2_ID = "Screen 2";
final String SWITCH_TO_DEMO_ID = "Barchart demo screen";
final String SCREEN_FLIGHT_MAP_ID = "Screen Flight Map";

// Color Palette (TODO)
final int EXAMPLE_COLOR_1 = #000000;
final int EXAMPLE_COLOR_2 = #000000;

// Math
final long MILLI_TO_NANO = 1_000_000;
final long SECOND_TO_NANO = 1_000_000_000;
final PVector UP_VECTOR = new PVector(0, 1, 0);
final PVector RIGHT_VECTOR = new PVector(1, 0, 0);
final PVector FORWARD_VECTOR = new PVector(0, 0, 1);

// 3D Flight Map
final PVector WINDOW_SIZE_3D_FLIGHT_MAP = new PVector(1200, 800);
final int EARTH_Z = -20;
final int EARTH_SPHERE_SIZE = 300;
final float DAY_CYCLE_SPEED = 0.00005f;
final float VERTICAL_SCROLL_LIMIT = 0.5f;
final float VERTICAL_DRAG_SPEED = 0.000003f;
final int ARC_SEGMENTS = 15;
final float ARC_HEIGHT_MULT = 0.5f;
final int ARC_SIZE = 3;
final float MARKER_SIZE = 1.5f;

// Descending code authorship changes:
// F. Wright, Set up constants for the Engine and Debug, 8pm 23/02/24
// F. Wright, Added InputClass related constants such as INPUT_ARRAY_LENGTH, 9pm 23/02/24
// F. Wright, Moved some default colour constants from classes to Constants tab, 6pm 04/03/24
// F. Wright, Created time related math constants for conversions, 2pm 06/03/24
// F. Wright, Added a lot of 3D flight map related constants, 2pm 09/03/24 
