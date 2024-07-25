import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorados_app/presentation/providers/auth_providers/auth_provider.dart';
import 'package:flutter/services.dart';

class SideMenu extends ConsumerWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authProvider);
    final colors = Theme.of(context).colorScheme;
    return NavigationDrawer(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 300, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () =>
                  {_copyTutorInfoToClipboard(userState.user?.id, context)},
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${userState.user?.id}',
                    style: TextStyle(
                        color: Color(colors.secondary.value),
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.copy,
                    color: Color(colors.secondary.value),
                    size: 16,
                  )
                ],
              ),
            ),
            Text(
              '${userState.user?.name} ${userState.user?.lastName}',
              style:
                  TextStyle(fontSize: 16, color: Color(colors.onSurface.value)),
            ),
            Text(
              '${userState.user?.email}',
              style:
                  TextStyle(fontSize: 16, color: Color(colors.onSurface.value)),
            ),
          ],
        ),
      ),
      userState.user?.role == 'Administrador'
          ? Container()
          : Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
              child: ElevatedButton(
                onPressed: () {
                  context.push('/student/profile/${userState.user?.id}');
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Color(colors.primaryContainer.value),
                    foregroundColor: Color(colors.onPrimaryContainer.value)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Perfil',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 10, 10),
        child: ElevatedButton(
          onPressed: () {
            ref.read(authProvider.notifier).logout();
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              backgroundColor: Color(colors.primary.value),
              foregroundColor: Color(colors.onPrimary.value)),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Salir',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ),
    ]);
  }

  void _copyTutorInfoToClipboard(String? code, BuildContext context) {
    String clipboardText = "$code";
    Clipboard.setData(ClipboardData(text: clipboardText));
  }
}
