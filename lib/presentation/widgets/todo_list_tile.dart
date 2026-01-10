import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luarsekolah/domain/entities/todo.dart';
import 'package:luarsekolah/presentation/controllers/todo_controllers.dart'; 
// Pastikan path ke TodoController sudah benar
//Widget untuk tampilkan todo item
// Fungsi helper untuk format waktu, diletakkan di luar kelas untuk menghindari error duplikasi.
String _formatRelative(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);
  if (difference.inSeconds < 60) return 'baru saja';
  if (difference.inMinutes < 60) return '${difference.inMinutes}m lalu';
  if (difference.inHours < 24) return '${difference.inHours}j lalu';
  if (difference.inDays < 7) return '${difference.inDays}h lalu';
  return '${date.day}/${date.month}';
}

class TodoListTile extends StatelessWidget {
  const TodoListTile({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  static const Color primaryGreen = Color(0xFF4CAF50);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Mendapatkan instance controller yang aktif
    final TodoController controller = Get.find<TodoController>(); 

    return InkWell(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        
        // Membungkus bagian yang perlu direaktifkan dengan Obx
        child: Obx( 
          () {
            // Mencari status terbaru dari item ini di dalam list reaktif Controller
            final currentTodo = controller.todos.firstWhereOrNull((t) => t.id == todo.id);
            // Menggunakan status terbaru, fallback ke status lama jika item tidak ditemukan
            final isCompleted = currentTodo?.completed ?? todo.completed;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: onToggle,
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                    child: Icon(
                      isCompleted // Gunakan status terbaru
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked,
                      key: ValueKey<bool>(isCompleted),
                      color: isCompleted ? primaryGreen : Colors.grey.shade400,
                      size: 24,
                    ),
                  ),
                  tooltip: isCompleted ? 'Tandai belum selesai' : 'Tandai selesai',
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.text,
                        style: theme.textTheme.titleMedium?.copyWith(
                          decoration: isCompleted ? TextDecoration.lineThrough : null, // Gunakan status terbaru
                          color: isCompleted ? Colors.grey.shade500 : Colors.black87, // Gunakan status terbaru
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Dibuat ${_formatRelative(todo.createdAt)} | Diubah ${_formatRelative(todo.updatedAt)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 24),
                  tooltip: 'Hapus todo',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
