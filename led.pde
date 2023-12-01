class Led {
  float ledRow, ledCol, ledAlpha, ledSize;
  boolean ledAlphaIncrease;

  Led (int row, int col) {
    ledRow = row;
    ledCol = col;
    ledAlpha = 0;
    ledSize = content_size / leds_per_side;
    ledAlphaIncrease = true;
    noStroke();
  }

  void blink() {
    fill(255, 255, 102, ledAlpha);

    if (ledAlphaIncrease == true) {
      ledAlpha += 50;
    } else {
      ledAlpha -= 5;
    }

    if (ledAlpha > 255) {
      ledAlphaIncrease = false;
    }

    rect(ledRow * ledSize + ledSize * 0.1,
         ledCol * ledSize + ledSize * 0.1,
         ledSize * 0.8,
         ledSize * 0.8,
         ledSize * 0.8);
  }
}
