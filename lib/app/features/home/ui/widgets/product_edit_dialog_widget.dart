import 'package:flutter/material.dart';
import '../../../../core/utils/time_utils.dart';
import '../../interactor/entities/product_entity.dart';

class ProductEditDialogWidget extends StatefulWidget {
  final ProductEntity product;
  final Function(ProductEntity product) onSave;

  const ProductEditDialogWidget({
    super.key,
    required this.product,
    required this.onSave,
  });

  @override
  State<ProductEditDialogWidget> createState() =>
      _ProductEditDialogWidgetState();
}

class _ProductEditDialogWidgetState extends State<ProductEditDialogWidget> {
  late final TextEditingController nameController;
  late final TextEditingController quantityController;
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    quantityController =
        TextEditingController(text: widget.product.quantity.toString());
    selectedTime = TimeUtils.minutesToTimeOfDay(widget.product.timeInMinutes);
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Produto'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantidade (g)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                'Horário: ${TimeUtils.formatMinutes(TimeUtils.timeOfDayToMinutes(selectedTime))}',
              ),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final newTime = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(alwaysUse24HourFormat: true),
                      child: child!,
                    );
                  },
                );
                if (newTime != null) {
                  setState(() {
                    selectedTime = newTime;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            final name = nameController.text;
            final quantity = int.tryParse(quantityController.text) ??
                widget.product.quantity;
            final timeInMinutes = TimeUtils.timeOfDayToMinutes(selectedTime);

            final updatedProduct = ProductEntity(
              id: widget.product.id,
              name: name,
              quantity: quantity,
              timeInMinutes: timeInMinutes,
            );

            widget.onSave(updatedProduct);
            Navigator.of(context).pop();
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
