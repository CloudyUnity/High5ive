#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D tex;
uniform sampler2D normalMap;

varying vec4 vertTexCoord;
varying vec3 fragNormal;
varying vec3 fragTangent;
varying vec3 fragBinormal;

const vec3 lightDir = normalize(vec3(1, 0, 1));
const vec3 diffuseCol = vec3(1,1,1);

void main() {
  vec3 norm = texture2D(normalMap, vertTexCoord.st).xyz;
  norm = normalize(norm * 2.0 - 1.0);
  vec3 bump = (norm.x * fragNormal) + (norm.y * fragTangent) + (norm.z * fragBinormal);
  bump = normalize(bump);

  float diffuse = max(normalize(dot(bump, -lightDir)), 0);

  vec3 col = texture2D(tex, vertTexCoord.st).xyz + diffuse * diffuseCol;

  gl_FragColor = vec4(col, 1.0);
}