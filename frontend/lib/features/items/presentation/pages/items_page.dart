// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forui/forui.dart';
import 'package:frontend/core/error/common_error.dart';
import 'package:frontend/core/providers/providers.dart';
import 'package:frontend/features/auth/data/models/user_model.dart';
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
    final user = ref.watch(authNotifierProvider).user;

    if (state.getUserItemsStatus == CommonStatus.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final items = state.userItems;

    return Scaffold(
      body: FScaffold(
        header: _appBar(context, user),
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
                      user?.role == "Receiver"
                          ? "Assigned By: ${item.uid?.name}"
                          : "Assigned To: ${item.currentlyAssignedTo?.name ?? 'None'}",
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: PopupMenuButton(
                        icon: const Icon(FIcons.ellipsis),
                        itemBuilder: (_) => [
                          if (user?.role == "Receiver") ...[
                            PopupMenuItem(
                              child: const Text("Reassign"),
                              onTap: () async {
                                Future.delayed(
                                  const Duration(milliseconds: 0),
                                  () => showDialog(
                                    context: context,
                                    builder: (ctx) => FDialog(
                                      title: const Text(
                                        "Confirm Re-assignment",
                                      ),
                                      body: const Text(
                                        "Are you sure you want to assign this to another receiver?",
                                      ),
                                      actions: [
                                        FButton(
                                          onPress: () =>
                                              Navigator.of(ctx).pop(),
                                          child: const Text("Cancel"),
                                        ),
                                        FButton(
                                          onPress: () async {
                                            Navigator.of(ctx).pop();
                                            await ref
                                                .read(
                                                  itemNotifierProvider.notifier,
                                                )
                                                .changeAssignmentToOtherReceiver(
                                                  itemID: item.id ?? "",
                                                );
                                          },
                                          child: const Text("Yes"),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            PopupMenuItem(
                              child: const Text("Completed"),
                              onTap: () async {
                                await ref
                                    .read(itemNotifierProvider.notifier)
                                    .updateItem(
                                      itemID: item.id ?? "",
                                      updatedItem: item.copyWith(
                                        status: "completed",
                                      ),
                                    );
                              },
                            ),
                          ] else
                            ...[],
                        ],
                      ),
                    ),
                  ],
                ),
              )

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

  FHeader _appBar(BuildContext context, UserModel? user) {
    return FHeader(
      title: Text("Items"),
      suffixes: [
        FPopoverMenu(
          menuAnchor: Alignment.topRight,
          childAnchor: Alignment.bottomRight,
          menu: [
            FItemGroup(
              children: [
                FItem(
                  prefix: const Icon(FIcons.user),
                  title: Text("${user?.name ?? ""} - ${user?.role ?? ""}"),
                ),
                FItem(
                  prefix: const Icon(FIcons.logOut),
                  title: const Text('Log out'),
                  onPress: () {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return FDialog(
                          title: const Text("Confirm Logout"),
                          body: const Text("Are you sure you want to log out?"),
                          actions: [
                            FButton(
                              onPress: () => Navigator.of(ctx).pop(),
                              child: const Text("Cancel"),
                            ),
                            FButton(
                              onPress: () async {
                                Navigator.of(ctx).pop();
                                await ref
                                    .read(authNotifierProvider.notifier)
                                    .logout();
                                if (!mounted) return;
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  "/login",
                                  (route) => false,
                                );
                              },
                              child: const Text("Log out"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
          builder: (context, controller, child) => FHeaderAction(
            icon: const Icon(FIcons.ellipsis),
            onPress: controller.toggle,
          ),
        ),
      ],
    );
  }
}
