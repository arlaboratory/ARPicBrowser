varying lowp vec4 DestinationColor;
 
varying lowp vec2 TexCoordOut;
uniform sampler2D Texture;
uniform int Selection;

void main(void) {
    if (Selection == 0) {
        gl_FragColor = texture2D(Texture, TexCoordOut)*DestinationColor[3];
    } else{
        gl_FragColor = DestinationColor;
    }
}
