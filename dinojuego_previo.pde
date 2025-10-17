String[] publi = {
  "📷 Foto personal en la playa",            
  "📍 Ubicación actual: Parque Central",     
  "📄 Documento oficial: Cédula de identidad",
  "🎮 Hobby: Jugando videojuegos",           
  "💳 Tarjeta de crédito (imagen)"           
};

boolean[] respcore = { true, false, false, true, false };
boolean[] elec;
int indi = 0;
boolean fin = false;
float pts = 0;

PImage dino,fondo,escudo,candado,robo;
PVector dinopos,dinovel,obstaculo;
float gravedad=0.6;
boolean entierra=true,pausa=false;
float alturatierra;
int contapau = 0,obsatatipo=1;
String mensaje = "",mensaje2 = "";
int tiempoMensaje = 0;
int duracionMensaje = 1000;
float velocidad = 5;
int contaobst=0;
boolean inijuego = false,fin2=false;

int fase = 1; // 1 = privacidad, 2 = dino
PFont fuente;

void setup() {
  size(800, 400);
  fuente = createFont("Segoe UI Emoji", 22);
  textFont(fuente);
  textAlign(CENTER, CENTER);
  textSize(22);
  fill(255);
  elec = new boolean[publi.length];
  iniciarDino();
}

void draw() {
  if (fase == 1) {
    dibupriva();
  } else if (fase == 2) {
    dibudino();
  }
}

void dibupriva() {
  background(30, 40, 70);
  if (!fin) {
    fill(255);
    text("Privacidad en redes sociales", width / 2, 50);
    textSize(20);
    text("Publicación " + (indi + 1) + " de " + publi.length, width / 2, 120);
    textSize(24);
    text(publi[indi], width / 2, 180);
    textSize(18);
    text("¿Deseas compartir esta publicación?", width / 2, 260);
    text("Presiona 'S' para Sí o 'N' para No", width / 2, 300);
  } else {
    verres();
  }
}

void keyPressed() {
  if (fase == 1) {
    if (!fin) {
      if (key == 's' || key == 'S') {
        elec[indi] = true;
        sig();
      } else if (key == 'n' || key == 'N') {
        elec[indi] = false;
        sig();
      }
    } else {
      if (pts == 100) {
        if (keyPressed) sigfase();
      } else if (key == 'r' || key == 'R') {
        rein();
      }
    }
  } 
  else if (fase == 2) {
    // controles del dinosaurio
    if (key == ' ' && inijuego && !fin && !fin2 && entierra) {
      dinovel.y = -20;
      entierra = false;
      return;
    }
    if (!inijuego && !fin && !fin2 && key == ' ') {
      inijuego = true;
      return;
    }
    if ((fin || fin2) && key == ' ') {
      reinijue();
      return;
    }
  }
}

void sig() {
  indi++;
  if (indi >= publi.length) {
    fin = true;
    calc();
  }
}

void calc() {
  int ok = 0;
  for (int i = 0; i < publi.length; i++) {
    if (elec[i] == respcore[i]) ok++;
  }
  pts = round((float)ok / publi.length * 100);
}

void verres() {
  background(20, 60, 40);
  fill(255);
  textSize(22);
  text("Resultados del control de privacidad", width / 2, 40);
  textSize(18);
  int y = 100;
  for (int i = 0; i < publi.length; i++) {
    boolean bien = (elec[i] == respcore[i]);
    String dectx = elec[i] ? "Compartir" : "No compartir";
    String emo = bien ? "✅" : "❌";
    if (bien) fill(100, 255, 100);
    else fill(255, 100, 100);
    text(publi[i] + " → " + dectx + " " + emo, width / 2, y);
    y += 40;
  }
  fill(255);
  textSize(20);
  text("Tu puntaje: " + nf(pts, 0, 0) + "%", width / 2, height - 100);
  textSize(16);
  if (pts == 100) {
    text("Has tomado todas las decisiones correctas.", width / 2, height - 70);
    text("Presiona cualquier tecla para pasar a la siguiente fase.", width / 2, height - 40);
  } else {
    text("Presiona 'R' para intentarlo de nuevo.", width / 2, height - 60);
  }
}

void rein() {
  indi = 0;
  fin = false;
  pts = 0;
  for (int i = 0; i < elec.length; i++) elec[i] = false;
}

void sigfase() {
  fase = 2;
  inijuego = false;
  fin = false;
  fin2 = false;
  contaobst = 0;
  velocidad = 5;
}

void iniciarDino() {
  fondo = loadImage("fondo.png");
  fondo.resize(width, height);
  frameRate(200);
  alturatierra = height - 100;
  dinopos = new PVector(10, alturatierra);
  dinovel = new PVector(0, 0);
  dino = loadImage("dino.png");
  escudo = loadImage("escudo.png");
  candado = loadImage("candado.png");
  robo = loadImage("robo.png");
  obstaculo = new PVector(width, alturatierra);
}

