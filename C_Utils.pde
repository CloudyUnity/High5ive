//========================================================
// Basic Math
//========================================================

// Clamps a value between a min and max
float clamp(float val, float minVal, float maxVal) {
  return max(min(val, maxVal), minVal);
}

// Tests if a float is approximately close to a value. Useful for floating point inprecision 
boolean approx(float val, float checkAgainst) {
  return abs(val - checkAgainst) < 0.0001f;
}

// Returns the sign of a value (-1 or 1)
int sign(float val) {
  return val == 0 ? 0
    : val < 0 ? -1
    : 1;
}

//========================================================
// PVector Math
//========================================================

// Spherical Linear Interpolation algorithm
PVector slerp(PVector a, PVector b, float t) {
  a = a.copy().normalize();
  b = b.copy().normalize();

  float dot = clamp(a.copy().dot(b), -1.0f, 1.0f);
  if (approx(dot, -1))
    return rotateY(a, PI * t);  

  float omega = acos(dot);
  if (approx(omega, 0))
    return PVector.lerp(a, b, t);

  return a.mult(sin((1-t) * omega) / sin(omega)).add(b.mult(sin(t * omega) / sin(omega))).normalize();
}

// Rotates a vector by an angle (radians) around the up vector (0, 1, 0)
PVector rotateY(PVector v, float angle) {
  float x = v.x * cos(angle) - v.z * sin(angle);
  float z = v.x * sin(angle) + v.z * cos(angle);
  return new PVector(x, v.y, z);
}

// Rotates a vector by an angle (radians) around the right vector (1, 0, 0)
PVector rotateX(PVector v, float angle) {
  float y = v.y * cos(angle) - v.z * sin(angle);
  float z = v.y * sin(angle) + v.z * cos(angle);
  return new PVector(v.x, y, z);
}

// Converts latitude-longitude coordinates to points on a sphere of a given radius 
private PVector coordsToPointOnSphere(double latitude, double longitude, float radius) {
  float radLat = radians((float)latitude);
  float radLong = radians((float)(longitude+180));

  float x = radius * cos(radLat) * cos(radLong);
  float y = radius * -sin(radLat);
  float z = radius * cos(radLat) * sin(radLong);

  return new PVector(x, y, z);
}

// Returns whether a point is within the bounds of a sector/pie slice
private boolean pointWithinSector(PVector center, int posX, int posY, float radius, float thetaA, float thetaZ) {
  if (dist(posX, posY, center.x, center.y) > radius)
    return false;

  float angle = atan2(posY - center.y, posX - center.x);
  if (angle < 0)
    angle += 2 * PI;
  if (thetaA < 0)
    thetaA += 2 * PI;
  if (thetaZ < 0)
    thetaZ += 2 * PI;

  if (thetaA < thetaZ)
    return angle >= thetaA && angle <= thetaZ;
  
  return angle >= thetaA || angle <= thetaZ;  
}

//========================================================
// Utils
//========================================================

// Tries to parse an integer from a string. Returns -1 if it cannot be parsed.
public int tryParseInteger(String str){
  try {
    return Integer.parseInt(str);
  }
  catch (Exception e){
    println("Invalid string entered");
    return -1;
  }
}

// Descending code authorship changes:
// F. Wright, Created C_Math tab, clamp(), slerp(), approx() and rotateY() for global use, 3pm 08/03/24
// F. Wright, Created sign(), rotateX(), 2pm 09/03/24
// F. Wright, Moved coordsToPointOnSphere here from W_FlightMap3D, 12pm 15/03/24
// F. Wright, Added tryParseInteger(String), 7pm 25/03/24
