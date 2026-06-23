///Package imports
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/src/common/utility_functions.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_circular_avatar.dart';

///[AudioLevelAvatar] is a widget that is used to render the audio level avatar
///It is used to render the audio level of the peer
class AudioLevelAvatar extends StatefulWidget {
  final double avatarRadius;
  final double avatarTitleFontSize;
  final double avatarTitleTextLineHeight;

  const AudioLevelAvatar({
    Key? key,
    this.avatarRadius = 34,
    this.avatarTitleFontSize = 34,
    this.avatarTitleTextLineHeight = 32,
  }) : super(key: key);

  @override
  State<AudioLevelAvatar> createState() => _AudioLevelAvatarState();
}

class _AudioLevelAvatarState extends State<AudioLevelAvatar> {
  @override
  Widget build(BuildContext context) {
    return Center(
      ///[Selector] rebuilds the widget when the peer name or the avatar url
      ///(stored in the peer metadata) changes
      child: Selector<PeerTrackNode, ({String name, String? avatarUrl})>(
        selector: (_, peerTrackNode) => (
          name: peerTrackNode.peer.name,
          avatarUrl: Utilities.getAvatarUrlFromMetadata(
            peerTrackNode.peer.metadata,
          ),
        ),
        builder: (_, data, __) {
          return HMSCircularAvatar(
            name: data.name,
            avatarUrl: data.avatarUrl,
            avatarRadius: widget.avatarRadius,
            avatarTitleFontSize: widget.avatarTitleFontSize,
            avatarTitleTextLineHeight: widget.avatarTitleTextLineHeight,
          );
        },
      ),
    );
  }
}
