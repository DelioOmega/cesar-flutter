import 'package:flutter/material.dart';

// Punto de entrada de la aplicación
void main() {
  runApp(const MyApp());
}

// Widget raíz de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // Color principal de la app
        primarySwatch: Colors.blue,
      ),
      // Pantalla inicial
      home: Tendencias(),
    );
  }
}

// Pantalla simple de bienvenida
class Pantalla1 extends StatelessWidget {
  const Pantalla1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bienvenido")),
      body: Text("Adso"),
    );
  }
}

// Ejemplo de uso del widget Text con estilos
class WText extends StatelessWidget {
  const WText({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ej Text")),
      body: const Text(
        "ADSO",
        // Texto grande y rojo
        style: TextStyle(fontSize: 50, color: Colors.red),
      ),
    );
  }
}

// Ejemplo de uso del widget Container con decoración
class Contenedor extends StatelessWidget {
  const Contenedor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ej Contenedor")),
      body: Container(
        margin: const EdgeInsets.all(10),   // Espacio exterior
        padding: const EdgeInsets.all(10),  // Espacio interior
        width: 200,
        height: 200,
        decoration: const BoxDecoration(
          color: Colors.red,
          // Bordes redondeados
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: const Text("SENA"),
      ),
    );
  }
}

// Ejemplo de uso de Column con alineación
class Columnas extends StatelessWidget {
  const Columnas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ej Columnas")),
      body: Container(
        // Ocupa el ancho completo y la mitad del alto de la pantalla
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,
        color: Colors.red,
        child: Column(
          // Distribuye los hijos con espacio uniforme entre ellos
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text("Hola 1", style: TextStyle(fontSize: 30)),
            Text("Hola 2", style: TextStyle(fontSize: 30)),
            Text("Hola 3", style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
    );
  }
}

// Lista horizontal de tarjetas de lenguajes de programación
class Lenguajes extends StatelessWidget {
  const Lenguajes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ej Contenedor")),
      body: SizedBox(
        height: 150,
        child: ListView(
          // Desplazamiento horizontal
          scrollDirection: Axis.horizontal,
          children: [
            tarjeta(Colors.red, "Java"),
            tarjeta(Colors.greenAccent, "c++"),
            tarjeta(Colors.pink.shade100, "Pseint"),
          ],
        ),
      ),
    );
  }

  // Método que construye una tarjeta con color y texto personalizados
  Widget tarjeta(Color c, String texto) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(10),
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: c,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(texto, style: TextStyle(fontSize: 25)),
          Text("30 post", style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}

// Pantalla principal con lista vertical de tarjetas de tendencias
class Tendencias extends StatelessWidget {
  const Tendencias({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tendencias")),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          // Cada tarjeta recibe autor, texto, likes y vistas
          tarTendencias(context, "Jair Doria",
              "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod"
              "tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,",
              "80 Likes", "30 Views"),

          tarTendencias(context, "Santiago Olayo",
              "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod"
              "tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,"
              "quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo"
              "consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse"
              "cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non"
              "proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
              "20 Likes", "10 Views"),

          tarTendencias(context, "Santiago Rosales", "", "180 Likes", "30 Views"),
          tarTendencias(context, "Santiago Rosales", "", "180 Likes", "30 Views"),
          tarTendencias(context, "Santiago Rosales", "", "180 Likes", "30 Views"),
          tarTendencias(context, "Santiago Rosales", "", "180 Likes", "30 Views"),
          tarTendencias(context, "Santiago Rosales", "", "180 Likes", "30 Views"),
        ],
      ),
    );
  }

  // Método que construye una tarjeta de tendencia individual
  Widget tarTendencias(BuildContext context, String autor, String txt,
      String likes, String view) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          // Fila superior: avatar + nombre y hora
          Row(
            children: [
              // Imagen del avatar desde assets
              Image.asset("assets/imagen/avatar.png", width: 60),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(autor, style: TextStyle(fontSize: 22)),
                  const Text("Hace 1 hora", style: TextStyle(fontSize: 18)),
                ],
              ),
            ],
          ),

          // Texto del contenido de la tendencia
          Text(txt),

          // Fila inferior: likes y vistas separados a los extremos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Ícono de like + contador
              Row(
                children: [
                  Icon(Icons.thumb_up_alt),
                  Text(likes),
                ],
              ),
              // Ícono de vistas + contador
              Row(
                children: [
                  Icon(Icons.remove_red_eye),
                  Text(view),
                ],
              ),
            ],
          ),

        ],
      ),
    );
  }
}