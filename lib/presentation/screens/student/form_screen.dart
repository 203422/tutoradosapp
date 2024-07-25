import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';
import 'package:tutorados_app/widgets/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';

class FormScreen extends ConsumerWidget {
  const FormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codeState = ref.watch(codeProvider);
    final formState = ref.watch(formProvider);
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(colors.surface.value),
          iconTheme: IconThemeData(color: Color(colors.onSurface.value)),
        ),
        backgroundColor: Color(colors.surface.value),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Registro de tutorados',
                      style: TextStyle(
                          color: Color(colors.secondary.value),
                          fontSize: 28,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(
                    height: 10,
                  ),
                  (codeState.tutor != null)
                      ? Text(
                          'Tutor: ${codeState.tutor?.name} ${codeState.tutor?.lastName}',
                          style: TextStyle(
                              color: Color(colors.onSurface.value),
                              fontSize: 16,
                              fontWeight: FontWeight.w500))
                      : Container(),
                  const SizedBox(
                    height: 10,
                  ),
                  formState.section == 0
                      ? Container()
                      : LinearPercentIndicator(
                          animation: true,
                          animateFromLastPercent: true,
                          animationDuration: 1000,
                          lineHeight: 6,
                          percent: formState.loadingBar,
                          progressColor: Color(colors.primary.value),
                          backgroundColor: Color(colors.tertiary.value),
                          barRadius: const Radius.circular(10),
                          trailing: Text(
                            '${formState.percentageCompleted}%',
                            style: TextStyle(
                                color: Color(colors.onSurface.value),
                                fontWeight: FontWeight.w700),
                          ),
                        )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Color(colors.primaryContainer.value),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                child: const FormView(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FormView extends ConsumerWidget {
  const FormView({super.key});

  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(formProvider);
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: SingleChildScrollView(child: renderView(formState.section)),
      ),
    );
  }

  renderView(int section) {
    switch (section) {
      case 0:
        return const AssignTutor();
      case 1:
        return const FirstSectionOfStudentData();
      case 2:
        return const SecondSectionOfStudentData();
      case 3:
        return const ContactInformationSection();
      case 4:
        return const MedicalDataSection();
      case 5:
        return const AcademicDataSection();
      case 6:
        return const SocioeconomicDataSection();
      case 7:
        return const UploadPhoto();
      default:
        return const FormCompletedFeedback();
    }
  }
}
