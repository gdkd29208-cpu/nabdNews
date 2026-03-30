import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../widgets/ui_helpers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return GradientScaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ارجع لغرفة الأخبار',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'نسخة Flutter هذه تستخدم حسابات تجريبية محلية حتى تتأكد من التجربة قبل ربط API.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني',
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'كلمة المرور'),
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: () {
                    final success = state.login(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    if (!success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('بيانات الدخول غير صحيحة.'),
                        ),
                      );
                      return;
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('دخول'),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 12),
                Text(
                  'حسابات تجريبية',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const Text('editor@nabd.app / admin123'),
                const SizedBox(height: 6),
                const Text('sara@nabd.app / journalist123'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _adminSecretController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _adminSecretController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return GradientScaffold(
      appBar: AppBar(title: const Text('إنشاء حساب')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ابدأ حسابك الصحفي',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'الفكرة هنا مطابقة لتجربة Laravel: تسجيل، بروفايل، ثم كتابة أخبار والانضمام للكروبات.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'الاسم الكامل'),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني',
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'كلمة المرور'),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _confirmController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'تأكيد كلمة المرور',
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _adminSecretController,
                  decoration: const InputDecoration(
                    labelText: 'رمز الإدارة (اختياري للتجربة)',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'للتجربة المحلية فقط: رمز الإدارة هو ${AppState.demoAdminSecret}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white60),
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: () {
                    final error = state.register(
                      name: _nameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      confirmPassword: _confirmController.text,
                      adminSecret: _adminSecretController.text,
                    );
                    if (error != null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(error)));
                      return;
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('إنشاء الحساب'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
