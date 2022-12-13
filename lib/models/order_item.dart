class OrderItem {
  OrderItem({
    required this.fid,
    required this.name,
    required this.imgUrl,
    required this.price,
    required this.discount,
    required this.quantity,
  });

  String fid;
  String name;
  String imgUrl;
  int price;
  int discount;
  int quantity;
}
