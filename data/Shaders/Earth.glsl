#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

void mainImage( out vec4 fragColor, in vec2 fragCoord );

void main() {
    mainImage(gl_FragColor,gl_FragCoord.xy);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    fragColor = vec4(1.0, 0.0, 0.0, 1.0);
    return;
    
    vec3 col = texture2D(texture, fragCoord).rgb;

    fragColor = vec4(col, 1.0);    
}
