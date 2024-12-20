import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:telegrammy/cores/services/call_manager.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/socket.dart';

class IncomingCallScreen extends StatefulWidget {
  final String name;
  final String photoUrl;
  final String callId;
  final RTCSessionDescription remoteOffer;

  const IncomingCallScreen({
    Key? key,
    required this.name,
    required this.photoUrl,
    required this.callId,
    required this.remoteOffer,
  }) : super(key: key);

  @override
  _IncomingCallScreenState createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  final CallManager callManager = CallManager();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _isMuted = false;

  Future<void> _answerCall() async {
    // RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
    // await remoteRenderer.initialize();

    await callManager.rtcSignaling.initialize();
    _localRenderer.srcObject = callManager.rtcSignaling.localStream;
    _remoteRenderer.srcObject = callManager.rtcSignaling.remoteStream;
    // Set the remote offer and create an answer
    await callManager.rtcSignaling.peerConnection
        ?.setRemoteDescription(widget.remoteOffer);

    dynamic answer = await callManager.rtcSignaling.createAnswer();
    getit.get<SocketService>().answerCall('call:answer', {
      'callId': widget.callId,
      'answer': {
        'sdp': answer.sdp,
        'type': answer.type,
      },
    });
    callManager.rtcSignaling.peerConnection?.onIceCandidate = (candidate) {
      if (candidate != null) {
        getit.get<SocketService>().addiCE('call:addMyIce', {
          'callId': widget.callId,
          'IceCandidate': candidate.toMap(),
        });
      }
    };

    getit.get<SocketService>().receiveAddedICE('call:addedICE', (response) {
      callManager.rtcSignaling.peerConnection?.addCandidate(
        RTCIceCandidate(
          response['callObj']['offererIceCandidate']['candidate'],
          response['callObj']['offererIceCandidate']['sdpMLineIndex'],
          response['callObj']['offererIceCandidate']['sdpMid'],
        ),
      );
    });

    // callManager.rtcSignaling.peerConnection?.onTrack = (event) {
    //   if (event.streams.isNotEmpty) {
    //     print('Callee received remote stream');
    //     callManager.attachRemoteStream(event.streams[0]);
    //   }
    // };

    // callManager.rtcSignaling.peerConnection?.onAddStream =
    //     (MediaStream stream) {
    //   remoteRenderer.srcObject = stream;
    // };
    // Handle ICE candidate generation
    // callManager.rtcSignaling.peerConnection?.onIceCandidate = (candidate) {
    //   if (candidate != null) {
    //     callManager.addMyICE(widget.callId, candidate);
    //   }
    // };

    // Navigator.pop(context); // Close incoming call screen
  }

  void _rejectCall() {
    callManager.rejectCall(widget.callId); // Notify backend
    Navigator.pop(context); // Close incoming call screen
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

    setState(() {
      _localRenderer.srcObject = null;
      _remoteRenderer.srcObject = null;
    });
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
              ),
              IconButton(
                icon: Icon(Icons.call_end),
                onPressed: _endCall,
              ),
              IconButton(
                icon: Icon(Icons.call),
                onPressed: _answerCall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
