import 'package:flutter/material.dart';
import 'package:dispensador/screens/mascota_registrer.dart';
import 'package:dispensador/screens/bluetooth_screen.dart'; // Asegúrate de que la ruta de importación sea correcta

void main() {
  runApp(MascotaApp());
}

class MascotaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mascota App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      routes: {
        '/mascotaRegister': (context) => MascotaRegistrer(),
        '/bluetooth': (context) => BluetoothScreen(), // Agrega esta línea
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> mascotas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Dispensador para Mascotas'),
      ),
      drawer: menuLateral(context),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondoMascotas.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: mascotas.length + 1,
          itemBuilder: (context, index) {
            if (index == mascotas.length) {
              // El último elemento es el botón para agregar una nueva mascota.
              return AddPetCard(
                onTap: () async {
                  final result = await Navigator.pushNamed(context, '/mascotaRegister');
                  if (result != null && result is Map<String, String>) {
                    setState(() {
                      mascotas.add(result);
                    });
                  }
                },
              );
            } else {
              // Los elementos anteriores son las tarjetas de mascotas existentes.
              final mascota = mascotas[index];
              return PetCard(
                petName: mascota['petName'] ?? '',
                petType: mascota['petType'] ?? '',
                petAge: mascota['petAge'] ?? '',
              );
            }
          },
        ),
      ),
    );
  }

  Widget menuLateral(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://th.bing.com/th/id/OIP.iskc3y_jG34WqD5_SVFBwwHaGw?rs=1&pid=ImgDetMain'),
            ),
            accountName: Text('Mi nombre'),
            accountEmail: Text('Mi cuenta'),
          ),
          ListTile(
            tileColor: Color.fromARGB(255, 64, 126, 196),
            title: Text('Mascotas'),
            subtitle: Text('Mis Mascotas'),
            leading: Icon(Icons.pets),
            trailing: Icon(Icons.chevron_right),
            onTap: () async {
              final result = await Navigator.pushNamed(context, '/mascotaRegister');
              if (result != null && result is Map<String, String>) {
                setState(() {
                  mascotas.add(result);
                });
              }
            },
          ),
          ListTile(
            tileColor: Color.fromARGB(255, 64, 126, 196),
            title: Text('Bluetooth'),
            subtitle: Text('Conexión a mis dispensadores'),
            leading: Icon(Icons.bluetooth),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/bluetooth'),
          ),
        ],
      ),
    );
  }
}

class PetCard extends StatelessWidget {
  final String petName;
  final String petType;
  final String petAge;

  const PetCard({
    required this.petName,
    required this.petType,
    required this.petAge,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.pets),
        title: Text('Nombre: $petName'),
        subtitle: Text('Tipo: $petType\nEdad: $petAge'),
      ),
    );
  }
}


class AddPetCard extends StatelessWidget {
  final VoidCallback onTap;

  const AddPetCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.add),
        title: Text('Agregar nueva mascota'),
        onTap: onTap,
      ),
    );
  }
}
