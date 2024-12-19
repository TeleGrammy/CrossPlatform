import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';

class GroupSocketService {
  late IO.Socket groupsSocket;

  void connectToGroupServer() async {
    String? token = await getit.get<TokenStorageService>().getToken();
    print(token);
    groupsSocket = IO.io("http://localhost:8080/group/", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      'query': {
        'token': token,
      }
    });
    groupsSocket.connect();
    await Future.delayed(Duration(seconds: 5));
    groupsSocket.onConnectError(
        (data) => print('error in groups socket: ' + data.toString()));

    groupsSocket.onConnect((_) {
      print('Connected to the group server');
    });

    groupsSocket.onDisconnect((_) {
      print('Disconnected from the group server');
    });
  }

  void createGroup(String name, String description) {
    groupsSocket
        .emit('creatingGroup', {'name': name, 'description': description});
  }

  void leaveGroup(String groupId) {
    groupsSocket.emit('leavingGroup', {'groupId': groupId});
  }

  void deleteGroup(String groupId) {
    groupsSocket.emit('removingGroup', {'groupId': groupId});
  }

  void addMember(String groupId, String userId) {
    groupsSocket.emitWithAck('addingGroupMemberV2', {
      'groupId': groupId,
      'userIds': [userId]
    }, ack: (response) {
      print(response);
    });
  }

  void removeParticipant(String groupId, String userId) {
    groupsSocket
        .emit('removingParticipant', {'groupId': groupId, 'userId': userId});
  }

  void listenGroupCreated() {
    groupsSocket.on(
        'group:created', (data) => print('group created successfully $data'));
  }

  void listenGroupDeleted() {
    groupsSocket.on('group:deleted', (data) => print('group deleted $data'));
  }

  void listenLeftGroup() {
    groupsSocket.on('user:leftGroup', (data) => print('left group $data'));
  }

  void listenMemberAdded() {
    groupsSocket.on('group:memberAdded', (data) {});
  }

  void listenMemberLeft() {
    groupsSocket.on('group:memberLeft', (data) {});
  }

  void listenMemberRemoved() {
    groupsSocket.on('group:memberRemoved', (data) {});
  }

  void listenRemovedFromGroup() {
    groupsSocket.on('user:removedFromGroup', (data) {});
  }

  void listenForError() {
    groupsSocket.on('error', (data) => print('Error in groups socket: $data'));
  }

  void disconnectGroups() {
    groupsSocket.disconnect();
    print('groups connection closed');
  }
}
