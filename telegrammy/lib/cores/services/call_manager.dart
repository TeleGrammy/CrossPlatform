import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/socket.dart';
import 'rtc_signaling.dart';

class CallManager {
  final RTCSignaling rtcSignaling = RTCSignaling();

  // void attachRemoteStream(MediaStream remoteStream) {
  //   if (remoteStream.getAudioTracks().isNotEmpty) {
  //     print('Remote audio track attached: ${remoteStream.id}');
  //     // Ensure the remote audio is active
  //     remoteStream.getAudioTracks().forEach((track) {
  //       track.enabled = true;
  //     });
  //   } else {
  //     print('No audio tracks found in the remote stream.');
  //   }
  // }

  // void connectToServer(String serverUrl) {
  //   getit
  //       .get<SocketService>()
  //       .recieveCall('incomingCall', (data) => _handleIncomingCall(data));
  //   getit
  //       .get<SocketService>()
  //       .recieveAnswer('answeredCall', (data) => _handleAnsweredCall(data));
  //   getit
  //       .get<SocketService>()
  //       .receiveRejectedCall('rejectedCall', (_) => _handleRejectedCall());
  //   getit
  //       .get<SocketService>()
  //       .receiveAddedICE('addedICE', (data) => _handleAddedICE(data));
  //   getit
  //       .get<SocketService>()
  //       .recieveEndedCall('endedCall', (_) => _handleEndedCall());
  // }

  // void newCall(String callId, RTCSessionDescription offer) {
  //   getit.get<SocketService>().newCall('call:newCall', {
  //     'callId': callId,
  //     'offer': {
  //       'sdp': offer.sdp,
  //       'type': offer.type,
  //     },
  //   });
  // }


  // void addMyICE(String chatId, RTCIceCandidate candidate) {
  //   getit.get<SocketService>().addiCE('addMyIce', {
  //     'chatId': chatId,
  //     'candidate': candidate.toMap(),
  //   });
  // }

  Future<void> endCall(String chatId) async{
    rtcSignaling.peerConnection?.close();
    rtcSignaling.localStream?.dispose();
    rtcSignaling.remoteStream?.dispose();
    rtcSignaling.remoteRenderer.dispose();
    rtcSignaling.localRenderer.dispose();
  }

  void rejectCall(String callId) {
    getit.get<SocketService>().rejectCall('reject', {'callId': callId});
  }

  // void answerCall(String callId, RTCSessionDescription answer) {
  //   getit.get<SocketService>().answerCall('answer', {
  //     'callId': callId,
  //     'answer': {
  //       'sdp': answer.sdp,
  //       'type': answer.type,
  //     },
  //   });
  // }

  // // Incoming event handlers
  // void _handleIncomingCall(dynamic data) {
  //   // Display incoming call UI
  //   final name = data['name'];
  //   final photoUrl = data['photo'];
  //   final callId = data['callId'];
  //   // Route to IncomingCallScreen with answer/reject handlers
  // }

  // void _handleAnsweredCall(dynamic data) {
  //   // Set remote description and start the call
  //   final answer = data['answer'];
  //   rtcSignaling.peerConnection?.setRemoteDescription(
  //     RTCSessionDescription(answer['sdp'], answer['type']),
  //   );
  // }

  // void _handleRejectedCall() {
  //   // Navigate back to home
  //   print('Call rejected');
  // }

  // void _handleAddedICE(dynamic data) {
  //   final candidate = data['candidate'];
  //   rtcSignaling.addCandidate(
  //     RTCIceCandidate(candidate['candidate'], candidate['sdpMid'],
  //         candidate['sdpMLineIndex']),
  //   );
  // }

  // void _handleEndedCall() {
  //   // End call logic and navigate back
  //   print('Call ended');
  // }
}
