uniform mat4 transformMatrix;
uniform mat4 texMatrix;

attribute vec4 position;
attribute vec2 texCoord;

varying vec4 vertTexCoord;
varying vec4 fragPos;

void main() {
  fragPos = transformMatrix * position;    
  // fragPos.z = fragPos.w;
  gl_Position = fragPos;

  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
}

// Shaders written by Finn Wright