import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../models/journalist_group.dart';
import '../models/news_article.dart';
import '../widgets/ui_helpers.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.onOpenLogin,
    required this.onOpenRegister,
    required this.onOpenArticle,
  });

  final VoidCallback onOpenLogin;
  final VoidCallback onOpenRegister;
  final ValueChanged<NewsArticle> onOpenArticle;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final user = state.currentUser;

    if (!state.isInitialized && state.news.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (user == null) {
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
        child: EmptyStateCard(
          title: 'ملفك الشخصي',
          message:
              'سجل دخولك حتى تعدل بياناتك، تنشر أخبارك الخاصة، وتنشئ كروب صحفي بكلمة مرور مثل نسخة Laravel.',
          action: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton(
                onPressed: onOpenLogin,
                child: const Text('تسجيل الدخول'),
              ),
              OutlinedButton(
                onPressed: onOpenRegister,
                child: const Text('إنشاء حساب'),
              ),
            ],
          ),
        ),
      );
    }

    final myGroups = state.groupsForUser(user.id);
    final discoverGroups = state.groups
        .where((group) => !group.isMember)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileHeaderCard(
            onEditProfile: () => _showEditProfileDialog(context),
            onLogout: () async => state.logout(),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              StatTile(
                label: 'أخباري',
                value: '${state.myArticles.length}',
                icon: Icons.edit_document,
              ),
              StatTile(
                label: 'كروباتي',
                value: '${myGroups.length}',
                icon: Icons.groups_2_outlined,
              ),
              StatTile(
                label: 'صفتي',
                value: user.isAdmin ? 'Admin' : 'صحفي',
                icon: Icons.verified_user_outlined,
              ),
            ],
          ),
          const SizedBox(height: 28),
          const SectionTitle(
            title: 'أخباري المنشورة',
            subtitle: 'آخر المواد التي نشرتها من خلال التطبيق',
          ),
          const SizedBox(height: 14),
          if (state.myArticles.isEmpty)
            const EmptyStateCard(
              title: 'ما عندك أخبار بعد',
              message: 'استخدم زر "خبر جديد" من الأسفل حتى تبدأ النشر.',
            )
          else
            ...state.myArticles.map(
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
          const SizedBox(height: 24),
          SectionTitle(
            title: 'كروبات الصحفيين',
            subtitle: 'إنشاء كروب خاص أو الانضمام باستخدام كلمة المرور',
            trailing: Wrap(
              spacing: 8,
              children: [
                TextButton.icon(
                  onPressed: () => _showCreateGroupDialog(context),
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('إنشاء'),
                ),
                TextButton.icon(
                  onPressed: () => _showJoinGroupDialog(context),
                  icon: const Icon(Icons.login_outlined),
                  label: const Text('انضمام'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (myGroups.isEmpty)
            const EmptyStateCard(
              title: 'ما منضم لأي كروب',
              message: 'أنشئ كروب جديد أو انضم إلى كروب موجود بكلمة المرور.',
            )
          else
            ...myGroups.map((group) => _GroupCard(group: group)),
          if (discoverGroups.isNotEmpty) ...[
            const SizedBox(height: 18),
            const SectionTitle(
              title: 'كروبات متاحة',
              subtitle: 'تحتاج فقط كلمة المرور حتى تدخلها',
            ),
            const SizedBox(height: 14),
            ...discoverGroups.map((group) => _GroupCard(group: group)),
          ],
          if (state.isLoading) ...[
            const SizedBox(height: 14),
            const LinearProgressIndicator(),
          ],
        ],
      ),
    );
  }

  Future<void> _showEditProfileDialog(BuildContext context) async {
    final state = AppScope.of(context);
    final user = state.currentUser;
    if (user == null) {
      return;
    }

    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('تعديل الملف الشخصي'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'الاسم'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'البريد'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () async {
                final error = await state.updateProfile(
                  name: nameController.text,
                  email: emailController.text,
                );
                if (!context.mounted) {
                  return;
                }
                if (error != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(error)));
                  return;
                }
                Navigator.pop(dialogContext);
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );

    nameController.dispose();
    emailController.dispose();
  }

  Future<void> _showCreateGroupDialog(BuildContext context) async {
    final state = AppScope.of(context);
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('إنشاء كروب صحفي'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'اسم الكروب'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'الوصف'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'كلمة المرور'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirmController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'تأكيد كلمة المرور',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () async {
                final error = await state.createGroup(
                  name: nameController.text,
                  description: descriptionController.text,
                  password: passwordController.text,
                  confirmPassword: confirmController.text,
                );
                if (!context.mounted) {
                  return;
                }
                if (error != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(error)));
                  return;
                }
                Navigator.pop(dialogContext);
              },
              child: const Text('إنشاء'),
            ),
          ],
        ),
      ),
    );

    nameController.dispose();
    descriptionController.dispose();
    passwordController.dispose();
    confirmController.dispose();
  }

  Future<void> _showJoinGroupDialog(BuildContext context) async {
    final state = AppScope.of(context);
    final user = state.currentUser;
    if (user == null) {
      return;
    }

    final availableGroups = state.groups
        .where((group) => !group.isMember)
        .toList();
    if (availableGroups.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ماكو كروبات إضافية متاحة حالياً.')),
      );
      return;
    }

    final passwordController = TextEditingController();
    int selectedGroupId = availableGroups.first.id;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setStateDialog) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('انضمام إلى كروب'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  initialValue: selectedGroupId,
                  items: [
                    for (final group in availableGroups)
                      DropdownMenuItem<int>(
                        value: group.id,
                        child: Text(group.name),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setStateDialog(() => selectedGroupId = value);
                    }
                  },
                  decoration: const InputDecoration(labelText: 'الكروب'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'كلمة المرور'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('إلغاء'),
              ),
              FilledButton(
                onPressed: () async {
                  final error = await state.joinGroup(
                    groupId: selectedGroupId,
                    password: passwordController.text,
                  );
                  if (!context.mounted) {
                    return;
                  }
                  if (error != null) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(error)));
                    return;
                  }
                  Navigator.pop(dialogContext);
                },
                child: const Text('انضمام'),
              ),
            ],
          ),
        ),
      ),
    );

    passwordController.dispose();
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({
    required this.onEditProfile,
    required this.onLogout,
  });

  final VoidCallback onEditProfile;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final user = state.currentUser!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: [Color(0xFF082F49), Color(0xFF0F766E)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white24,
            child: Text(
              user.initials,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            user.name,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            '${user.email} • ${user.roleLabel}',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.tonal(
                onPressed: onEditProfile,
                child: const Text('تعديل البيانات'),
              ),
              OutlinedButton(
                onPressed: onLogout,
                child: const Text('تسجيل الخروج'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.group});

  final JournalistGroup group;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                group.name,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              if (group.description != null) ...[
                const SizedBox(height: 10),
                Text(
                  group.description!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ],
              const SizedBox(height: 14),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  Chip(label: Text('المالك: ${group.ownerName}')),
                  Chip(label: Text('${group.memberCount} أعضاء')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
