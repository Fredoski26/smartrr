class Order {
  String name,
      address,
      email,
      phoneNumber,
      country,
      state,
      localGovernmentArea,
      majorLandmark,
      status,
      paymentRef,
      user,
      productName,
      productId;
  double deliveryFee, totalAmount;

  Order({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.country,
    required this.state,
    required this.localGovernmentArea,
    required this.majorLandmark,
    required this.status,
    required this.paymentRef,
    required this.user,
    required this.productName,
    required this.productId,
    required this.deliveryFee,
    required this.totalAmount,
  });
}
