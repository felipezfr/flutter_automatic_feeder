import 'package:flutter_automatic_feeder/app/features/home/interactor/entities/product_entity.dart';

import '../../../../core/types/types.dart';

abstract class IHomeRepository {
  Stream<Output<List<ProductEntity>>> getProducts(String deviceId);
}
