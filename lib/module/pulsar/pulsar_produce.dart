class ProducerResp {
  final String producerName;
  final double rateIn;
  final double throughputIn;
  final String clientVersion;
  final double averageMsgSize;
  final String address;

  ProducerResp(this.producerName, this.rateIn, this.throughputIn,
      this.clientVersion, this.averageMsgSize, this.address);

  ProducerResp deepCopy() {
    return new ProducerResp(producerName, rateIn, throughputIn, clientVersion,
        averageMsgSize, address);
  }
}
