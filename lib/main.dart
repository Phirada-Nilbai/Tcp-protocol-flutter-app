import 'dart:io';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ServerApp());
}

class ServerApp extends StatelessWidget {
  const ServerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TCP Test App',
      home: ServerPage(),
    );
  }
}

class ServerPage extends StatefulWidget {
  const ServerPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ServerPageState createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage> {
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
      server = await ServerSocket.bind('0.0.0.0', 4100);
      /*  print('Connection from'
          ' ${server?.address}:${server?.port}'); */
      setState(() {
        serverStatus = 'Server status: Server listening on'
            ' ${server?.address}:${server?.port}';
      });

      server?.listen((Socket socket) {
        socket.listen((data) {
          var message = String.fromCharCodes(data);
          /* print('Received message from client: $message'); */
          setState(() {
            receivedMessage = message;
          });

          // Process the received message
          String response = 'Server response';
          socket.write((response));
        });
      });
    } catch (e) {
      /* print('Failed to start server: $e'); */
      setState(() {
        serverStatus = 'Server status: Failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Server', style: GoogleFonts.prompt())),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(serverStatus, style: GoogleFonts.prompt()),
            ElevatedButton(
              onPressed: startServer,
              child: Text('Start Server', style: GoogleFonts.prompt()),
            ),
            const SizedBox(height: 20),
            Text('Received Message from client: $receivedMessage',
                style: GoogleFonts.prompt()),
          ],
        ),
      ),
    );
  }
}
