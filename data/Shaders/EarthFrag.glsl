#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texDay;
uniform sampler2D texNight;
uniform sampler2D normalMap;
uniform vec3 lightDir;

varying vec4 vertTexCoord;
varying vec3 fragNormal;
varying vec3 fragTangent;
varying vec3 fragBinormal;

const vec3 diffuseCol = vec3(1,1,1);

void main() {
  vec3 norm = texture2D(normalMap, vertTexCoord.st).xyz;
  norm = normalize(norm * 2.0 - 1.0);
  vec3 bump = (norm.x * fragNormal) + (norm.y * fragTangent) + (norm.z * fragBinormal);
  bump = normalize(bump);

  float diffuse = clamp(dot(fragNormal, -lightDir), 0, 1);

  vec3 day = texture2D(texDay, vertTexCoord.st).xyz;
  vec3 night = texture2D(texNight, vertTexCoord.st).xyz;
  vec3 col = day * diffuse + night * (1-diffuse);

  gl_FragColor = vec4(col, 1.0);
}