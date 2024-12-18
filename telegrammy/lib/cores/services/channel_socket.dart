import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';

class ChannelSocketService {
  IO.Socket? socket;
  Future<void> connect() async {
    print('inside connect sokect');
    try {
      String? token = await getit.get<TokenStorageService>().getToken();

      if (token == null) {
        print('Token is null. Cannot connect to the socket server.');
        return;
      }

      socket = IO.io(
        "http://localhost:8080/channel/",
        <String, dynamic>{
          "transports": ["websocket"],
          "autoConnect": false,
          "query": {
            "token": token,
          },
        },
      );

      //Explicitly connect
      socket?.connect();

      // Handle connection success
      socket?.onConnect((_) {
        print('Connected to channels socket server');
      });

      // Handle connection errors
      socket?.onConnectError((data) {
        print('Connection error: $data');
      });

      // Handle disconnection
      socket?.onDisconnect((_) {
        print('Disconnected from the channel socket server');
      });
    } catch (e) {
      print('Error connecting to socket server: $e');
    }
  }

  void removeChannel(dynamic data) {
    print('inside remove channel socket event');
    socket?.emitWithAck('removingChannel', [data], ack: (Response) {
      print('channel removed response: $Response');
    });
  }

  void addSubscribers(dynamic data) {
    socket?.emitWithAck('addingChannelSubscriper', [data], ack: (Response) {
      print('adding subscriber response: $Response');
    });
  }

  void removeParticipant(dynamic data) {
    socket?.emitWithAck('removingParticipant', [data], ack: (Response) {
      print('remove participant response: $Response');
    });
  }

  void promoteSubscriber(dynamic data) {
    socket?.emitWithAck('promoteSubscriper', [data], ack: (Response) {
      print('promote subcriber response: $Response');
    });
  }

  void demoteAdmin(dynamic data) {
    socket?.emitWithAck('demoteAdmin', [data], ack: (Response) {
      print('demote admin response : $Response');
    });
  }

  void channelDeleteMessage(Function(dynamic) callback) {
    socket?.on('channel:delete', (data) {
      print('channel deleted Message received: $data');
      callback(data);
    });
  }

  void userRemovedFromChannelMessage(Function(dynamic) callback) {
    socket?.on('user:removedFromChannel', (data) {
      print('user removed from channel Message received: $data');
      callback(data);
    });
  }

  void userAddedToChannelMessage(Function(dynamic) callback) {
    socket?.on('user:addedToChannel', (data) {
      print('user added to channel Message received: $data');
      callback(data);
    });
  }

  void userPromotedMessage(Function(dynamic) callback) {
    socket?.on('user:promotedToAdmin', (data) {
      print('user promoted to admin Message received: $data');
      callback(data);
    });
  }

  void demoteAdminMessage(Function(dynamic) callback) {
    socket?.on('user:demoteOfAdmin', (data) {
      print('user demoted of admin Message received: $data');
      callback(data);
    });
  }

  void errorChannelMessage(Function(dynamic) callback) {
    socket?.on('error', (data) {
      print('channel operation error message received: $data');
      callback(data);
    });
  }
}
