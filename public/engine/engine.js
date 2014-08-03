var scenes = [];
var start_time = 0;
var snd;

function engine_render(current_time)
{
  var start_time = 0;
  for (var i = 0; i < scenes.length; i++) {
    var scene = scenes[i]
    var scene_time = current_time - start_time;
    if ((scene_time >= 0) && (scene_time < scene.duration)) {
      render_scene(scene, current_time, scene_time);
      break;
    }

    start_time += scene.duration;
  }
}

function main_loop() {
  var current_time = snd.t();
  engine_render(current_time);
  requestAnimationFrame(main_loop);
}

function main() {
  var body = document.body
  body.innerHTML = "";
  canvas = document.createElement("canvas");
  body.appendChild(canvas);
  body.style.margin = 0;

  canvas.width = innerWidth;
  canvas.height = innerHeight;

  gl_init();
  demo_init();
  gfx_init();

  render_scene(scenes[0], 0, 0);

  snd = new SND(SONG);
  // If you want to shut the music up comment this out and also comment
  // out the equivalent line in engine-driver.js:~100
  snd.p();

  main_loop();
}

function editor_main() {
  canvas = document.getElementById("engine-view")
  gl_init();
  canvas_map = document.getElementById("map-view")
  map_ctx = canvas_map.getContext("2d");
  map_ctx.fillStyle = "rgb(220, 220, 220)";
  map_ctx.fillRect(0, 0, 640, 360);

  canvas_map.onmousemove = function(e) {
    uniforms["cam_pos"][0] = e.layerX - 150;
    uniforms["cam_pos"][1] = e.layerY - 150 - canvas_map.offsetTop;
  }
}
