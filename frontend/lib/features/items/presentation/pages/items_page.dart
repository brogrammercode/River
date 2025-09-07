import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forui/forui.dart';
import 'package:frontend/core/error/common_error.dart';
import 'package:frontend/core/providers/providers.dart';
import 'package:frontend/features/items/data/models/item_model.dart';

class ItemsPage extends ConsumerStatefulWidget {
  const ItemsPage({super.key});

  @override
  ConsumerState<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends ConsumerState<ItemsPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(itemNotifierProvider.notifier).getUserItems();
    });
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return FDialog(
          title: const Text("Add Item"),
          body: FTextFormField(
            controller: _controller,
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
              onPress: () async {
                final content = _controller.text.trim();
                if (content.isNotEmpty) {
                  final newItem = ItemModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    content: content,
                    status: "New",
                  );
                  await ref
                      .read(itemNotifierProvider.notifier)
                      .createItem(item: newItem);
                  // ignore: use_build_context_synchronously
                  Navigator.of(ctx).pop();
                  _controller.clear();
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
    final state = ref.watch(itemNotifierProvider);

    if (state.getUserItemsStatus == CommonStatus.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final items = state.userItems;

    return Scaffold(
      body: FScaffold(
        header: const FHeader(title: Text("Items")),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 0.w),
          itemCount: items.length,
          itemBuilder: (context, i) {
            final item = items[i];
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: FCard(
                title: Text(item.content ?? "No Content"),
                subtitle: Text("Status: ${item.status ?? 'Unknown'}"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Assigned To: ${item.currentlyAssignedTo?.name ?? 'None'}",
                    ),
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
