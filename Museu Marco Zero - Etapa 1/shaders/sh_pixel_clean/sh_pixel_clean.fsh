varying vec2 v_vTexcoord;
varying vec4 v_vColour;
void main() {
    vec4 texel = texture2D(gm_BaseTexture, v_vTexcoord);
    // Chroma key restrito ao verde puro do fundo dos sprites fornecidos.
    if (texel.g > 0.95 && texel.r < 0.05 && texel.b < 0.05) discard;
    gl_FragColor = v_vColour * texel;
}
