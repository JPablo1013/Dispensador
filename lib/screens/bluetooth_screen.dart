import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(BluetoothApp());

class BluetoothApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bluetooth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BluetoothPage(),
    );
  }
}

class BluetoothPage extends StatefulWidget {
  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _device;
  BluetoothDevice? _connectedDevice;
  bool _isConnecting = false;
  BluetoothConnection? _connection;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _bluetooth.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _bluetooth.onStateChanged().listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _bluetooth.getBondedDevices().then((List<BluetoothDevice> devices) {
      setState(() {
        _devicesList = devices;
      });
    });

    if (_bluetoothState.isEnabled) {
      _startDiscovery();
    }
  }

  Future<void> _requestPermissions() async {
  if (await Permission.bluetooth.isDenied) {
    await Permission.bluetooth.request();
  }
  if (await Permission.bluetoothScan.isDenied) {
    await Permission.bluetoothScan.request();
  }
  if (await Permission.bluetoothConnect.isDenied) {
    await Permission.bluetoothConnect.request();
  }
  if (await Permission.location.isDenied) {
    await Permission.location.request();
  }
}


  void _startDiscovery() {
    if (_bluetoothState.isEnabled) {
      _bluetooth.startDiscovery().listen((BluetoothDiscoveryResult result) {
        setState(() {
          if (!_devicesList.contains(result.device)) {
            _devicesList.add(result.device);
          }
        });
      });
    } else {
      print('Bluetooth is not enabled');
    }
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        value: null,
        child: Text('NONE'),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          value: device,
          child: Text(device.name ?? 'Unknown Device'),
        ));
      });
    }
    return items;
  }

  void _connect() async {
  if (_device == null) {
    print('No device selected');
    return;
  }

  if (!_bluetoothState.isEnabled) {
    print('Bluetooth is not enabled');
    return;
  }

  setState(() {
    _isConnecting = true;
  });

  try {
    BluetoothConnection connection =
        await BluetoothConnection.toAddress(_device!.address).timeout(Duration(seconds: 10));
    setState(() {
      _connectedDevice = _device;
      _isConnecting = false;
      _connection = connection;
    });
    print('Connected to the device');
    _connection!.input!.listen((data) {
      // Listener para recibir datos
    }).onDone(() {
      print('Disconnected by remote request');
      _disconnect();
    });
  } catch (e) {
    print('Cannot connect, exception occurred: ${e.toString()}');
    setState(() {
      _isConnecting = false;
      _connectedDevice = null;
    });
    Future.delayed(Duration(seconds: 5), () {
      _connect();
    });
  }
}


  void _disconnect() async {
    if (_connection != null) {
      await _connection!.close();
      setState(() {
        _connectedDevice = null;
        _isConnecting = false;
        _connection = null; // Establecer la conexión como nula después de cerrarla
      });
      print('Disconnected from the device');
    } else {
      print('No active connection to disconnect');
    }
  }

  // Widget para mostrar el dispositivo conectado actualmente
  Widget _buildConnectedDeviceWidget() {
    final connectedDevice = _getConnectedDevice();
    return connectedDevice != null
        ? ListTile(
            title: Text('Connected Device: ${connectedDevice.name ?? connectedDevice.address}'),
            trailing: IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                // Puedes agregar acciones adicionales aquí, como mostrar detalles adicionales sobre el dispositivo.
              },
            ),
          )
        : SizedBox.shrink(); // Devuelve un widget vacío si no hay dispositivo conectado
  }

  // Método para obtener el dispositivo conectado actualmente
  BluetoothDevice? _getConnectedDevice() {
    return _connectedDevice;
  }

  @override
  Widget build(BuildContext context) {
    print('Connected Device: ${_connectedDevice?.name ?? _connectedDevice?.address}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Bluetooth Demo'),
      ),
      body: Column(
        children: <Widget>[
          _buildConnectedDeviceWidget(),
          SwitchListTile(
            title: Text('Enable Bluetooth'),
            value: _bluetoothState.isEnabled,
            onChanged: (bool value) {
              future() async {
                if (value) {
                  await _bluetooth.requestEnable();
                  _startDiscovery();
                } else {
                  await _bluetooth.requestDisable();
                }
              }

              future().then((_) {
                setState(() {});
              });
            },
          ),
          DropdownButton<BluetoothDevice>(
            items: _getDeviceItems(),
            onChanged: (value) => setState(() => _device = value),
            value: _device ?? _getConnectedDevice(), // Aquí se utiliza el nuevo método
          ),
          ElevatedButton(
            onPressed: _isConnecting
                ? null
                : _connectedDevice != null
                    ? _disconnect
                    : _connect,
            child: Text(_connectedDevice != null
                ? 'Disconnect'
                : (_isConnecting ? 'Connecting...' : 'Connect')),
          ),
          if (_connectedDevice != null)
            Text('Connected to ${_connectedDevice!.name ?? _connectedDevice!.address}'),
        ],
      ),
    );
  }
}
