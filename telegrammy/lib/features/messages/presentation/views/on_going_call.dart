import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/app_routes.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/cores/services/call_manager.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/socket.dart';
import 'package:telegrammy/features/messages/data/models/contacts.dart';

class OutgoingCallScreen extends StatefulWidget {
  final String userId;
  final ChatView chat;
  // final VoidCallback onCallEnded;

  const OutgoingCallScreen({
    Key? key,
    required this.chat,
    required this.userId,
    // required this.onCallEnded,
  }) : super(key: key);

  @override
  _OutgoingCallScreenState createState() => _OutgoingCallScreenState();
}

class _OutgoingCallScreenState extends State<OutgoingCallScreen> {
  final CallManager callManager = CallManager();
  // final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  // final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _isMuted = false;
  String? callId;

  @override
  void initState() {
    super.initState();
    // _localRenderer.initialize();
    // _remoteRenderer.initialize();
    _startCall();

    getit.get<SocketService>().recieveEndedCall('call:endedCall', (data) {
      List<dynamic>? d = data['participants'];

      if (d != null && d?.length == 1) {
        _endCall();
      }
    });
    getit.get<SocketService>().receiveRejectedCall('call:rejectedCall', (data) {
      List<dynamic>? d = data['participants'];

      if (d != null && d?.length == 1) {
        _endCall();
      }
    });
  }

  @override
  void dispose() {
    // _localRenderer.dispose();
    // _remoteRenderer.dispose();
    super.dispose();
  }

  void setCallId(String id) {
    callId = id;
  }

  Future<void> _startCall() async {
    // RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
    // await remoteRenderer.initialize();
    await callManager.rtcSignaling.initialize(); // Initialize WebRTC
    // _localRenderer.srcObject = callManager.rtcSignaling.localStream;
    // _remoteRenderer.srcObject = callManager.rtcSignaling.remoteStream;
    callId = await getit
        .get<SocketService>()
        .createCall('call:createCall', {"chatId": widget.chat.id});

    dynamic offer = await callManager.rtcSignaling.createOffer();
    getit.get<SocketService>().newCall('call:newCall', {
      'callId': callId,
      'offer': {
        'sdp': offer.sdp,
        'type': offer.type,
      },
    });

    // // Handle ICE candidate generation
    callManager.rtcSignaling.peerConnection?.onIceCandidate = (candidate) {
      if (candidate != null) {
        getit.get<SocketService>().addiCE('call:addMyIce', {
          'callId': callId,
          'IceCandidate': candidate.toMap(),
        });
      }
    };

    getit.get<SocketService>().receiveAddedICE('call:addedICE', (response) {
      print(response['callObj']['participantICE']);
      callManager.rtcSignaling.peerConnection?.addCandidate(
        RTCIceCandidate(
          response['callObj']['participantICE']['candidate'],
          response['callObj']['participantICE']['sdpMid'].toString(),
          response['callObj']['participantICE']['sdpMLineIndex'],
        ),
      );
    });

    getit.get<SocketService>().recieveAnswer('call:answeredCall', (response) {
      callManager.rtcSignaling.peerConnection?.setRemoteDescription(
        RTCSessionDescription(
          response['callObj']['answer']['sdp'],
          response['callObj']['answer']['type'],
        ),
      );
    });

    // callManager.rtcSignaling.peerConnection?.onTrack = (event) {
    //   if (event.streams.isNotEmpty) {
    //     print('Remote stream received');
    //     callManager.attachRemoteStream(event.streams[0]);
    //   }
    // };

    // callManager.rtcSignaling.peerConnection?.onAddStream =
    //     (MediaStream stream) {
    //   remoteRenderer.srcObject = stream;
    // };
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      callManager.rtcSignaling.localStream?.getAudioTracks().forEach((track) {
        track.enabled = !_isMuted;
      });
    });
  }

  Future<void> _endCall() async {
    await callManager.endCall('chatId');
    getit.get<SocketService>().endcall('call:end', {
      'callId': callId,
      'status': 'ended',
    });
    context.goNamed(RouteNames.chatWrapper,
        extra: [widget.chat,widget.userId]);
    // setState(() {
    //   _localRenderer.srcObject = null;
    //   _remoteRenderer.srcObject = null;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Audio Call')),
      body: Column(
        children: [
          Expanded(
            child: RTCVideoView(
              callManager.rtcSignaling.remoteRenderer,
              mirror: true,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(_isMuted ? Icons.mic_off : Icons.mic),
                onPressed: _toggleMute,
                color: _isMuted ? Colors.red : Colors.black,
              ),
              IconButton(
                icon: Icon(Icons.call_end),
                onPressed: _endCall,
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
