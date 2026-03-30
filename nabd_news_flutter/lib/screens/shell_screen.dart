import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../models/news_article.dart';
import '../widgets/ui_helpers.dart';
import 'auth_screens.dart';
import 'home_screen.dart';
import 'news_screens.dart';
import 'profile_screen.dart';

class NabdShell extends StatefulWidget {
  const NabdShell({super.key});

  @override
  State<NabdShell> createState() => _NabdShellState();
}

class _NabdShellState extends State<NabdShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final currentUser = state.currentUser;

    final screens = [
      HomeScreen(
        onOpenArticle: _openArticle,
        onBrowseNews: () => setState(() => _selectedIndex = 1),
        onCompose: _openComposer,
      ),
      NewsHubScreen(onOpenArticle: _openArticle, onCompose: _openComposer),
      ProfileScreen(
        onOpenLogin: _openLogin,
        onOpenRegister: _openRegister,
        onOpenArticle: _openArticle,
      ),
    ];

    return GradientScaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          if (currentUser == null)
            TextButton(onPressed: _openLogin, child: const Text('دخول'))
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () => setState(() => _selectedIndex = 2),
                child: CircleAvatar(
                  backgroundColor: const Color(0xFF17324A),
                  child: Text(currentUser.initials),
                ),
              ),
            ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: screens),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openComposer,
        icon: const Icon(Icons.edit_note_outlined),
        label: const Text('خبر جديد'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.newspaper_outlined),
            selectedIcon: Icon(Icons.newspaper),
            label: 'الأخبار',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'الملف',
          ),
        ],
      ),
    );
  }

  Future<void> _openArticle(NewsArticle article) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => Directionality(
          textDirection: TextDirection.rtl,
          child: ArticleDetailScreen(articleId: article.id),
        ),
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openComposer() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const Directionality(
          textDirection: TextDirection.rtl,
          child: ArticleEditorScreen(),
        ),
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openLogin() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const Directionality(
          textDirection: TextDirection.rtl,
          child: LoginScreen(),
        ),
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openRegister() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const Directionality(
          textDirection: TextDirection.rtl,
          child: RegisterScreen(),
        ),
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }
}

const _titles = <String>['الرئيسية', 'الأخبار', 'الملف الشخصي'];
