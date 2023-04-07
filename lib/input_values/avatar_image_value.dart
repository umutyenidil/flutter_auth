
class AvatarImageValue {
  final value;
  final AvatarImageStatus status;

  AvatarImageValue({
    required this.value,
    required this.status,
  });
}

enum AvatarImageStatus {
  initial,
  empty,
  fromAvatars,
  fromCamera,
  fromGallery,
}
