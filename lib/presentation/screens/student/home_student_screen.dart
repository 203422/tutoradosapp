import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorados_app/config/theme/theme_provider.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';
import 'package:tutorados_app/widgets/widgets.dart';

class HomeStudentScreen extends ConsumerWidget {
  const HomeStudentScreen({super.key});

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
      body: const HomeStudentView(),
    );
  }
}

class HomeStudentView extends ConsumerWidget {
  const HomeStudentView({super.key});

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
            const SectionTutoring(),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Otros',
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                  color: Color(colors.secondary.value)),
            ),
            const SizedBox(
              height: 20,
            ),
            const SectionOthers(),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTutoring extends ConsumerWidget {
  const SectionTutoring({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 390,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        children: [
          const CardOption(
            title: 'Registro',
            description: 'Tutoría individual',
            icon: Icons.person,
          ),
          const CardOption(
            title: 'Registro',
            description: 'Tutoría Grupal',
            icon: Icons.group,
          ),
          GestureDetector(
            onTap: () {
              context.push('/form');
            },
            child: const CardOption(
              title: 'Registro',
              description: 'Tutorados',
              icon: Icons.person_add_alt_1,
            ),
          ),
          const CardOption(
            title: 'Cronograma',
            description: 'Plan de acción tutorial',
            icon: Icons.calendar_month,
          ),
        ],
      ),
    );
  }
}

class SectionOthers extends StatelessWidget {
  const SectionOthers({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        children: const [
          CardOption(
              title: 'Diagnostico',
              description: 'Test estilos de aprendizaje',
              icon: Icons.checklist_rtl)
        ],
      ),
    );
  }
}
