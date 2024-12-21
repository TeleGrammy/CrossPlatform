import 'package:flutter_webrtc/flutter_webrtc.dart';

class RTCSignaling {
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  Future<void> initialize() async {
    localRenderer.initialize();
    remoteRenderer.initialize();
    localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': false,
    });

    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    };

    peerConnection = await createPeerConnection(configuration);

    peerConnection?.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        // remoteStream = event.streams[0];
        print('Remote stream received');
        print(event);
        remoteRenderer.srcObject = event.streams[0];
      }
    };
    // localStream?.getTracks().forEach((track) {
    //   peerConnection?.addTrack(track, localStream!);
    // });

    // peerConnection!.addStream(localStream!);
    localStream!.getTracks().forEach((track) {
      print('local track added$track');
      peerConnection?.addTrack(track, localStream!);
    });

    localRenderer.srcObject = localStream;

    // peerConnection?.onTrack = (event) {
    //   // Attach remote stream
    // };
  }

  void addCandidate(RTCIceCandidate candidate) {
    peerConnection?.addCandidate(candidate);
  }

  Future<RTCSessionDescription> createOffer() async {
    final offer = await peerConnection?.createOffer();
    if (offer != null) {
      await peerConnection?.setLocalDescription(offer);
    }
    return offer!;
  }

  Future<RTCSessionDescription> createAnswer() async {
    final answer = await peerConnection?.createAnswer();
    if (answer != null) {
      await peerConnection?.setLocalDescription(answer);
    }
    return answer!;
  }
}
