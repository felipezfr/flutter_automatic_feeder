import 'package:flutter/material.dart';
import 'package:flutter_automatic_feeder/app/features/home/interactor/entities/product_entity.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../core/alert/alerts.dart';
import '../../../core/states/base_state.dart';
import '../interactor/controller/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Modular.get<HomeController>();

  @override
  void initState() {
    super.initState();
    controller.getProducts();
    controller.addListener(listener);
  }

  void listener() {
    if (controller.value case ErrorState(:final exception)) {
      Alerts.showFailure(context, exception.message);
    }
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tratador automático'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, child) {
            switch (value) {
              case SuccessState():
                final products = value.data as List<ProductEntity>;
                if (products.isEmpty) {
                  return const Center(
                    child: Text('Nenhum produto encontrado'),
                  );
                }
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      child: ListTile(
                        title: Text(product.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Quantidade: ${product.quantity}g'),
                            Text('Horário: ${product.time}:00'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              case LoadingState():
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ErrorState(:final exception):
                return Center(
                  child: Text(
                    'Erro: ${exception.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
      ),
    );
  }
}
