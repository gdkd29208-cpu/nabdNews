import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/app_state.dart';
import '../models/news_article.dart';
import '../widgets/ui_helpers.dart';

class NewsHubScreen extends StatefulWidget {
  const NewsHubScreen({
    super.key,
    required this.onOpenArticle,
    required this.onCompose,
  });

  final ValueChanged<NewsArticle> onOpenArticle;
  final VoidCallback onCompose;

  @override
  State<NewsHubScreen> createState() => _NewsHubScreenState();
}

class _NewsHubScreenState extends State<NewsHubScreen> {
  String _selectedCategory = 'الكل';
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    if (!state.isInitialized && state.news.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final filtered = state.filterNews(
      category: _selectedCategory,
      query: _query,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'مكتبة الأخبار',
            subtitle: 'فلترة حسب التصنيف والبحث داخل الأخبار المحلية والعالمية',
          ),
          const SizedBox(height: 18),
          TextField(
            onChanged: (value) => setState(() => _query = value),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'ابحث بعنوان، مصدر، أو كلمة مفتاحية',
            ),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final category in ['الكل', ...NewsArticle.categories])
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: _selectedCategory == category,
                      onSelected: (_) =>
                          setState(() => _selectedCategory = category),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                '${filtered.length} خبر',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: widget.onCompose,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('خبر جديد'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: filtered.isEmpty
                ? EmptyStateCard(
                    title: 'ماكو نتائج',
                    message:
                        state.lastError ??
                        'غيّر الفلتر أو جرّب كلمة بحث مختلفة.',
                  )
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final article = filtered[index];
                      return NewsCard(
                        article: article,
                        authorLabel: state.authorLabelFor(article),
                        onTap: () => widget.onOpenArticle(article),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key, required this.articleId});

  final int articleId;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final article = state.articleById(articleId);

    if (article == null) {
      return const GradientScaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: EmptyStateCard(
              title: 'الخبر غير موجود',
              message: 'قد يكون تم حذفه أو تعديل القائمة.',
            ),
          ),
        ),
      );
    }

    final canEdit = state.canEditArticle(article);
    final authorLabel = state.authorLabelFor(article);

    return GradientScaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الخبر'),
        actions: [
          if (canEdit)
            IconButton(
              tooltip: 'تعديل',
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => Directionality(
                      textDirection: TextDirection.rtl,
                      child: ArticleEditorScreen(existingArticle: article),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.edit_outlined),
            ),
          if (canEdit)
            IconButton(
              tooltip: 'حذف',
              onPressed: () async {
                final shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) => Directionality(
                    textDirection: TextDirection.rtl,
                    child: AlertDialog(
                      title: const Text('حذف الخبر'),
                      content: const Text('هل تريد حذف الخبر نهائيًا؟'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext, false),
                          child: const Text('إلغاء'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(dialogContext, true),
                          child: const Text('حذف'),
                        ),
                      ],
                    ),
                  ),
                );
                if (shouldDelete == true) {
                  final deleted = await state.deleteArticle(articleId);
                  if (!context.mounted) {
                    return;
                  }
                  if (deleted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم حذف الخبر بنجاح.')),
                    );
                  }
                }
              },
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F766E), Color(0xFF082F49)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      Chip(label: Text(article.category)),
                      Chip(
                        label: Text(
                          article.isScraped ? 'خبر عالمي' : 'خبر محلي',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$authorLabel • ${article.source}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.content,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.9,
                        color: Colors.white.withAlpha(230),
                      ),
                    ),
                    if (article.link != null && article.link!.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      FilledButton.tonalIcon(
                        onPressed: () async {
                          await Clipboard.setData(
                            ClipboardData(text: article.link!),
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تم نسخ رابط المصدر.'),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.link_outlined),
                        label: const Text('نسخ رابط المصدر'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleEditorScreen extends StatefulWidget {
  const ArticleEditorScreen({super.key, this.existingArticle});

  final NewsArticle? existingArticle;

  @override
  State<ArticleEditorScreen> createState() => _ArticleEditorScreenState();
}

class _ArticleEditorScreenState extends State<ArticleEditorScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _sourceController;
  late final TextEditingController _linkController;
  late final TextEditingController _imageController;
  late String _category;
  late bool _isBreaking;

  @override
  void initState() {
    super.initState();
    final article = widget.existingArticle;
    _titleController = TextEditingController(text: article?.title ?? '');
    _contentController = TextEditingController(text: article?.content ?? '');
    _sourceController = TextEditingController(text: article?.source ?? '');
    _linkController = TextEditingController(text: article?.link ?? '');
    _imageController = TextEditingController(text: article?.imageUrl ?? '');
    _category = article?.category ?? NewsArticle.categories.first;
    _isBreaking = article?.isBreaking ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _sourceController.dispose();
    _linkController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final currentUser = state.currentUser;

    return GradientScaffold(
      appBar: AppBar(
        title: Text(
          widget.existingArticle == null ? 'خبر جديد' : 'تعديل الخبر',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: currentUser == null
            ? const EmptyStateCard(
                title: 'تسجيل الدخول مطلوب',
                message: 'حتى تنشر خبرًا جديدًا لازم تسجل دخول أولاً.',
              )
            : Card(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.existingArticle == null
                            ? 'نموذج نشر الخبر'
                            : 'تحديث صياغة الخبر',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'عنوان الخبر',
                        ),
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        initialValue: _category,
                        items: [
                          for (final category in NewsArticle.categories)
                            DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _category = value);
                          }
                        },
                        decoration: const InputDecoration(labelText: 'التصنيف'),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _sourceController,
                        decoration: const InputDecoration(
                          labelText: 'المصدر أو اسم القسم',
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _linkController,
                        decoration: const InputDecoration(
                          labelText: 'رابط المصدر الخارجي',
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _imageController,
                        decoration: const InputDecoration(
                          labelText: 'رابط صورة (اختياري)',
                        ),
                      ),
                      const SizedBox(height: 14),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        value: _isBreaking,
                        onChanged: (value) =>
                            setState(() => _isBreaking = value),
                        title: const Text('خبر عاجل'),
                        subtitle: const Text(
                          'يتجه لقسم الأخبار اللافتة في الرئيسية.',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _contentController,
                        maxLines: 10,
                        decoration: const InputDecoration(
                          labelText: 'المحتوى الكامل',
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 18),
                      FilledButton.icon(
                        onPressed: state.isLoading
                            ? null
                            : () async {
                                final error = await state.saveArticle(
                                  existingArticle: widget.existingArticle,
                                  title: _titleController.text,
                                  content: _contentController.text,
                                  category: _category,
                                  source: _sourceController.text,
                                  link: _linkController.text,
                                  imageUrl: _imageController.text,
                                  isBreaking: _isBreaking,
                                );
                                if (!context.mounted) {
                                  return;
                                }
                                if (error != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error)),
                                  );
                                  return;
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      widget.existingArticle == null
                                          ? 'تم نشر الخبر بنجاح.'
                                          : 'تم تحديث الخبر بنجاح.',
                                    ),
                                  ),
                                );
                                Navigator.of(context).pop();
                              },
                        icon: const Icon(Icons.save_outlined),
                        label: Text(
                          widget.existingArticle == null
                              ? 'نشر الخبر'
                              : 'حفظ التعديلات',
                        ),
                      ),
                      if (state.isLoading) ...[
                        const SizedBox(height: 14),
                        const LinearProgressIndicator(),
                      ],
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
