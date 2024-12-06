import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:telegrammy/cores/constants/api_constants.dart';

class SocketService {
  late IO.Socket socket;

  void connect() {
    socket = IO.io("http://192.168.1.2:8080", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      'query': {
        'token':
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3MjEyOWFlN2ZmMjZlOGZjNzk5MGQ1ZSIsIm5hbWUiOiJtb2hhbWVkMjMyIiwiZW1haWwiOiJtazAwMTUyNjRAZ21haWwuY29tIiwicGhvbmUiOiIwMTE1MDEzNDU4OSIsImxvZ2dlZE91dEZyb21BbGxEZXZpY2VzQXQiOm51bGwsImlhdCI6MTczMzQ0MTA0NywiZXhwIjoxNzMzNDQ0NjQ3LCJhdWQiOiJteWFwcC11c2VycyIsImlzcyI6Im15YXBwIn0.Cj9ux0W2sYFS3lSp6aDv3dZWs1OLwZxYuvgyPd-Ya-o"
      }
    });
    socket.connect();

    // socket = await IO.io('ip server',
    //     OptionBuilder()
    //         .setTransports(['websocket']).build());
    socket.onConnect((_) => print('connect'));
    socket.onConnect((_) {
      print('connect');
    });
    socket.onConnectError((data) => print('error : ' + data.toString()));

    socket.onConnect((_) {
      print('Connected to the socket server');
    });

    socket.onConnectError((error) {
      print('Connection Error: $error');
    });

    socket.onDisconnect((_) {
      print('Disconnected from the socket server');
    });
  }

  void sendMessage(String event, dynamic data) {
    socket.emit(event, data);
    print('Message sent: $data');
  }

  void receiveMessage(String event, Function(dynamic) callback) {
    socket.on(event, (data) {
      print('Message received: $data');
      callback(data);
    });
  }

  void disconnect() {
    socket.disconnect();
    print('Connection closed');
  }
}
