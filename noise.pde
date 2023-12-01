import java.util.List;
import java.util.Iterator;
import processing.net.Client;

float content_size, content_x, content_y;

String host = "192.168.27.6";
int port = 1234;
Client c;

List<Led> leds = new ArrayList<Led>();
int leds_per_side = 16;
int leds_total = leds_per_side * leds_per_side;

void setup() {
  background(0);
  fullScreen();

  if (width < height) {
    content_size = width * 0.98;
  } else {
    content_size = height * 0.98;
  }

  content_x = (width - content_size) / 2;
  content_y = (height - content_size) / 2;

  println("Connecting to " + host + ":" + port + "...");
  c = new Client(this, host, port);

  noLoop();
}

void printHelp() {
  float text_size = content_size / 30;
  float offset = height - content_size;

  if (text_size < 20) {
    text_size = 20;
  }

  pushMatrix();

  translate(offset, offset);
  textAlign(LEFT, TOP);
  textSize(text_size);

  fill(255, 255, 255);
  text("Connected to " + host + ":" + port, 0, 0);
  text("Press P to play/pause, Q to quit", 0, text_size);

  popMatrix();
}

void draw() {
  int dst_port, led_row, led_col;
  String line = "";

  background(0);

  if (!looping) {
    printHelp();
  }

  pushMatrix();

  translate(content_x, content_y);

  if (c.available() > 0) {
    line += c.readStringUntil(10);
    line = line.trim();

    if (line != null) {
      dst_port = Integer.parseInt(line);

      led_row = (dst_port / leds_total) % leds_per_side;
      led_col = (dst_port / leds_total) / leds_per_side;

      leds.add(new Led(led_row, led_col));
    }
  }

  Iterator<Led> it = leds.iterator();
  while (it.hasNext()) {

    Led l = it.next();

    if (l.ledAlpha >= 0) {
      l.blink();
    } else {
      it.remove();
    }
  }

  popMatrix();
}

void keyPressed() {
  if (key == 'q' || key == 'Q') {
    c.stop();
    println("Disconnected.");
    exit();
  } else if (key == 'p' || key == 'P') {

    if (looping) {
      popMatrix();
      printHelp();
      noLoop();
    } else {
      pushMatrix();
      c.clear();
      loop();
    }
  }
}
