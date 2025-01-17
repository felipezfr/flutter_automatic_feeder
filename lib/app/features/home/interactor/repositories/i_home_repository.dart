import 'package:flutter_automatic_feeder/app/features/home/interactor/entities/product_entity.dart';
import 'package:flutter_automatic_feeder/app/features/home/interactor/entities/device_entity.dart';

import '../../../../core/types/types.dart';

abstract class IHomeRepository {
  Stream<Output<List<ProductEntity>>> getProducts(String deviceId);

  Future<Output<bool>> updateProduct(
    String productId,
    String deviceId,
    String name,
    int quantity,
    int timeInMinutes,
  );

  Stream<Output<List<DeviceEntity>>> getDevices();

  Future<Output<bool>> createProduct(
    String deviceId,
    String name,
    int quantity,
    int timeInMinutes,
  );

  Future<Output<bool>> deleteProduct(
    String deviceId,
    String productId,
  );
}
