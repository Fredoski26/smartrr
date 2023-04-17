import "package:envied/envied.dart";

part 'env.g.dart';

@Envied(path: ".env", requireEnvFile: true)
abstract class Env {
  @EnviedField(varName: "PAYSTACK_PUBLIC_KEY", obfuscate: true)
  static final paystackPublicKey = _Env.paystackPublicKey;
  @EnviedField(varName: "API_ACCESS_TOKEN", obfuscate: true)
  static final apiAccessToken = _Env.apiAccessToken;
  @EnviedField(varName: "API_BASE_URL", obfuscate: true)
  static final apiBaseUrl = _Env.apiBaseUrl;
  @EnviedField(varName: "SENTRY_DSN", obfuscate: true)
  static final sentryDsn = _Env.sentryDsn;
  @EnviedField(varName: "JWT_SECRET", obfuscate: true)
  static final jwtSecret = _Env.jwtSecret;
  @EnviedField(varName: "TERMII_API_KEY", obfuscate: true)
  static final termiiApiKey = _Env.termiiApiKey;
  @EnviedField(varName: "TERMII_SENDER_ID", obfuscate: true)
  static final termiiSenderId = _Env.termiiSenderId;
  @EnviedField(varName: "TERMII_API_BASE_URL", obfuscate: true)
  static final termiiApiBaseUrl = _Env.termiiApiBaseUrl;
  @EnviedField(varName: "GOOGLE_MAPS_API_KEY", obfuscate: true)
  static final googleMapsApiKey = _Env.googleMapsApiKey;
  @EnviedField(varName: "DEBUG_MODE", obfuscate: true)
  static final bool debugMode = _Env.debugMode;
}
