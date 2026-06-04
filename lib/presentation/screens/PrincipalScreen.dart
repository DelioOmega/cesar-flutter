import 'package:crud_mysql/presentation/screens/editar_screen.dart';
import 'package:flutter/material.dart';
 
import '../../core/services/usuario_service.dart';
import '../../data/model/usuario.dart';

class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  @override
  State<PrincipalScreen> createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  late Future<List<Usuario>> usuarios;

  @override
  void initState() {
    super.initState();
    usuarios = UsuarioService.getUsuarios();
  }

  void recargar() {
    setState(() {
      usuarios = UsuarioService.getUsuarios();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Usuarios")),
      body: FutureBuilder<List<Usuario>>(
        future: usuarios,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error"));
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, i) {
              final u = data[i];

              return ListTile(
                title: Text(u.nombres),
                subtitle: Text(u.correo),
                onTap: () {
                   Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditarScreen(user: u),
                          ));
                },
                onLongPress: () async {
                  await UsuarioService.eliminar(u.id);
                  recargar();
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/registro'),
        child: const Icon(Icons.add),
      ),
    );
  }
}