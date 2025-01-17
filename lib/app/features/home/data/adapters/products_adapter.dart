import 'package:flutter_automatic_feeder/app/features/home/interactor/entities/product_entity.dart';

class ProductsAdapter {
  static ProductEntity fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      time: json['time'],
    );
  }
}
