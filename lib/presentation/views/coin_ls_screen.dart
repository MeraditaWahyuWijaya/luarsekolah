import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luarsekolah/presentation/controllers/todo_controllers.dart';
import 'package:luarsekolah/domain/entities/todo.dart';
import 'package:luarsekolah/presentation/widgets/todo_list_tile.dart';

extension _ColorShade on Color {
  Color darken({double amount = .2}) {
    final hsl = HSLColor.fromColor(this);
    final hslDark =
        hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}

class TodoDashboardPage extends StatelessWidget {
  const TodoDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TodoController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat ulang dari Firestore',
            onPressed: controller.refreshTodos,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_task),
        onPressed: () => _openCreateSheet(context, controller),
        label: const Text('Tambah Todo'),
      ),
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              if (controller.isLoading.value)
                const LinearProgressIndicator(minHeight: 2),
              if (controller.errorMessage.value != null)
                _ErrorBanner(message: controller.errorMessage.value!),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: _AnalyticsHeader(controller: controller),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: _FilterChips(controller: controller),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.refreshTodos,
                  child: Builder(
                    builder: (context) {
                      final todos = controller.filteredTodos;
                      if (todos.isEmpty && !controller.isLoading.value) {
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 120),
                            Center(
                              child: Text(
                                'Belum ada todo. Tambahkan tugas baru!',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        );
                      }
                      return ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                        itemBuilder: (context, index) {
                          final todo = todos[index];
                          return TodoListTile(
                            todo: todo,
                            onToggle: () => controller.toggleTodo(todo.id),
                            onDelete: () => _confirmDelete(context, todo),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemCount: todos.length,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openCreateSheet(
      BuildContext context, TodoController controller) async {
    final textController = TextEditingController();

    final result = await Get.bottomSheet<String>(
      Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          top: 16,
        ),
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Buat Tugas Baru',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Get.back(),
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  controller: textController,
                  autofocus: true,
                  maxLength: 80,
                  decoration: InputDecoration(
                    labelText: 'Judul Tugas',
                    hintText: 'Cth: Berenang',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    counterText: '',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () {
                      final isSaving = controller.isLoading.value;
                      return FilledButton.icon(
                        onPressed: isSaving
                            ? null
                            : () {
                                final title = textController.text.trim();
                                if (title.isEmpty) {
                                  Get.snackbar('Perhatian',
                                      'Judul tugas tidak boleh kosong.',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.orange.shade400,
                                      colorText: Colors.white);
                                  return;
                                }
                                Get.back(result: title);
                              },
                        icon: isSaving
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.check_circle_outline),
                        label: Text(
                          isSaving ? 'Memproses...' : 'SIMPAN TUGAS',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (result != null) {
      await controller.addTodo(result);
    }
  }

  Future<void> _confirmDelete(BuildContext context, Todo todo) async {
    final controller = Get.find<TodoController>();
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Hapus Todo'),
        content: Text('Apakah yakin ingin menghapus todo:\n"${todo.text}"?'),
        actions: [
          TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Hapus')),
        ],
      ),
    );

    if (confirm == true) await controller.deleteTodo(todo.id);
  }
}

/// ================= Internal Widgets =================

class _AnalyticsHeader extends StatelessWidget {
  const _AnalyticsHeader({required this.controller});
  final TodoController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: _MetricCard(
              label: 'Total',
              value: controller.todos.length.toString(),
              icon: Icons.list_alt,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _MetricCard(
              label: 'Selesai',
              value: controller.completedCount.toString(),
              icon: Icons.check_circle,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _MetricCard(
              label: 'Progress',
              value: '${(controller.completionRate * 100).toStringAsFixed(0)}%',
              icon: Icons.trending_up,
              color: Colors.purple,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color),
        const SizedBox(height: 12),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold, color: color.darken()),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ]),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.controller});
  final TodoController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Wrap(
        spacing: 12,
        runSpacing: 8,
        children: TodoFilter.values.map((filter) {
          final selected = controller.filter.value == filter;
          return FilterChip(
            label: Text(_label(filter)),
            selected: selected,
            onSelected: (_) => controller.setFilter(filter),
          );
        }).toList(),
      ),
    );
  }

  String _label(TodoFilter filter) {
    switch (filter) {
      case TodoFilter.all:
        return 'Semua';
      case TodoFilter.completed:
        return 'Selesai';
      case TodoFilter.pending:
        return 'Belum Selesai';
    }
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}
