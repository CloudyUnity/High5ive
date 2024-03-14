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
varying vec3 normMapNormal;

const vec3 diffuseCol = vec3(1,1,1);
const float specularShininess = 50;
const float normalStrength = 0.225f;

void main() {
  vec3 viewDir = -(fragPos.xyz / fragPos.w);
  float diffuse = dot(fragNormal, -lightDir) + 0.2f + permaDay;
  diffuse = clamp(diffuse, 0, 1);

  vec3 day = texture2D(texDay, vertTexCoord.st).xyz;
  vec3 night = texture2D(texNight, vertTexCoord.st).xyz;
  vec3 specular = texture2D(specularMap, vertTexCoord.st).xyz;
  vec3 norm = texture2D(normalMap, vertTexCoord.st).xyz * vec3(normalStrength, normalStrength, 1.0);
  norm = norm * 2.0 - 1.0;

  mat3 TBN = mat3(fragTangent, fragBinormal, normMapNormal);
  vec3 bump = normalize(TBN * norm);
  float bumpIntensity = max(0.15f, dot(bump, vec3(-0.5f, 0, 1))); // 0.15
  // float bumpIntensity = dot(bump, -lightDir) * 0.5f + 0.5f;
  bumpIntensity = sqrt(bumpIntensity);

  //gl_FragColor = vec4(bumpIntensity, bumpIntensity,bumpIntensity, 1);
  //return;

  float strength = max(specular.r, 0.001);  
  vec3 reflection = reflect(lightDir, fragNormal);
  float spec = pow(max(dot(viewDir, reflection), 0.0), specularShininess);

  vec3 col = day * diffuse + night * (1-diffuse);
  col *= bumpIntensity;
  col += vec3(1,1,1) * strength * spec * diffuse;

  gl_FragColor = vec4(col, 1);
}

// Shaders written by Finn Wright