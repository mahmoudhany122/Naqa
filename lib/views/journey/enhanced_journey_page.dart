import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/journey_viewmodel.dart';

class EnhancedJourneyPage extends StatelessWidget {
  final String userId;
  const EnhancedJourneyPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => JourneyViewModel(userId: userId),
      child: const _JourneyPageContent(),
    );
  }
}

class _JourneyPageContent extends StatefulWidget {
  const _JourneyPageContent();

  @override
  State<_JourneyPageContent> createState() => _JourneyPageContentState();
}

class _JourneyPageContentState extends State<_JourneyPageContent> {
  final _searchController = TextEditingController();
  final _textController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.greenAccent, Colors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (query) {
                      context.read<JourneyViewModel>().searchEntries(query);
                    },
                    decoration: InputDecoration(
                      hintText: 'البحث في اليوميات...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // Entries List
                Expanded(
                  child: Consumer<JourneyViewModel>(
                    builder: (context, viewModel, child) {
                      if (viewModel.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (viewModel.entries.isEmpty) {
                        return const Center(
                          child: Text(
                            'لا توجد مدخلات بعد\nابدأ بكتابة أول مدخل!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: viewModel.entries.length,
                        itemBuilder: (context, index) {
                          final entry = viewModel.entries[index];
                          return _buildEntryCard(context, entry, viewModel);
                        },
                      );
                    },
                  ),
                ),

                // Add Entry Section
                _buildAddEntrySection(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryCard(
      BuildContext context,
      Map<String, dynamic> entry,
      JourneyViewModel viewModel,
      ) {
    final timestamp = entry['timestamp'];
    final date = timestamp != null
        ? DateFormat('yyyy-MM-dd HH:mm').format(timestamp.toDate())
        : entry['createdAt'] ?? 'Unknown';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: null,
        borderRadius: 20,
        blur: 20,
        border: 2,
        linearGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.5)
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      date,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () => _showEditDialog(context, entry, viewModel),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteDialog(context, entry, viewModel),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                entry['text'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddEntrySection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.black.withOpacity(0.2),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              style: const TextStyle(color: Colors.white),
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'اكتب مدخل جديد...',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: () async {
              if (_textController.text.trim().isNotEmpty) {
                final success = await context
                    .read<JourneyViewModel>()
                    .addEntry(_textController.text);

                if (success) {
                  _textController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم إضافة المدخل بنجاح'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
      BuildContext context,
      Map<String, dynamic> entry,
      JourneyViewModel viewModel,
      ) {
    final controller = TextEditingController(text: entry['text']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل المدخل'),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              final success = await viewModel.updateEntry(
                entry['id'],
                controller.text,
              );

              Navigator.pop(context);

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم التعديل بنجاح'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context,
      Map<String, dynamic> entry,
      JourneyViewModel viewModel,
      ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المدخل'),
        content: const Text('هل أنت متأكد من حذف هذا المدخل؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              final success = await viewModel.deleteEntry(entry['id']);

              Navigator.pop(context);

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم الحذف بنجاح'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}