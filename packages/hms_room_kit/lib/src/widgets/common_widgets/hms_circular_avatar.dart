///Package imports
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';

///[HMSCircularAvatar] is a widget that is used to render the circular avatar
///It takes following parameters:
///[name] is the name of the peer
///[avatarUrl] is the optional profile image url of the peer. When provided and
///the image loads successfully, the picture is shown instead of the initials.
///It gracefully falls back to the initials/icon avatar while loading or on error.
///[avatarRadius] is the radius of the avatar
///[avatarTitleFontSize] is the font size of the avatar title
///[avatarTitleTextColor] is the color of the avatar title
///[avatarTitleTextLineHeight] is the line height of the avatar title
///If the name is empty, we render the default user icon
class HMSCircularAvatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final double? avatarRadius;
  final double? avatarTitleFontSize;
  final Color? avatarTitleTextColor;
  final double avatarTitleTextLineHeight;
  const HMSCircularAvatar({
    super.key,
    required this.name,
    this.avatarUrl,
    this.avatarRadius = 34,
    this.avatarTitleFontSize = 34,
    this.avatarTitleTextColor,
    this.avatarTitleTextLineHeight = 32,
  });

  ///This renders the initials (or the default user icon when the name is
  ///empty). It is used both as the default avatar and as the fallback while
  ///the profile image is loading or if it fails to load.
  Widget _buildInitials() {
    return name.isEmpty
        ? SvgPicture.asset(
            'packages/hms_room_kit/lib/src/assets/icons/user.svg',
            fit: BoxFit.contain,
            semanticsLabel: "fl_user_icon_label",
          )
        : HMSTitleText(
            text: Utilities.getAvatarTitle(name),
            textColor:
                avatarTitleTextColor ?? HMSThemeColors.onSurfaceHighEmphasis,
            fontSize: avatarTitleFontSize,
            lineHeight: avatarTitleTextLineHeight,
          );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = avatarUrl != null && avatarUrl!.trim().isNotEmpty;

    return CircleAvatar(
      backgroundColor: Utilities.getBackgroundColour(name),
      radius: avatarRadius,
      child: hasImage

          ///When an image url is available we render it clipped to a circle.
          ///While it is loading we show just the plain coloured circle (no
          ///initials) so there is no jarring "letter then photo" flash. The
          ///initials are only used as the fallback if the image fails to load.
          ? ClipOval(
              child: Image.network(
                avatarUrl!,
                width: (avatarRadius ?? 34) * 2,
                height: (avatarRadius ?? 34) * 2,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null ? child : const SizedBox.shrink(),
                errorBuilder: (context, error, stackTrace) => _buildInitials(),
              ),
            )
          : _buildInitials(),
    );
  }
}
