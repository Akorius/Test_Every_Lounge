///Object that stores tokens, [idToken] and [expiresIn] time
class TinkoffIdWebTokenPayload {
  final String accessToken;
  final int? expiresIn;
  final String? idToken;
  final String? refreshToken;

  TinkoffIdWebTokenPayload({
    required this.accessToken,
    required this.expiresIn,
    this.idToken,
    required this.refreshToken,
  });

  factory TinkoffIdWebTokenPayload.fromJson(Map<String, dynamic> map) {
    return TinkoffIdWebTokenPayload(
      accessToken: map['accessToken'] as String,
      expiresIn: map['expiresIn'] as int?,
      idToken: map['idToken'] as String?,
      refreshToken: map['refreshToken'] as String?,
    );
  }
}
