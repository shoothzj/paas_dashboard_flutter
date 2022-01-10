class SubscriptionResp {
  final String subscriptionName;
  final int backlog;
  final double rateOut;

  SubscriptionResp(this.subscriptionName, this.backlog, this.rateOut);

  SubscriptionResp deepCopy() {
    return new SubscriptionResp(this.subscriptionName, this.backlog, this.rateOut);
  }
}
