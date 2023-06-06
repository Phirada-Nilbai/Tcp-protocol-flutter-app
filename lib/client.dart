import 'dart:io';
<<<<<<< HEAD
=======

>>>>>>> 40dcc06aa271e3f2e1a7cc4d893bdf3d7a5a6eb0

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ClientApp());
}

class ClientApp extends StatelessWidget {
  const ClientApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TCP Test App for client',
      home: ClientPage(),
    );
  }
}

class ClientPage extends StatefulWidget {
  const ClientPage({Key? key}) : super(key: key);

  @override
<<<<<<< HEAD
// ignore: library_private_types_in_public_api
=======
  // ignore: library_private_types_in_public_api
>>>>>>> 40dcc06aa271e3f2e1a7cc4d893bdf3d7a5a6eb0
  _ClientPageState createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  Socket? client;
  TextEditingController messageController = TextEditingController();
  String clientStatus = 'Client status: Not connected';
  String receivedMessage = '';

  @override
  void dispose() {
    client?.close();
    super.dispose();
  }

  void startClient() async {
    try {
      client = await Socket.connect('172.20.10.10', 4100);
      setState(() {
        clientStatus = 'Client status: Connected';
      });

      String message = messageController.text;
      client?.write((message));

      client?.listen((data) {
        var response = String.fromCharCodes(data);
<<<<<<< HEAD
// print('Received response from server: $response');
=======
       // print('Received response from server: $response');
>>>>>>> 40dcc06aa271e3f2e1a7cc4d893bdf3d7a5a6eb0
        setState(() {
          receivedMessage = response;
        });
      });
    } catch (e) {
<<<<<<< HEAD
//print('Failed to connect client: $e');
      setState(() {
        clientStatus = 'Client status: Failed';
      });
    }
=======
        print('Failed to connect client: $e');
        setState(() {
          clientStatus = 'Client status: Failed';
        });
    } 
    } 
  
  void disconnectClient() {
    client?.destroy();
    setState(() {
      clientStatus = 'Client status: Disconnected';
    });
>>>>>>> 40dcc06aa271e3f2e1a7cc4d893bdf3d7a5a6eb0
  }

  void disconnectClient() {
    client?.destroy();
    setState(() {
      clientStatus = 'Client status: Disconnected';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Client' , style: GoogleFonts.prompt())),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(clientStatus/*, style: GoogleFonts.prompt()*/),
            ElevatedButton(
              onPressed: startClient,
              child: Text('Connect to server', style: GoogleFonts.prompt()),
<<<<<<< HEAD
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: disconnectClient,
              child: Text('Disconnect', style: GoogleFonts.prompt()),
=======
>>>>>>> 40dcc06aa271e3f2e1a7cc4d893bdf3d7a5a6eb0
            ),
            const SizedBox(height: 20),
            /*ElevatedButton(
              onPressed: disconnectClient,
              child: Text('Disconnect', style: GoogleFonts.prompt()),
            ), */
            const SizedBox(height: 20),
            TextField(
      
              controller: messageController,
              decoration: InputDecoration(
<<<<<<< HEAD
                  contentPadding: const EdgeInsets.all(20),
                  labelText: 'Type a Message',
                  hintStyle: GoogleFonts.prompt()),
=======
                contentPadding: const EdgeInsets.all(20),
                  labelText: 'Type a Message', hintStyle: GoogleFonts.prompt()),
>>>>>>> 40dcc06aa271e3f2e1a7cc4d893bdf3d7a5a6eb0
            ),
            ElevatedButton(
              onPressed: () {
                startClient();
              },
              child: Text(
                'Send Message to Server',
                style: GoogleFonts.prompt(),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Received Message from server: $receivedMessage',
              style: GoogleFonts.prompt(),
            ),
          ],
        ),
      ),
    );
  }
}
