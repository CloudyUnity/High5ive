uniform mat4 transformMatrix;
uniform mat4 texMatrix;

attribute vec4 position;
attribute vec2 texCoord;
attribute vec3 normal;

varying vec4 vertTexCoord;
varying vec4 fragPos;
varying vec3 fragNormal;
varying vec3 fragTangent;
varying vec3 fragBinormal;

void main() {
  fragPos = transformMatrix * position;    
  gl_Position = fragPos;

  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);

  fragNormal = normalize(normal);
/*
  vec3 vRef = vec3(0, 1, 0);
  if (abs(dot(fragNormal, vRef)) == 1)
    vRef = vec3(0, 0, 1);

  fragTangent = normalize(cross(vRef, fragNormal));  
*/

  vec3 u = normalize(position.xyz / position.w);
  vec3 v = normalize(cross(u, vec3(0, 1, 0)));
  fragTangent = cross(u, v);

  fragBinormal = normalize(cross(fragNormal, fragTangent));
}

// Shaders written by Finn Wright