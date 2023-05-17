import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:google_fonts/google_fonts.dart';
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
  String receivedMessageserver = '';

  @override
  void dispose() {
    server?.close();
    client?.close();
    super.dispose();
  }

  void startClient() async {
    try {
      client = await Socket.connect('192.168.56.1', 4100);
      setState(() {
        clientStatus = 'Client status: Connected Host';
      });

      String message = messageController.text;
      client?.write(utf8.encode(message));

      client?.listen((Uint8List data) {
        String response = "OK, I got it";
        print('Received response from server: $response');
        setState(() {
          receivedMessageserver = response;
        });
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
      appBar: AppBar(title: Text('Client', style: GoogleFonts.prompt())),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(clientStatus, style: GoogleFonts.prompt()),
            ElevatedButton(
              onPressed: startClient,
              child: Text('Start Client', style: GoogleFonts.prompt()),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: messageController,
              decoration: InputDecoration(
                  labelText: 'Message', hintStyle: GoogleFonts.prompt()),
            ),
            ElevatedButton(
              onPressed: startClient,
              child:
                  Text('Send Message to Server', style: GoogleFonts.prompt()),
            ),
            const SizedBox(height: 20),
            Text('Received Message from server: $receivedMessageserver',
                style: GoogleFonts.prompt()),
          ],
        ),
      ),
    );
  }
}
