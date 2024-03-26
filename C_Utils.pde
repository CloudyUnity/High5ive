//========================================================
// Basic Math
//========================================================

/**
 * F, Wright
 *
 * Clamps a value between a minimum and maximum value.
 *
 * @param val    The value to clamp.
 * @param minVal The minimum value.
 * @param maxVal The maximum value.
 * @return The clamped value.
 */
float clamp(float val, float minVal, float maxVal) {
  return max(min(val, maxVal), minVal);
}

/**
 * F, Wright
 *
 * Tests if a float value is approximately close to another value, useful for handling floating-point imprecision.
 *
 * @param val          The value to test.
 * @param checkAgainst The value to compare against.
 * @return True if the value is approximately close to the checkAgainst value, false otherwise.
 */
boolean approx(float val, float checkAgainst) {
  return abs(val - checkAgainst) < 0.0001f;
}

/**
 * F, Wright
 *
 * Returns the sign of a value (-1 if negative, 1 if positive, 0 if zero).
 *
 * @param val The value to determine the sign of.
 * @return -1 if the value is negative, 1 if positive, and 0 if zero.
 */
int sign(float val) {
  return val == 0 ? 0
    : val < 0 ? -1
    : 1;
}

//========================================================
// PVector Math
//========================================================

/**
 * F, Wright
 *
 * Performs spherical linear interpolation (SLERP) between two vectors.
 *
 * @param a The start vector.
 * @param b The end vector.
 * @param t The interpolation parameter (between 0 and 1).
 * @return The interpolated vector.
 */
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

/**
 * F, Wright
 *
 * Rotates a vector around the up vector (0, 1, 0) by a specified angle (radians).
 *
 * @param v     The vector to rotate.
 * @param angle The angle of rotation in radians.
 * @return The rotated vector.
 */
PVector rotateY(PVector v, float angle) {
  float x = v.x * cos(angle) - v.z * sin(angle);
  float z = v.x * sin(angle) + v.z * cos(angle);
  return new PVector(x, v.y, z);
}

/**
 * F, Wright
 *
 * Rotates a vector around the right vector (1, 0, 0) by a specified angle (radians).
 *
 * @param v     The vector to rotate.
 * @param angle The angle of rotation in radians.
 * @return The rotated vector.
 */
PVector rotateX(PVector v, float angle) {
  float y = v.y * cos(angle) - v.z * sin(angle);
  float z = v.y * sin(angle) + v.z * cos(angle);
  return new PVector(v.x, y, z);
}

/**
 * F, Wright
 *
 * Converts latitude and longitude coordinates to points on a sphere of a given radius.
 *
 * @param latitude  The latitude in degrees.
 * @param longitude The longitude in degrees.
 * @param radius    The radius of the sphere.
 * @return A {@code PVector} representing the point on the sphere.
 */
private PVector coordsToPointOnSphere(double latitude, double longitude, float radius) {
  float radLat = radians((float)latitude);
  float radLong = radians((float)(longitude+180));

  float x = radius * cos(radLat) * cos(radLong);
  float y = radius * -sin(radLat);
  float z = radius * cos(radLat) * sin(radLong);

  return new PVector(x, y, z);
}

/**
 * F, Wright
 *
 * Checks whether a point is within the bounds of a sector/pie slice.
 *
 * @param center  The center of the sector.
 * @param posX    The x-coordinate of the point to check.
 * @param posY    The y-coordinate of the point to check.
 * @param radius  The radius of the sector.
 * @param thetaA  The starting angle of the sector in radians.
 * @param thetaZ  The ending angle of the sector in radians.
 * @return {@code true} if the point is within the sector, {@code false} otherwise.
 */
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

/**
 * F, Wright
 *
 * Tries to parse an integer from a string. Returns -1 if it cannot be parsed.
 *
 * @param str The string to parse.
 * @return The parsed integer value, or -1 if parsing fails.
 */
public int tryParseInteger(String str) {
  try {
    return Integer.parseInt(str);
  }
  catch (Exception e) {
    println("Invalid string entered");
    return -1;
  }
}

// Descending code authorship changes:
// F. Wright, Created C_Math tab, clamp(), slerp(), approx() and rotateY() for global use, 3pm 08/03/24
// F. Wright, Created sign(), rotateX(), 2pm 09/03/24
// F. Wright, Moved coordsToPointOnSphere here from W_FlightMap3D, 12pm 15/03/24
// F. Wright, Added tryParseInteger(String), 7pm 25/03/24
