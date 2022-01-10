class PulsarTopicBaseResp {
  final String topicName;
  final int partitionNum;
  final double msgRateIn;
  final double msgRateOut;
  final double msgInCounter;
  final double msgOutCounter;
  final double storageSize;

  PulsarTopicBaseResp(this.topicName, this.partitionNum, this.msgRateIn, this.msgRateOut, this.msgInCounter,
      this.msgOutCounter, this.storageSize);

  PulsarTopicBaseResp deepCopy() {
    return new PulsarTopicBaseResp(
        topicName, partitionNum, msgRateIn, msgRateOut, msgInCounter, msgOutCounter, storageSize);
  }
}
