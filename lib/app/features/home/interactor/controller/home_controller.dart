import 'package:flutter/foundation.dart';
import '../../../../core/controllers/controllers.dart';
import '../../../../core/states/base_state.dart';
import '../repositories/i_home_repository.dart';
import '../entities/device_entity.dart';
import '../entities/product_entity.dart';

class HomeController extends BaseController {
  final IHomeRepository repository;
  final _devicesNotifier = ValueNotifier<List<DeviceEntity>>([]);

  ValueListenable<List<DeviceEntity>> get devices => _devicesNotifier;

  HomeController(this.repository) : super(InitialState());

  Future<void> getDevices() async {
    repository.getDevices().listen(
      (event) {
        event.fold(
          (left) => update(ErrorState(exception: left)),
          (right) {
            _devicesNotifier.value = right;
          },
        );
      },
    );
  }

  Future<void> getProducts(String deviceId) async {
    update(LoadingState());
    repository.getProducts(deviceId).listen(
      (event) {
        event.fold(
          (left) => update(ErrorState(exception: left)),
          (right) => update(SuccessState(data: right)),
        );
      },
    );
  }

  Future<void> updateProduct(String deviceId, ProductEntity product) async {
    await repository.updateProduct(
      product.id,
      deviceId,
      product.name,
      product.quantity,
      product.timeInMinutes,
    );
  }

  Future<void> createProduct(String deviceId, ProductEntity product) async {
    await repository.createProduct(
      deviceId,
      product.name,
      product.quantity,
      product.timeInMinutes,
    );
  }

  Future<void> deleteProduct(String deviceId, String productId) async {
    await repository.deleteProduct(deviceId, productId);
  }
}
