class PulsarPartitionedTopicBaseResp {
  final String topicName;
  final int partitionNum;
  final double msgRateIn;
  final double msgRateOut;
  final int msgInCounter;
  final int msgOutCounter;
  final int storageSize;

  PulsarPartitionedTopicBaseResp(this.topicName, this.partitionNum, this.msgRateIn, this.msgRateOut, this.msgInCounter,
      this.msgOutCounter, this.storageSize);

  PulsarPartitionedTopicBaseResp deepCopy() {
    return new PulsarPartitionedTopicBaseResp(
        topicName, partitionNum, msgRateIn, msgRateOut, msgInCounter, msgOutCounter, storageSize);
  }
}
