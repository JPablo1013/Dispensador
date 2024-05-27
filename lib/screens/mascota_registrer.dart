import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class MascotaRegistrer extends StatefulWidget {
  const MascotaRegistrer({Key? key}) : super(key: key);

  @override
  _MascotaRegistrerState createState() => _MascotaRegistrerState();
}

class _MascotaRegistrerState extends State<MascotaRegistrer> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String _selectedPetType = '';
  String _selectedPetAge = '';
  String _feedingTime = '';
  String _petName = '';
  String _dispenserRuntime = '';

  @override
  void initState() {
    super.initState();

    // Inicializar las notificaciones locales
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Manejar la respuesta a la notificación aquí
    });
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Datos de la notificación',
    );
  }

  Future<void> _scheduleNotification(String title, String body, Duration duration) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(duration),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          channelDescription: 'your_channel_description',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  void calculateFeedingTime() {
    if (_selectedPetType.isNotEmpty && _selectedPetAge.isNotEmpty) {
      if (_selectedPetType == 'Perro') {
        if (_selectedPetAge == 'Cachorro') {
          _feedingTime = '10-15 minutos varias veces al día';
          _scheduleNotification('Hora de Alimentar', 'Es hora de alimentar a tu perro cachorro.', Duration(minutes: 15));
        } else if (_selectedPetAge == 'Joven') {
          _feedingTime = '20-30 minutos, dos o tres veces al día';
          _scheduleNotification('Hora de Alimentar', 'Es hora de alimentar a tu perro joven.', Duration(hours: 8));
        } else if (_selectedPetAge == 'Adulto') {
          _feedingTime = '30-45 minutos, dos veces al día';
          _scheduleNotification('Hora de Alimentar', 'Es hora de alimentar a tu perro adulto.', Duration(hours: 12));
        }
      } else if (_selectedPetType == 'Gato') {
        if (_selectedPetAge == 'Cachorro') {
          _feedingTime = '10-15 minutos varias veces al día';
          _scheduleNotification('Hora de Alimentar', 'Es hora de alimentar a tu gato cachorro.', Duration(minutes: 15));
        } else if (_selectedPetAge == 'Joven') {
          _feedingTime = '20-30 minutos, dos o tres veces al día';
          _scheduleNotification('Hora de Alimentar', 'Es hora de alimentar a tu gato joven.', Duration(hours: 8));
        } else if (_selectedPetAge == 'Adulto') {
          _feedingTime = '30-45 minutos, dos veces al día';
          _scheduleNotification('Hora de Alimentar', 'Es hora de alimentar a tu gato adulto.', Duration(hours: 12));
        }
      }
    } else {
      _feedingTime = '';
    }
  }

  void savePetInfo(BuildContext context) {
    Navigator.pop(context, {
      'petName': _petName,
      'petType': _selectedPetType,
      'petAge': _selectedPetAge,
      'feedingTime': _feedingTime,
    });

    _showNotification('Información Guardada', 'La información de tu mascota ha sido guardada.');
  }

  void runExampleTimer() {
    setState(() {
      _dispenserRuntime = '15 segundos';
    });

    Future.delayed(Duration(seconds: 15), () {
      setState(() {
        _dispenserRuntime = '';
      });
      _showNotification('Ejemplo de Notificación', 'Esta es una notificación de ejemplo después de 15 segundos.');
    });

    _scheduleNotification('Ejemplo de Notificación', 'Esta es una notificación programada después de 15 segundos.', Duration(seconds: 15));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Mascotas'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondoMascota2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedPetType = 'Perro';
                    calculateFeedingTime();
                  });
                },
                style: _selectedPetType == 'Perro'
                    ? ElevatedButton.styleFrom(backgroundColor: Colors.green)
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.pets),
                    SizedBox(width: 8.0),
                    Text('Perro'),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedPetType = 'Gato';
                    calculateFeedingTime();
                  });
                },
                style: _selectedPetType == 'Gato'
                    ? ElevatedButton.styleFrom(backgroundColor: Colors.green)
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.pets),
                    SizedBox(width: 8.0),
                    Text('Gato'),
                  ],
                ),
              ),
              SizedBox(height: 32.0),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _petName = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Nombre de la mascota',
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedPetAge = 'Cachorro';
                        calculateFeedingTime();
                      });
                    },
                    style: _selectedPetAge == 'Cachorro'
                        ? ElevatedButton.styleFrom(backgroundColor: Colors.green)
                        : null,
                    child: Text('Cachorro'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedPetAge = 'Joven';
                        calculateFeedingTime();
                      });
                    },
                    style: _selectedPetAge == 'Joven'
                        ? ElevatedButton.styleFrom(backgroundColor: Colors.green)
                        : null,
                    child: Text('Joven'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedPetAge = 'Adulto';
                        calculateFeedingTime();
                      });
                    },
                    style: _selectedPetAge == 'Adulto'
                        ? ElevatedButton.styleFrom(backgroundColor: Colors.green)
                        : null,
                    child: Text('Adulto'),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  savePetInfo(context);
                },
                child: Text('Guardar'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  runExampleTimer();
                },
                child: Text('Ejemplo'),
              ),
              SizedBox(height: 16.0),
              Text(
                'Tiempo de funcionamiento del dispensador: $_dispenserRuntime',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
