import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TCP Test App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
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

  void disConnect() async {
    client?.close();
  }

  void startServer() async {
    try {
      server = await ServerSocket.bind('localhost', 4100);
      print('Connection from'
          ' ${server?.address}:${server?.port}');
      setState(() {
        serverStatus = 'Server status: Server listening on'
            ' ${server?.address}:${server?.port}';
      });

      server?.listen((Socket socket) {
        socket.listen((Uint8List data) {
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

      client?.listen((Uint8List data) {
        String response = "OK from server";
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
      appBar: AppBar(title: const Text('Flutter App TCP Protocol')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(serverStatus),
            ElevatedButton(
              onPressed: startServer,
              child: const Text('Start Server'),
            ),
            const SizedBox(height: 20),
            Text(clientStatus),
            ElevatedButton(
              onPressed: startClient,
              child: const Text('Start Client'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: messageController,
              decoration: const InputDecoration(labelText: 'Message'),
            ),
            ElevatedButton(
              onPressed: startClient,
              child: const Text('Send Message to Server'),
            ),
            const SizedBox(height: 20),
            Text('Received Message from client: $receivedMessage'),
          ],
        ),
      ),
    );
  }
}
