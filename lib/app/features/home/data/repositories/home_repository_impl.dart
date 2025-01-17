import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_automatic_feeder/app/core/errors/database_exception.dart';
import 'package:flutter_automatic_feeder/app/core/types/types.dart';

import 'package:flutter_automatic_feeder/app/features/home/interactor/entities/product_entity.dart';

import '../../interactor/repositories/i_home_repository.dart';
import '../adapters/products_adapter.dart';

class HomeRepositoryImpl implements IHomeRepository {
  final FirebaseDatabase realTimeDatabase;

  HomeRepositoryImpl({required this.realTimeDatabase});

  @override
  Stream<Output<List<ProductEntity>>> getProducts(String deviceId) async* {
    try {
      final reference = realTimeDatabase.ref('devices/$deviceId/products');

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
      return Left(DatabaseException(
          message: 'Nenhum produto encontrado para este dispositivo'));
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
}
