import 'package:flutter/material.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Flutter Demo TCP protocol'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Instantiating the class with the Ip and the PortNumber
  //change to server Ip and Portnumber
  TcpSocketConnection socketConnection =
      TcpSocketConnection("192.168.200.194", 135);

  String message = "";

  @override
  void initState() {
    super.initState();
    startConnection();
  }

  //receiving and sending back a custom message
  void messageReceived(String msg) {
    setState(() {
      message = msg;
    });
    socketConnection.sendMessage("MessageIsReceived :D ");
  }

  //starting the connection and listening to the socket asynchronously
  void startConnection() async {
    socketConnection.enableConsolePrint(
        true); //use this to see in the console what's happening
    if (await socketConnection.canConnect(5000, attempts: 3)) {
      await socketConnection.connect(5000, messageReceived, attempts: 3);
    } else {
      print("Failed to connect to server");
    }
  }

  // send message to server
  void sendMessage() {
    socketConnection.sendMessage("Hello, world!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have received $message',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendMessage,
              child: const Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}
