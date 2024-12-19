import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:telegrammy/cores/constants/api_constants.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';

class SocketService {
  IO.Socket? socket;

  Future<void> connect() async {
    String? token = await getit.get<TokenStorageService>().getToken();
    socket = IO.io(socketurl, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      'query': {
        'token': token,
      }
    });
    socket?.connect();
    socket?.onConnectError((data) => print('error : ' + data.toString()));

    socket?.onConnect((_) {
      print('Connected to the socket server');
    });

    socket?.onDisconnect((_) {
      print('Disconnected from the socket server');
    });
  }

  void sendMessage(String event, dynamic data) {
    socket?.emitWithAck(event, [data], ack: (Response) {
      print('$Response');
    });
    print('Message sent: $data');
  }

  void editMessage(String event, dynamic data) {
    socket?.emit(event, data);
  }

  void deleteMessage(String event, dynamic data) {
    socket?.emit(event, data);
  }
  void draftMessage(String event, dynamic data) {
    print(data);
    socket?.emit(event, data);
  }

  void receiveMessage(String event, Function(dynamic) callback) {
    socket?.on(event, (data) {
      print('Message received: $data');
      callback(data);
    });
  }

  void receiveEditedMessage(String event, Function(dynamic) callback) {
    socket?.on(event, (data) {
      print('Message edited: $data');
      callback(data);
    });
  }

  void receiveDeletedMessage(String event, Function(dynamic) callback) {
    socket?.on(event, (data) {
      print('Message deleted: $data');
      callback(data);
    });
  }


  void pinMessage(String event, dynamic data) {
    socket?.emit(event, data);
  }

  void unpinMessage(String event, dynamic data) {
    socket?.emit(event, data);
  }

  void pinMessagerecived(String event, Function(dynamic) callback) {
    socket?.on(event, (data) {
      print('pinMessagerecived: $data');
      callback(data);
    });
  }

  void unpinMessagerecived(String event, Function(dynamic) callback) {
    socket?.on(event, (data) {
      // print('unpinMessagerecived: $data');
      callback(data);
    });
  }
  void deliveredMessage(String event, Function(dynamic) callback) {
    socket?.on(event, (data) {
      print('deliveredMessage: $data');
      callback(data);
    });
  }
  void seenMessage(String event, Function(dynamic) callback) {
    socket?.on(event, (data) {
      print('seenMessage: $data');
      callback(data);
    });
  }
    void draftMessagerecived(String event, Function(dynamic) callback) {
      print('dddddd');
    socket?.on(event, (data) {
      print('draftMessage: $data');
      callback(data);
    });
  }
      void isSentMessage(String event, Function(dynamic) callback) {
      // print('dddddd');
    socket?.on(event, (data) {
      // print('isSentMessage: $data');
      callback(data);
    });
  }

  void disconnect() {
    socket?.disconnect();
    print('Connection closed');
  }
}
