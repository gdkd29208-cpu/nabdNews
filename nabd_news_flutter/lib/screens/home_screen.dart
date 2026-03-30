import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../models/news_article.dart';
import '../widgets/ui_helpers.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onOpenArticle,
    required this.onBrowseNews,
    required this.onCompose,
  });

  final ValueChanged<NewsArticle> onOpenArticle;
  final VoidCallback onBrowseNews;
  final VoidCallback onCompose;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final user = state.currentUser;

    if (!state.isInitialized && state.news.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.lastError != null && state.news.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
        child: EmptyStateCard(
          title: 'تعذر تحميل الأخبار',
          message: state.lastError!,
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeroBanner(
            userName: user?.name,
            onBrowseNews: onBrowseNews,
            onCompose: onCompose,
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              StatTile(
                label: 'إجمالي الأخبار',
                value: '${state.news.length}',
                icon: Icons.article_outlined,
              ),
              StatTile(
                label: 'أخبار عالمية',
                value: '${state.globalNews.length}',
                icon: Icons.public_outlined,
              ),
              StatTile(
                label: 'كروبات صحفية',
                value: '${state.groups.length}',
                icon: Icons.groups_outlined,
              ),
            ],
          ),
          const SizedBox(height: 28),
          const SectionTitle(
            title: 'الأخبار العالمية',
            subtitle: 'آخر المواد المسحوبة والمعالجة بنفس منطق مشروع Laravel',
          ),
          const SizedBox(height: 14),
          ...state.globalNews.map(
            (article) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: NewsCard(
                article: article,
                authorLabel: state.authorLabelFor(article),
                onTap: () => onOpenArticle(article),
                compact: true,
              ),
            ),
          ),
          const SizedBox(height: 18),
          SectionTitle(
            title: 'أخبار محلية مميزة',
            subtitle: 'مواد يكتبها المستخدمون والصحفيون داخل التطبيق',
            trailing: TextButton(
              onPressed: onBrowseNews,
              child: const Text('عرض الكل'),
            ),
          ),
          const SizedBox(height: 14),
          ...state.featuredNews.map(
            (article) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: NewsCard(
                article: article,
                authorLabel: state.authorLabelFor(article),
                onTap: () => onOpenArticle(article),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({
    required this.userName,
    required this.onBrowseNews,
    required this.onCompose,
  });

  final String? userName;
  final VoidCallback onBrowseNews;
  final VoidCallback onCompose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF155E75), Color(0xFF082F49)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userName == null
                ? 'نبض نيوز'
                : 'أهلًا ${userName!.split(' ').first}',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Text(
            'نسخة Flutter من مشروع الأخبار: رئيسية، أخبار، تفاصيل، ملف شخصي، وكروبات صحفيين ضمن واجهة واحدة.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withAlpha(230),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                onPressed: onBrowseNews,
                icon: const Icon(Icons.newspaper_outlined),
                label: const Text('تصفح الأخبار'),
              ),
              OutlinedButton.icon(
                onPressed: onCompose,
                icon: const Icon(Icons.edit_note_outlined),
                label: const Text('اكتب خبر'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
