import 'package:flutter/material.dart';

import '../models/news_article.dart';

class GradientScaffold extends StatelessWidget {
  const GradientScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF06131E), Color(0xFF0A1B2B), Color(0xFF102132)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: SafeArea(child: body),
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(
                  subtitle!,
                  style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ],
          ),
        ),
        ...(trailing == null ? const <Widget>[] : <Widget>[trailing!]),
      ],
    );
  }
}

class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF102132),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF1E3A54)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.article,
    required this.authorLabel,
    required this.onTap,
    this.compact = false,
  });

  final NewsArticle article;
  final String authorLabel;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.secondary;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(compact ? 18 : 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _InfoPill(
                    label: article.category,
                    icon: _iconForCategory(article.category),
                    color: accent,
                  ),
                  _InfoPill(
                    label: article.isScraped ? 'مسحوب' : 'محلي',
                    icon: article.isScraped ? Icons.public : Icons.edit_note,
                    color: const Color(0xFF38BDF8),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                article.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                article.excerpt,
                maxLines: compact ? 3 : 4,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Icon(
                    article.isScraped ? Icons.language : Icons.person_outline,
                    size: 18,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      authorLabel,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _relativeTime(article.publishedAt),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.white54),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({
    super.key,
    required this.title,
    required this.message,
    this.action,
  });

  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white70,
                height: 1.5,
              ),
            ),
            if (action != null) ...[const SizedBox(height: 18), action!],
          ],
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF17324A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

IconData _iconForCategory(String category) {
  switch (category) {
    case 'سياسة':
      return Icons.account_balance_outlined;
    case 'رياضة':
      return Icons.sports_soccer_outlined;
    case 'اقتصاد':
      return Icons.trending_up_outlined;
    case 'تكنولوجيا':
      return Icons.memory_outlined;
    case 'ثقافة':
      return Icons.auto_stories_outlined;
    default:
      return Icons.public_outlined;
  }
}

String _relativeTime(DateTime dateTime) {
  final diff = DateTime.now().difference(dateTime);
  if (diff.inMinutes < 60) {
    return 'منذ ${diff.inMinutes} دقيقة';
  }
  if (diff.inHours < 24) {
    return 'منذ ${diff.inHours} ساعة';
  }
  return 'منذ ${diff.inDays} يوم';
}
