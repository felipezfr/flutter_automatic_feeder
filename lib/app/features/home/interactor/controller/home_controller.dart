import 'package:flutter/foundation.dart';
import '../../../../core/controllers/controllers.dart';
import '../../../../core/states/base_state.dart';
import '../repositories/i_home_repository.dart';
import '../entities/device_entity.dart';
import '../entities/product_entity.dart';
import 'package:flutter_automatic_feeder/app/features/home/interactor/entities/filter_type.dart';

class HomeController extends BaseController {
  final IHomeRepository repository;
  final _devicesNotifier = ValueNotifier<List<DeviceEntity>>([]);
  FilterType _currentSortOption = FilterType.time;

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
          (right) {
            var products = right;
            if (_currentSortOption == FilterType.time) {
              products = sortProductsByTime(right);
            } else if (_currentSortOption == FilterType.alphabetical) {
              products = sortProductsAlphabetically(right);
            }
            update(SuccessState(data: products));
          },
        );
      },
    );
  }

  void setSortOption(FilterType option) {
    _currentSortOption = option;
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

  List<ProductEntity> sortProductsByTime([List<ProductEntity>? products]) {
    try {
      bool updateList = products == null ? true : false;

      products ??= (state as SuccessState).data as List<ProductEntity>;
      products.sort((a, b) => a.timeInMinutes.compareTo(b.timeInMinutes));
      if (updateList) {
        update(SuccessState(data: products));
      }
      return products;
    } catch (e) {
      return products ?? (state as SuccessState).data as List<ProductEntity>;
    }
  }

  List<ProductEntity> sortProductsAlphabetically(
      [List<ProductEntity>? products]) {
    try {
      bool updateList = products == null ? true : false;

      products ??= (state as SuccessState).data as List<ProductEntity>;
      // Lógica para ordenar os produtos alfabeticamente
      products
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      if (updateList) {
        update(SuccessState(data: products));
      }
      return products;
    } catch (e) {
      return products ?? (state as SuccessState).data as List<ProductEntity>;
    }
  }
}
