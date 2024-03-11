#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texBack;
uniform sampler2D texFront;
uniform sampler2D texLeft;
uniform sampler2D texRight;
uniform sampler2D texTop;
uniform sampler2D texBottom;

varying vec4 vertTexCoord;
varying vec4 fragPos;
varying vec3 fragNormal;
varying vec3 fragTangent;
varying vec3 fragBinormal;

void main() {
  vec3 viewDir = -(fragPos.xyz / fragPos.w);

  vec3 back = texture2D(texBack, vertTexCoord.st).xyz;
  vec3 front = texture2D(texFront, vertTexCoord.st).xyz;
  vec3 left = texture2D(texLeft, vertTexCoord.st).xyz;
  vec3 right = texture2D(texRight, vertTexCoord.st).xyz;
  vec3 top = texture2D(texTop, vertTexCoord.st).xyz;
  vec3 bottom = texture2D(texBottom, vertTexCoord.st).xyz;

  gl_FragColor = vec4(1,0,0, 1);
}

// Shaders written by Finn Wright