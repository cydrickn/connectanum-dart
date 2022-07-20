import 'abstract_message.dart';
import 'message_types.dart';

/// The WAMP Challenge massage
class Challenge extends AbstractMessage {
  String authMethod;
  Extra extra;

  /// Creates a WAMP Challenge message that is returned by the router to
  /// challenge the client with a given [authMethod] and some [extra]
  /// authentication data
  Challenge(this.authMethod, this.extra) {
    id = MessageTypes.codeChallenge;
  }
}

/// Challenge values to check the authentication validity
class Extra {
  String? challenge;
  String? salt;
  String? channelBinding;
  int? keylen;
  int? iterations;
  int? memory;
  String? kdf;
  String? nonce;

  Extra(
      {this.challenge,
      this.salt,
      this.keylen,
      this.channelBinding,
      this.iterations,
      this.memory,
      this.kdf,
      this.nonce});
}
