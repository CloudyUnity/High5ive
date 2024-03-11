#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D tex;

uniform vec3 lightDir;
uniform vec2 mousePos;
uniform vec2 texTranslation;

varying vec4 vertTexCoord;
varying vec4 fragPos;
varying vec3 fragNormal;
varying vec3 fragTangent;
varying vec3 fragBinormal;

void main() {
  gl_FragColor = vec4(texture2D(tex, vertTexCoord.st + texTranslation).xyz, 1);
}

// Shaders written by Finn Wright