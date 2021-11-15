class ProducerResp {
  final String producerName;

  ProducerResp(this.producerName);

  ProducerResp deepCopy() {
    return new ProducerResp(producerName);
  }
}
