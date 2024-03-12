uniform mat4 transformMatrix;
uniform mat4 texMatrix;

attribute vec4 position;
attribute vec2 texCoord;

varying vec4 fragPos;
varying vec3 texPos;

void main() {
  fragPos = transformMatrix * position;    
  fragPos.z = fragPos.w;
  gl_Position = fragPos;

  texPos = position.xyz;
}

// Shaders written by Finn Wright