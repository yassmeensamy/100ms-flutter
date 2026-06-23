import 'package:demo_app_with_100ms_and_bloc/bloc/preview/preview_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class PreviewObserver implements HMSPreviewListener {
  PreviewCubit previewCubit;

  List<HMSVideoTrack> localTracks = <HMSVideoTrack>[];

  PreviewObserver(this.previewCubit) {
    previewCubit.hmsSdk.addPreviewListener(listener: this);

    _initializeAndPreview();
  }

  Future<void> _initializeAndPreview() async {
    await previewCubit.hmsSdk.build();

    // Extract room code from URL
    String roomCode = _extractRoomCode(previewCubit.url);
    if (roomCode.isEmpty) {
      if (kDebugMode) {
        print("Invalid room URL");
      }
      return;
    }

    // Get auth token using SDK method
    dynamic tokenResult = await previewCubit.hmsSdk.getAuthTokenByRoomCode(
      roomCode: roomCode,
    );

    if (tokenResult is String) {
      HMSConfig config = HMSConfig(
        authToken: tokenResult,
        userName: previewCubit.name,
      );
      previewCubit.hmsSdk.preview(config: config);
    } else if (tokenResult is HMSException) {
      if (kDebugMode) {
        print("Error getting token: ${tokenResult.message}");
      }
    }
  }

  String _extractRoomCode(String url) {
    // Handle URLs like https://subdomain.app.100ms.live/meeting/abc-def-ghi
    Uri? uri = Uri.tryParse(url);
    if (uri == null) return "";

    List<String> pathSegments = uri.pathSegments;
    if (pathSegments.length >= 2) {
      // Return the last segment (room code)
      return pathSegments.last;
    }
    return "";
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    // TODO: implement onPeerUpdate
  }

  @override
  void onPreview({required HMSRoom room, required List<HMSTrack> localTracks}) {
    List<HMSVideoTrack> videoTracks = [];
    for (var track in localTracks) {
      if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
        videoTracks.add(track as HMSVideoTrack);
      }
    }
    this.localTracks.clear();
    this.localTracks.addAll(videoTracks);
    previewCubit.updateTracks(this.localTracks);
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    // TODO: implement onRoomUpdate
  }

  @override
  void onHMSError({required HMSException error}) {
    if (kDebugMode) {
      print("OnError ${error.message}");
    }
  }

  @override
  void onAudioDeviceChanged({
    HMSAudioDevice? currentAudioDevice,
    List<HMSAudioDevice>? availableAudioDevice,
  }) {
    // TODO: implement onAudioDeviceChanged
  }
}
