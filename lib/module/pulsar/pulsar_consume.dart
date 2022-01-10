class ConsumerResp {
  final String consumerName;
  final String subscriptionName;
  final double rateOut;
  final double throughputOut;
  final double availablePermits;
  final double unackedMessages;
  final double lastConsumedTimestamp;
  final String clientVersion;
  final String address;

  ConsumerResp(this.consumerName, this.subscriptionName, this.rateOut, this.throughputOut, this.availablePermits,
      this.unackedMessages, this.lastConsumedTimestamp, this.clientVersion, this.address);

  ConsumerResp deepCopy() {
    return new ConsumerResp(consumerName, subscriptionName, rateOut, throughputOut, availablePermits, unackedMessages,
        lastConsumedTimestamp, clientVersion, address);
  }
}
