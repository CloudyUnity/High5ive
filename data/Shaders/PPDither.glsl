#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform sampler2D noise;
uniform vec2 resolution;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
  	vec2 uv = gl_FragCoord.xy / resolution.xy;
	
	vec3 sourcePixel = texture2D(texture, uv).rgb;
	float grayscale = length(sourcePixel*vec3(0.2126,0.7152,0.0722));

	vec2 noiseCoord = mod(gl_FragCoord.xy/vec2(8.0,8.0), 1.0);
	vec3 ditherPixel = texture2D(noise, noiseCoord).xyz;
	float ditherGrayscale = (ditherPixel.x + ditherPixel.y + ditherPixel.z) / 3.0;
	ditherGrayscale -= 0.5;

	float ditheredResult = grayscale + ditherGrayscale;

	float bit = round(ditheredResult);
	gl_FragColor = vec4(bit,bit,bit,1);
} 

// Original dithering shader by RavenWorks
// https://www.shadertoy.com/view/Xs23zW
// Adapted for Processing by Raphael de Courville <@sableRaph>
// Further adapted by Finn Wright