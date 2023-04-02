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
  @EnviedField(varName: "AFRICASTALKING_USERNAME", obfuscate: true)
  static final africastalkingUsername = _Env.africastalkingUsername;
  @EnviedField(varName: "AFRICASTALKING_API_KEY", obfuscate: true)
  static final africastalkingApiKey = _Env.africastalkingApiKey;
  @EnviedField(varName: "AFRICASTALKING_API_BASE_URL", obfuscate: true)
  static final africastalkingApiBaseUrl = _Env.africastalkingApiBaseUrl;
}
