import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_automatic_feeder/app/core/errors/database_exception.dart';
import 'package:flutter_automatic_feeder/app/core/types/types.dart';

import 'package:flutter_automatic_feeder/app/features/home/interactor/entities/product_entity.dart';
import 'package:flutter_automatic_feeder/app/features/home/interactor/entities/device_entity.dart';
import 'package:intl/intl.dart';

import '../../interactor/repositories/i_home_repository.dart';
import '../adapters/products_adapter.dart';
import '../adapters/devices_adapter.dart';

class HomeRepositoryImpl implements IHomeRepository {
  final FirebaseDatabase realTimeDatabase;

  HomeRepositoryImpl({required this.realTimeDatabase});

  @override
  Stream<Output<List<ProductEntity>>> getProducts(String deviceId) async* {
    try {
      final reference = realTimeDatabase.ref('products/$deviceId');

      await for (final event in reference.onValue) {
        final result = _handleProductsEvent(event);
        yield result;
      }
    } on DatabaseException catch (e) {
      yield Left(e);
    } catch (e) {
      yield Left(DatabaseException(
          message: 'Erro inesperado ao buscar produtos: ${e.toString()}'));
    }
  }

  Output<List<ProductEntity>> _handleProductsEvent(DatabaseEvent event) {
    final data = event.snapshot.value;

    if (data == null) {
      return const Right([]);
    }

    try {
      final products = _transformProductsData(data);
      return Right(products);
    } catch (e) {
      return Left(DatabaseException(
          message: 'Erro ao processar dados dos produtos: ${e.toString()}'));
    }
  }

  List<ProductEntity> _transformProductsData(dynamic data) {
    final Map<String, dynamic> productsMap =
        Map<String, dynamic>.from(data as Map);

    return productsMap.entries
        .map(_convertProductEntry)
        .whereType<ProductEntity>()
        .toList();
  }

  ProductEntity? _convertProductEntry(MapEntry<String, dynamic> entry) {
    try {
      final productData = Map<String, dynamic>.from(entry.value as Map);
      productData['id'] = entry.key;
      return ProductsAdapter.fromJson(productData);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Output<bool>> updateProduct(
    String productId,
    String deviceId,
    String name,
    int quantity,
    int timeInMinutes,
  ) async {
    try {
      final reference = realTimeDatabase.ref('products/$deviceId/$productId');
      await reference.update({
        'name': name,
        'quantity': quantity,
        'timeInMinutes': timeInMinutes,
        'updateAt': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      });

      return const Right(true);
    } on DatabaseException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(DatabaseException(
          message: 'Erro inesperado ao atualizar produto: ${e.toString()}'));
    }
  }

  @override
  Stream<Output<List<DeviceEntity>>> getDevices() async* {
    try {
      final reference = realTimeDatabase.ref('devices');

      await for (final event in reference.onValue) {
        final data = event.snapshot.value;

        if (data == null) {
          yield Left(
              DatabaseException(message: 'Nenhum dispositivo encontrado'));
          continue;
        }

        try {
          final Map<String, dynamic> devicesMap =
              Map<String, dynamic>.from(data as Map);

          final devices = devicesMap.entries.map((entry) {
            final deviceData = Map<String, dynamic>.from(entry.value as Map);
            deviceData['id'] = entry.key;
            return DevicesAdapter.fromJson(deviceData);
          }).toList();

          yield Right(devices);
        } catch (e) {
          yield Left(DatabaseException(
              message:
                  'Erro ao processar dados dos dispositivos: ${e.toString()}'));
        }
      }
    } catch (e) {
      yield Left(DatabaseException(
          message: 'Erro inesperado ao buscar dispositivos: ${e.toString()}'));
    }
  }

  @override
  Future<Output<bool>> createProduct(
    String deviceId,
    String name,
    int quantity,
    int timeInMinutes,
  ) async {
    try {
      final reference = realTimeDatabase.ref('products/$deviceId/').push();
      await reference.set({
        'name': name,
        'quantity': quantity,
        'timeInMinutes': timeInMinutes,
        'updateAt': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      });

      return const Right(true);
    } on DatabaseException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(DatabaseException(
          message: 'Erro inesperado ao criar produto: ${e.toString()}'));
    }
  }

  @override
  Future<Output<bool>> deleteProduct(
    String deviceId,
    String productId,
  ) async {
    try {
      final reference = realTimeDatabase.ref('products/$deviceId/$productId');
      await reference.remove();
      return const Right(true);
    } on DatabaseException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(DatabaseException(
          message: 'Erro inesperado ao deletar produto: ${e.toString()}'));
    }
  }
}
