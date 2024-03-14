uniform mat4 transformMatrix;
uniform mat4 texMatrix;
uniform mat3 normalMatrix;

attribute vec4 position;
attribute vec2 texCoord;
attribute vec3 normal;

varying vec4 vertTexCoord;
varying vec4 fragPos;
varying vec3 fragNormal;
varying vec3 fragTangent;
varying vec3 fragBinormal;
varying vec3 normMapNormal;

void main() {
  fragPos = transformMatrix * position;    
  gl_Position = fragPos;

  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);

  fragNormal = normalize(normal);
  normMapNormal = normalize(normalMatrix * normal);
  vec3 vRef = vec3(0, 1, 0);
  if (abs(dot(normMapNormal, vRef)) == 1)
    vRef = vec3(0, 0, 1);

  fragTangent = normalize(cross(vRef, normMapNormal));  
  fragBinormal = normalize(cross(normMapNormal, fragTangent));
}

// Shaders written by Finn Wright