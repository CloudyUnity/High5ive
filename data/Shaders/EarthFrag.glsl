#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texDay;
uniform sampler2D texNight;
uniform sampler2D normalMap;
uniform sampler2D specularMap;

uniform vec3 lightDir;
uniform vec2 mousePos;
uniform float permaDay;

varying vec4 vertTexCoord;
varying vec4 fragPos;
varying vec3 fragNormal;
varying vec3 fragTangent;
varying vec3 fragBinormal;

const vec3 diffuseCol = vec3(1,1,1);
const float specularShininess = 50;
const float normalStrength = 0.225f;

void main() {
  float diffuse = dot(fragNormal, -lightDir) + 0.2f + permaDay;
  diffuse = clamp(diffuse, 0, 1);

  vec3 day = texture2D(texDay, vertTexCoord.st).xyz;
  vec3 night = texture2D(texNight, vertTexCoord.st).xyz;
  vec3 specular = texture2D(specularMap, vertTexCoord.st).xyz;
  vec3 norm = texture2D(normalMap, vertTexCoord.st).xyz * vec3(normalStrength, normalStrength, 1.0);
  norm = norm * 2.0 - 1.0;

  vec3 bump = (norm.x * fragTangent) + (norm.y * fragBinormal) + (norm.z * fragNormal);
  bump = normalize(bump);
  float bumpIntensity = max(dot(bump, -lightDir), 0) * 0.8f + (0.2f);
  // gl_FragColor = vec4(bumpIntensity, 0, 0, 1);
  // return;

  float strength = max(specular.r, 0.001);
  vec3 viewDir = -(fragPos.xyz / fragPos.w);
  vec3 reflection = reflect(lightDir, fragNormal);
  float spec = pow(max(dot(viewDir, reflection), 0.0), specularShininess);

  vec3 col = day * diffuse + night * (1-diffuse);
  if (false && diffuse > 0.0f && bumpIntensity > 0.2f) // DISABLED
    col *= bumpIntensity;

  col += vec3(1,1,1) * strength * spec * diffuse;

  gl_FragColor = vec4(col, 1);
}

// Shaders written by Finn Wright