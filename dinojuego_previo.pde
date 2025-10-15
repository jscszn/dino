String[] publicaciones = {
  "📷 Foto personal en la playa",            // Compartir -> correcto
  "📍 Ubicación actual: Parque Central",     // No compartir -> correcto
  "📄 Documento oficial: Cédula de identidad", // No compartir -> correcto
  "🎮 Hobby: Jugando videojuegos",           // Compartir -> correcto
  "💳 Tarjeta de crédito (imagen)"           // No compartir -> correcto
};

// Verdadero si es correcto compartir, falso si no
boolean[] respuestasCorrectas = { true, false, false, true, false };
boolean[] decisiones;

int indice = 0;
boolean juegoTerminado = false;
float puntaje = 0;

void setup() {
  size(700, 400);
  textAlign(CENTER, CENTER);
  textSize(22);
  fill(255);
  decisiones = new boolean[publicaciones.length];
}

void draw() {
  background(30, 40, 70);

  if (!juegoTerminado) {
    fill(255);
    text("Privacidad en redes sociales", width / 2, 50);
    textSize(20);
    text("Publicación " + (indice + 1) + " de " + publicaciones.length, width / 2, 120);
    textSize(24);
    text(publicaciones[indice], width / 2, 180);
    textSize(18);
    text("¿Deseas compartir esta publicación?", width / 2, 260);
    text("Presiona 'S' para Sí o 'N' para No", width / 2, 300);
  } else {
    mostrarResultados();
  }
}

void keyPressed() {
  if (!juegoTerminado) {
    if (key == 's' || key == 'S') {
      decisiones[indice] = true;
      siguiente();
    } else if (key == 'n' || key == 'N') {
      decisiones[indice] = false;
      siguiente();
    }
  } else {
    if (puntaje == 100) {
      if (keyPressed) siguienteFase();  // cualquier tecla
    } else if (key == 'r' || key == 'R') {
      reiniciar();
    }
  }
}

void siguiente() {
  indice++;
  if (indice >= publicaciones.length) {
    juegoTerminado = true;
    calcularPuntaje();
  }
}

void calcularPuntaje() {
  int correctas = 0;
  for (int i = 0; i < publicaciones.length; i++) {
    if (decisiones[i] == respuestasCorrectas[i]) {
      correctas++;
    }
  }
  puntaje = round((float)correctas / publicaciones.length * 100);
}

void mostrarResultados() {
  background(20, 60, 40);
  fill(255);
  textSize(22);
  text("Resultados del control de privacidad", width / 2, 40);
  textSize(18);

  int y = 100;
  for (int i = 0; i < publicaciones.length; i++) {
    boolean esCorrecta = (decisiones[i] == respuestasCorrectas[i]);
    String decisionTexto = decisiones[i] ? "Compartido ✅" : "No compartido 🚫";
    if (esCorrecta) fill(100, 255, 100);
    else fill(255, 100, 100);
    text(publicaciones[i] + " → " + decisionTexto, width / 2, y);
    y += 40;
  }

  fill(255);
  textSize(20);
  text("Tu puntaje: " + nf(puntaje, 0, 0) + "%", width / 2, height - 100);
  textSize(16);

  if (puntaje == 100) {
    text("¡Excelente! Has tomado todas las decisiones correctas.", width / 2, height - 70);
    text("Presiona cualquier tecla para pasar a la siguiente fase.", width / 2, height - 40);
  } else {
    text("Presiona 'R' para intentarlo de nuevo.", width / 2, height - 60);
  }
}

void reiniciar() {
  indice = 0;
  juegoTerminado = false;
  puntaje = 0;
  for (int i = 0; i < decisiones.length; i++) {
    decisiones[i] = false;
  }
}

void siguienteFase() {
  background(0, 100, 60);
  fill(255);
  textSize(28);
  text("¡Felicidades! Has desbloqueado la siguiente fase.", width / 2, height / 2);
}
