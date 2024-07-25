import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorados_app/config/theme/theme_provider.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';
import 'package:tutorados_app/widgets/widgets.dart';

class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final isDarkMode = ref.watch(isDarkModeProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(colors.surface.value),
        leading: IconButton(
            onPressed: () {
              ref.read(isDarkModeProvider.notifier).update((state) => !state);
            },
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode)),
      ),
      endDrawer: const SideMenu(),
      body: const HomeAdminView(),
    );
  }
}

class HomeAdminView extends ConsumerWidget {
  const HomeAdminView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authProvider);
    final colors = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hola, ${userState.user?.name}',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                    color: Color(colors.onSurface.value))),
            const SizedBox(
              height: 50,
            ),
            Text(
              'Tutorias',
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                  color: Color(colors.secondary.value)),
            ),
            const SizedBox(
              height: 20,
            ),
            const _SectionCards(),
          ],
        ),
      ),
    );
  }
}

class _SectionCards extends ConsumerWidget {
  const _SectionCards();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 370,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        children: [
          GestureDetector(
            child: const CardOption(
              title: 'Mis tutorados',
              description: '...',
              icon: Icons.group,
            ),
            onTap: () {
              context.push('/tutored');
            },
          ),
          GestureDetector(
            child: const CardOption(
              title: 'Tutores',
              description: '...',
              icon: Icons.group,
            ),
            onTap: () {
              context.push('/tutors');
            },
          ),
        ],
      ),
    );
  }
}
