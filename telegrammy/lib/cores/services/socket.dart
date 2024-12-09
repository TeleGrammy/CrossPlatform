import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:telegrammy/cores/constants/api_constants.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';

class SocketService {
  late IO.Socket socket;

  void connect() {
    // String? token = await getit.get<TokenStorageService>().getToken();
    socket = IO.io("http://localhost:8080", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      'query': {
        'token':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3MjEyOWFlN2ZmMjZlOGZjNzk5MGQ1ZSIsIm5hbWUiOiJtb2hhbWVkMjMyIiwiZW1haWwiOiJtazAwMTUyNjRAZ21haWwuY29tIiwicGhvbmUiOiIwMTE1MDEzNDU4OSIsImxvZ2dlZE91dEZyb21BbGxEZXZpY2VzQXQiOm51bGwsImlhdCI6MTczMzcwMDYxOSwiZXhwIjoxNzMzNzA0MjE5LCJhdWQiOiJteWFwcC11c2VycyIsImlzcyI6Im15YXBwIn0.GeGI7T2P4tGbs_51Edw1HbRtPU_9sick9HR5vlS-Q9I',
      }
    });
    socket.connect();
    // print(token);
    // socket = await IO.io('ip server',
    //     OptionBuilder()
    //         .setTransports(['websocket']).build());
    // socket.onConnect((_) => print('connect'));
    // socket.onConnect((_) {
    //   print('connect');
    // });
    socket.onConnectError((data) => print('error : ' + data.toString()));

    socket.onConnect((_) {
      print('Connected to the socket server');
    });

    socket.onDisconnect((_) {
      print('Disconnected from the socket server');
    });
  }

  void sendMessage(String event, dynamic data) {
    socket.emitWithAck(event, [data], ack: (Response) {
      print(Response);
    });
    print('Message sent: $data');
  }

  void editMessage(String event, dynamic data) {
    socket.emit(event, data);
  }

  void deleteMessage(String event, dynamic data) {
    socket.emit(event, data);
  }

  void receiveMessage(String event, Function(dynamic) callback) {
    socket.on(event, (data) {
      print('Message received: $data');
      callback(data);
    });
  }

  void receiveEditedMessage(String event, Function(dynamic) callback) {
    socket.on(event, (data) {
      print('Message edited: $data');
      callback(data);
    });
  }

  void receiveDeletedMessage(String event, Function(dynamic) callback) {
    socket.on(event, (data) {
      print('Message deleted: $data');
      callback(data);
    });
  }

  void disconnect() {
    socket.disconnect();
    print('Connection closed');
  }
}