void dibudino() {
  background(220);
  if (!inijuego && !fin && !fin2) {
    image(fondo, 0, 0);
    fill(255);
    textSize(20);
    text("Para ganar elige las herramientas correctas para proteger tu privacidad", width/2, 70);
    text("Recolecta 12 herramientas", width/2, 100);
    textSize(15);
    text("Presiona ESPACIO para comenzar", width/2, height/2);
  } else if (inijuego && !fin && !fin2) {
    image(fondo, 0, 0);
    piso();
    actuobje();
    verobsta();
    actudino();
    mostrardino();
    if (choco()) {
      if (obsatatipo == 1 || obsatatipo == 5 || obsatatipo == 2) { 
        contaobst++;
        mensaje = "Buena elección";
        tiempoMensaje = millis();
        obstaculo.x = width;
        obsatatipo = int(random(1, 6));
      } else { 
        mensaje = "Perdiste";
        fin = true;
      }  
    }
    if (contaobst == 12) {
      mensaje2 = "¡Felicidades! lograste proteger tu privacidad";
      fin2 = true;
      inijuego = false;
    }
    if (mensaje != "" && mensaje2 == "") {
      fill(100,200,100);
      textSize(32); 
      text(mensaje, width/2, height/2);
    } else if (mensaje2 != "") {
      fill(100,200,100);
      textSize(32); 
      text(mensaje2, width/2, height/2);
    }
    if (millis() - tiempoMensaje > duracionMensaje) mensaje = "";
    velocidad += 0.001;
    fill(100,200,100);
    textSize(20);
    text("Herramientas recolectadas: " + contaobst, 200, 40);
    text("Recolecta 12 herramientas",650, 40);
  } else if (fin) {
    image(fondo, 0, 0);
    fill(200, 0, 0);
    textSize(50);
    text("Perdiste", width/2, 190);
    textSize(40);
    text("Recolectaste " + contaobst + " herramienta/s", width/2, 230);
    textSize(15);
    text("Presiona ESPACIO para reiniciar", width/2, height/2 + 60);
  } else if (fin2) {
    image(fondo, 0, 0);
    fill(255);
    textSize(30);
    text(mensaje2, width/2, height/2 - 40);
    textSize(15);
    text("Presiona ESPACIO para jugar de nuevo", width/2, height/2 + 40);
  }
}

void piso(){
  fill(100,200,100);
  rect(0,height-24,801,50); 
}

void actudino(){
  dinovel.y += gravedad;
  dinopos.y += dinovel.y;
  if (dinopos.y > alturatierra) {
    dinopos.y = alturatierra;
    dinovel.y = 0;
    entierra = true;
  }
}

void mostrardino(){
  image(dino, dinopos.x, dinopos.y, 80, 80);  
}

void actuobje() {
  if (!pausa) obstaculo.x -= velocidad;
  if (obstaculo.x < -100 && !pausa) {
    pausa = true;
    contapau = int(random(60, 180));
  }
  if (pausa) {
    contapau--;
    if (contapau <= 0) {
      pausa = false;
      obstaculo.x = width;
      obsatatipo = int(random(1, 6));
    }
  }
}

void verobsta() {
  if (obsatatipo == 1) image(escudo, obstaculo.x, obstaculo.y, 80, 80);
  else if (obsatatipo == 2) image(candado, obstaculo.x, obstaculo.y-200, 80, 80);
  else if (obsatatipo == 3) image(robo, obstaculo.x, obstaculo.y, 90, 90);
  else if (obsatatipo == 4) image(robo, obstaculo.x, obstaculo.y-90, 90, 90);
  else if (obsatatipo == 5) image(escudo, obstaculo.x, obstaculo.y-80, 80, 80);
}

boolean choco() {
  float dinoW = 80;
  float dinoH = 80;
  if (obsatatipo == 1) return colisionRect(dinopos.x, dinopos.y, dinoW, dinoH, obstaculo.x, obstaculo.y, 80, 80);
  else if (obsatatipo == 2) return colisionRect(dinopos.x, dinopos.y, dinoW, dinoH, obstaculo.x, obstaculo.y-200, 80, 80);
  else if (obsatatipo == 3) return colisionRect(dinopos.x, dinopos.y, dinoW, dinoH, obstaculo.x, obstaculo.y, 70, 70);
  else if (obsatatipo == 4) return colisionRect(dinopos.x, dinopos.y, dinoW, dinoH, obstaculo.x, obstaculo.y-90, 70, 70);
  else if (obsatatipo == 5) return colisionRect(dinopos.x, dinopos.y, dinoW, dinoH, obstaculo.x, obstaculo.y-80, 80, 80);
  return false;
}

boolean colisionRect(float x1, float y1, float w1, float h1,
                     float x2, float y2, float w2, float h2) {
  return x1 < x2 + w2 && x1 + w1 > x2 && y1 < y2 + h2 && y1 + h1 > y2;
}

void reinijue() {
  contaobst = 0;
  velocidad = 5;
  dinopos = new PVector(10, alturatierra);
  obstaculo = new PVector(width, alturatierra);
  mensaje = "";
  mensaje2 = "";
  fin = false;
  fin2 = false;
  inijuego = true;
}
