//! VERTEX

void main_vs_godrays() {
  gl_Position = vec4(position.xy, 0.0, 1.0);
  v_tex_coords = (vec2(1.0, 1.0) + position.xy) / 2.0;
}

//! FRAGMENT
#define NUM_SAMPLES 50
#define Density 1.
#define Weight 1.
#define Decay 0.8

//float random(float t) {
//  return fract(sin(t * sin(t) * 423.0 + sin(t * 1000. * 12.))*cos(t)*cos(exp(t)));
//}

float random(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}


void main_fs_godrays() {


  
  vec2 ScreenLightPos = vec2(0.5,0.5);
  
  vec2 position = gl_FragCoord.xy/ resolution;
  
  // Calculate vector from pixel to light source in screen space.  
   vec2 deltaTexCoord = (position - ScreenLightPos.xy);  
  // Divide by number of samples and scale by control factor.  
  deltaTexCoord *= 1.0 / float(NUM_SAMPLES) * Density  * (1.- random( position) / 3.);  
  // Store initial sample.  
  vec3 color = texture2D(texture_0, position).rgb;  
 // Set up illumination decay factor.  
  float illuminationDecay = 1.0;  
 // Evaluate summation from Equation 3 NUM_SAMPLES iterations.  
  for (int i = 0; i < NUM_SAMPLES; i++)  
 {  
   // Step sample location along ray.  
   position -= deltaTexCoord;  
   // Retrieve sample at new location.  
  vec3 sample = texture2D(texture_0, position).rgb;  
   // Apply sample attenuation scale/decay factors.  
   sample *= illuminationDecay * Weight;  
   // Accumulate combined color.  
   color += sample;  
   // Update exponential decay factor.  
   illuminationDecay *= Decay * (1.- random( position) / 6.);  
 }  
 // Output final color with a further scale control factor.  
   gl_FragColor = vec4(color, 1.0);
   

  
}