uniform mat4 transformMatrix;
uniform mat4 texMatrix;

attribute vec4 position;
attribute vec2 texCoord;
attribute vec3 normal;
attribute vec3 tangent;
attribute vec3 binormal;

varying vec4 vertTexCoord;
varying vec3 fragNormal;
varying vec3 fragTangent;
varying vec3 fragBinormal;

void main() {
  gl_Position = transformMatrix * position;    
  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
  fragNormal = normalize(normal);
  fragTangent = normalize(tangent);
  fragBinormal = normalize(binormal);
}