class PublishMessagesReq {
  final String producerName;
  final List<ProducerMessage> messages;

  PublishMessagesReq(this.producerName, this.messages);

  Map toJson() {
    Map map = new Map();
    map["producerName"] = this.producerName;
    map["messages"] = this.messages;
    return map;
  }
}

class ProducerMessage {
  final String payload;
  final String key;

  ProducerMessage(this.key, this.payload);
  Map toJson() {
    Map map = new Map();
    map["payload"] = this.payload;
    map["key"] = this.key;
    return map;
  }
}
