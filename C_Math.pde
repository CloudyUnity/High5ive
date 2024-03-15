// Basic Math

float clamp(float val, float minVal, float maxVal) {
  return max(min(val, maxVal), minVal);
}

boolean approx(float val, float checkAgainst) {
  return abs(val - checkAgainst) < 0.0001f;
}

int sign(float val) {
  return val == 0 ? 0
    : val < 0 ? -1
    : 1;
}

// PVector Math

PVector slerp(PVector a, PVector b, float t) {
  a = a.copy().normalize();
  b = b.copy().normalize();

  float dot = clamp(a.copy().dot(b), -1.0f, 1.0f);
  if (approx(dot, -1)) {
    return rotateY(a, PI * t);
  }

  float omega = acos(dot);
  if (approx(omega, 0))
    return PVector.lerp(a, b, t);

  return a.mult(sin((1-t) * omega) / sin(omega)).add(b.mult(sin(t * omega) / sin(omega))).normalize();
}

PVector rotateY(PVector v, float angle) {
  float x = v.x * cos(angle) - v.z * sin(angle);
  float z = v.x * sin(angle) + v.z * cos(angle);
  return new PVector(x, v.y, z);
}

PVector rotateX(PVector v, float angle) {
  float y = v.y * cos(angle) - v.z * sin(angle);
  float z = v.y * sin(angle) + v.z * cos(angle);
  return new PVector(v.x, y, z);
}

private PVector coordsToPointOnSphere(double latitude, double longitude, float radius) {
  float radLat = radians((float)latitude);
  float radLong = radians((float)(longitude+180));

  float x = radius * cos(radLat) * cos(radLong);
  float y = radius * -sin(radLat);
  float z = radius * cos(radLat) * sin(radLong);

  return new PVector(x, y, z);
}

// Descending code authorship changes:
// F. Wright, Created C_Math tab, clamp(), slerp(), approx() and rotateY() for global use, 3pm 08/03/24
// F. Wright, Created sign(), rotateX(), 2pm 09/03/24
// F. Wright, Moved coordsToPointOnSphere here from W_FlightMap3D, 12pm 15/03/24
