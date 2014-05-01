#extension GL_EXT_draw_buffers : require
precision highp float;
uniform sampler2D texture_0;
varying vec2 v_tex_coords;
varying vec3 v_position;
varying vec3 v_normals;

// TODO the hard-coded far plane is a bit lame
#define FAR_DIST 50.0

void main() {
  float depth = v_position.z / FAR_DIST;
  gl_FragData[0] = vec4(texture2D(texture_0, v_tex_coords).rgb, floor(depth * 255.0) / 255.0);
  //gl_FragData[0] = vec4(v_tex_coords, 0.0, 1.0);
  gl_FragData[1] = vec4(0.5*v_normals+vec3(0.5,0.5,0.5), fract(depth * 255.0));
}