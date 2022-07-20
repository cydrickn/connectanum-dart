import 'dart:async';
import 'dart:collection';

import 'abstract_message_with_payload.dart';
import 'message_types.dart';
import 'uri_pattern.dart';
import 'error.dart';
import 'yield.dart';

class Invocation extends AbstractMessageWithPayload {
  int requestId;
  int registrationId;
  InvocationDetails details;
  late StreamController<AbstractMessageWithPayload> _responseStreamController;

  void respondWith(
      {List<dynamic>? arguments,
      Map<String, dynamic>? argumentsKeywords,
      bool isError = false,
      String? errorUri,
      bool progressive = false}) {
    if (isError) {
      assert(progressive == false);
      assert(UriPattern.match(errorUri!));
      final error = Error(
          MessageTypes.codeInvocation, requestId, HashMap(), errorUri,
          arguments: arguments, argumentsKeywords: argumentsKeywords);
      _responseStreamController.add(error);
    } else {
      final yield = Yield(requestId,
          options: YieldOptions(progressive),
          arguments: arguments,
          argumentsKeywords: argumentsKeywords);
      _responseStreamController.add(yield);
    }
    if (!progressive) {
      _responseStreamController.close();
    }
  }

  Invocation(this.requestId, this.registrationId, this.details,
      {List<dynamic>? arguments, Map<String, dynamic>? argumentsKeywords}) {
    id = MessageTypes.codeInvocation;
    this.arguments = arguments;
    this.argumentsKeywords = argumentsKeywords;
  }

  bool isProgressive() {
    return details.receiveProgress ?? false;
  }

  void onResponse(
      void Function(AbstractMessageWithPayload invocationResultMessage)
          onData) {
    _responseStreamController = StreamController<AbstractMessageWithPayload>();
    _responseStreamController.stream.listen(onData);
  }
}

class InvocationDetails {
  // caller_identification == true
  int? caller;

  // pattern_based_registration == true
  String? procedure;

  // pattern_based_registration == true
  bool? receiveProgress;

  InvocationDetails(this.caller, this.procedure, this.receiveProgress);
}
