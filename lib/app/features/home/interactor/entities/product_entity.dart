class ProductEntity {
  final String id;
  final String name;
  final int quantity;
  final int timeInMinutes;
  final DateTime? updateAt;
  final DateTime? syncTimeDevice;

  ProductEntity({
    required this.id,
    required this.name,
    required this.quantity,
    required this.timeInMinutes,
    this.updateAt,
    this.syncTimeDevice,
  });
}
