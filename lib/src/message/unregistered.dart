import 'abstract_message.dart';

class Unregistered extends AbstractMessage {
    int unregisterRequestId;

    Unregistered(this.unregisterRequestId);
}
