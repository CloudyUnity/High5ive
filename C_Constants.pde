// Engine
final int FRAME_RATE = 60;
final int FIXED_FRAME_INCREMENT = 50;
final int INPUT_ARRAY_LENGTH = 70000;
final boolean FULLSCREEN_ENABLED = false;

// Data / Files
final int LINE_BYTE_SIZE = 19;
final int NUMBER_OF_FLIGHT_FULL_LINES = 563737;
final int NUMBER_OF_AIRPORTS = 369;
final String DATA_DIRECTOR_PATH = "/data/Preprocessed Data/";

// Debug Options
final boolean DEBUG_MODE = true; // Turns on various stats or console logging
final int DEBUG_FPS_COUNTER_STORAGE = 30;
final boolean DEBUG_DATA_LOADING = true;
final boolean DEBUG_FPS_ENABLED = false;

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

// Descending code authorship changes:
// F. Wright, Set up constants for the Engine and Debug, 8pm 23/02/24
// F. Wright, Added InputClass related constants such as INPUT_ARRAY_LENGTH, 9pm 23/02/24
// F. Wright, Moved some default colour constants from classes to Constants tab, 6pm 04/03/24
// F. Wright, Created time related math constants for conversions, 2pm 06/03/24
