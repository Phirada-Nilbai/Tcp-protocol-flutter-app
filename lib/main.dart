import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TCP Test App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ServerSocket? server;
  Socket? client;
  TextEditingController messageController = TextEditingController();
  String serverStatus = 'Server status: Not started';
  String clientStatus = 'Client status: Not connected';
  String receivedMessage = '';

  @override
  void dispose() {
    server?.close();
    client?.close();
    super.dispose();
  }

  void startServer() async {
    try {
      server = await ServerSocket.bind('localhost', 4100);
      print('listening on ${server} and ');
      setState(() {
        serverStatus = 'Server status: Running';
      });

      server?.listen((Socket socket) {
        socket.listen((List<int> data) {
          String message = utf8.decode(data);
          print('Received message from client: $message');
          setState(() {
            receivedMessage = message;
          });

          // Process the received message

          String response = 'Server response';
          socket.write(utf8.encode(response));
        });
      });
    } catch (e) {
      print('Failed to start server: $e');
      setState(() {
        serverStatus = 'Server status: Failed';
      });
    }
  }

  void startClient() async {
    try {
      client = await Socket.connect('localhost', 4100);
      setState(() {
        clientStatus = 'Client status: Connected Host';
      });

      String message = messageController.text;
      client?.write(utf8.encode(message));

      client?.listen((List<int> data) {
        String response = "This is server everyone";
        print('Received response from server: $response');
      });
    } catch (e) {
      print('Failed to connect client: $e');
      setState(() {
        clientStatus = 'Client status: Failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter App TCP Protocol')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(serverStatus),
            ElevatedButton(
              child: Text('Start Server'),
              onPressed: startServer,
            ),
            SizedBox(height: 20),
            Text(clientStatus),
            ElevatedButton(
              child: Text('Start Client'),
              onPressed: startClient,
            ),
            SizedBox(height: 20),
            TextField(
              controller: messageController,
              decoration: InputDecoration(labelText: 'Message'),
            ),
            ElevatedButton(
              child: Text('Send Message'),
              onPressed: startClient,
            ),
            SizedBox(height: 20),
            Text('Received Message: $receivedMessage'),
          ],
        ),
      ),
    );
  }
}
