class EveryLoungeToken {
  String accessToken;
  String refreshToken;
  int expiresIn;

  EveryLoungeToken({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory EveryLoungeToken.fromJson(Map<String, dynamic> map) {
    return EveryLoungeToken(
      accessToken: map['accessToken'] as String,
      refreshToken: map['refreshToken'] as String,
      expiresIn: map['expires_in'] as int,
    );
  }
}
