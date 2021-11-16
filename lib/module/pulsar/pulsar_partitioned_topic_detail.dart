class PulsarPartitionedTopicDetailResp {
  final String topicName;
  final int backlogSize;

  PulsarPartitionedTopicDetailResp(this.topicName, this.backlogSize);

  PulsarPartitionedTopicDetailResp deepCopy() {
    return new PulsarPartitionedTopicDetailResp(topicName, backlogSize);
  }
}
