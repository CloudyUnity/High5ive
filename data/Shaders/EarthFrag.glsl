#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texDay;
uniform sampler2D texNight;
uniform sampler2D normalMap;
uniform sampler2D specularMap;
uniform vec3 lightDir;

varying vec4 vertTexCoord;
varying vec4 fragPos;
varying vec3 fragNormal;
varying vec3 fragTangent;
varying vec3 fragBinormal;

const vec3 diffuseCol = vec3(1,1,1);
const float specularShininess = 10.0;

void main() {
  float diffuse = dot(fragNormal, -lightDir);
  diffuse = max(diffuse, 0);

  vec3 day = texture2D(texDay, vertTexCoord.st).xyz;
  vec3 night = texture2D(texNight, vertTexCoord.st).xyz;
  vec3 specular = texture2D(specularMap, vertTexCoord.st).xyz;

  float strength = max(specular.r, 0.05);
  vec3 viewDir = -(fragPos.xyz / fragPos.w);
  vec3 reflection = reflect(lightDir, fragNormal);
  float spec = pow(max(dot(viewDir, reflection), 0.0), specularShininess);

  vec3 col = day * diffuse + night * (1-diffuse);
  col += vec3(1,1,1) * strength * spec * diffuse;

  gl_FragColor = vec4(col, 1);
}

// Shaders written by Finn Wright