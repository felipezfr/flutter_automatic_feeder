import 'package:flutter/material.dart';
import 'package:flutter_automatic_feeder/app/features/home/interactor/entities/product_entity.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../core/alert/alerts.dart';
import '../../../core/states/base_state.dart';
import '../../../core/utils/time_utils.dart';
import '../interactor/controller/home_controller.dart';
import 'widgets/product_edit_dialog_widget.dart';
import '../interactor/entities/device_entity.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Modular.get<HomeController>();
  String? selectedDeviceId;

  @override
  void initState() {
    super.initState();
    controller.getDevices();
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

  void selectDevice(String deviceId) {
    selectedDeviceId = deviceId;
    controller.getProducts(selectedDeviceId!);
  }

  Future<void> _showEditDialog(ProductEntity product) async {
    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (context) => ProductDialogWidget(
        product: product,
        onSave: (updatedProduct) {
          controller.updateProduct(selectedDeviceId!, updatedProduct);
        },
      ),
    );
  }

  Future<void> _showCreateDialog() async {
    if (!mounted || selectedDeviceId == null) return;

    final product = ProductEntity(
      id: '',
      name: '',
      quantity: 100,
      timeInMinutes: TimeUtils.timeOfDayToMinutes(TimeOfDay.now()),
    );

    await showDialog(
      context: context,
      builder: (context) => ProductDialogWidget(
        product: product,
        isCreating: true,
        onSave: (newProduct) {
          controller.createProduct(selectedDeviceId!, newProduct);
        },
      ),
    );
  }

  Future<void> _showDeleteConfirmation(ProductEntity product) async {
    if (!mounted || selectedDeviceId == null) return;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja realmente excluir o produto "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteProduct(selectedDeviceId!, product.id);
              Navigator.of(context).pop();
            },
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceSelector(List<DeviceEntity> devices) {
    if (selectedDeviceId == null && devices.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          selectDevice(devices.first.id);
        });
      });
    }

    return DropdownButton<String>(
      value: selectedDeviceId,
      hint: const Text('Selecione um dispositivo'),
      items: devices.map((device) {
        return DropdownMenuItem<String>(
          value: device.id,
          child: Text(device.name),
        );
      }).toList(),
      onChanged: (String? deviceId) {
        if (deviceId != null) {
          setState(() {
            selectDevice(deviceId);
          });
        }
      },
    );
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
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: controller.devices,
              builder: (context, devices, child) {
                if (devices.isEmpty) {
                  return const SizedBox.shrink();
                }
                return _buildDeviceSelector(devices);
              },
            ),
            if (selectedDeviceId != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _showCreateDialog,
                  ),
                ],
              ),
            Expanded(
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
                                  Text(
                                      'Horário: ${TimeUtils.formatMinutes(product.timeInMinutes)}'),
                                ],
                              ),
                              onTap: () => _showEditDialog(product),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    _showDeleteConfirmation(product),
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
          ],
        ),
      ),
    );
  }
}
