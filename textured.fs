precision lowp float;
uniform float time;
uniform float duration;
uniform float beat;
uniform vec2  resolution;
uniform sampler2D texture_0;
varying vec2 v_texCoord;

void main() {
  gl_FragColor = texture2D(texture_0, v_texCoord);
}
