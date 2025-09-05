import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forui/forui.dart';
import 'package:frontend/core/utils/seed_data/seed_items.dart';
import 'package:frontend/features/items/data/models/item_model.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  final List<ItemModel> _items = seedItems
      .map((e) => ItemModel.fromJson(e))
      .toList();

  void _addItem(String content) {
    final newItem = ItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      status: "New",
    );
    setState(() {
      _items.insert(0, newItem);
    });
  }

  void _showAddItemDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return FDialog(
          title: const Text("Add Item"),
          body: FTextFormField(
            controller: controller,
            hint: "Enter content",
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) =>
                (value != null && value.isNotEmpty) ? null : "Content required",
          ),
          actions: [
            FButton(
              onPress: () => Navigator.of(ctx).pop(),
              child: const Text("Cancel"),
            ),
            FButton(
              onPress: () {
                if (controller.text.trim().isNotEmpty) {
                  _addItem(controller.text.trim());
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FScaffold(
        header: const FHeader(title: Text("Items")),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 0.w),
          itemCount: _items.length,
          itemBuilder: (context, i) {
            final item = _items[i];
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: FCard(
                title: Text(item.content ?? "No Content"),
                subtitle: Text("Status: ${item.status ?? 'Unknown'}"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Assigned To: ${item.currentlyAssignedTo ?? 'None'}"),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
