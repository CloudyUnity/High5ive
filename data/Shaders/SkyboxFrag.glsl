#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D tex;
varying vec4 fragPos;
varying vec3 texPos;

const float PI = 3.14159265358979323846f;

void main() {  
  vec3 sphericalCoords = normalize(texPos.xyz);
  // gl_FragColor = vec4(texPos.xyz, 1);
  // return;

  vec2 texCoords;
  texCoords.x = 0.5 + atan(sphericalCoords.z, sphericalCoords.x) / (2.0 * PI);
  texCoords.y = 0.5 - asin(sphericalCoords.y) / PI;

  vec3 col = texture2D(tex, texCoords.xy).xyz;
  gl_FragColor = vec4(col, 1);
}

// Shaders written by Finn Wright