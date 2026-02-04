#version 320 es
precision mediump float;

in vec2 v_texcoord;
uniform sampler2D tex;

out vec4 fragColor;

void main() {
    vec4 color = texture(tex, v_texcoord);
    float brightness = 0.75;
    color.rgb *= brightness;
    fragColor = color;
}

