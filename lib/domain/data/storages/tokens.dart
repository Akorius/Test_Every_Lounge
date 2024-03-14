abstract class TokensStorage {
  late final String? accessToken;

  late final String? refreshToken;

  late final String? tinkoffAccessToken;

  late final String? tinkoffRefreshToken;

  late final String? alfaRefreshToken;

  Future<void> deleteTokens();
}
