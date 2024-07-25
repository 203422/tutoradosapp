import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorados_app/config/config.dart';
import 'package:tutorados_app/entities/entities.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';

class StudentScreen extends ConsumerWidget {
  void showDialogInfo(BuildContext context, String pathFile) {
    showDialog(
        context: context,
        builder: (context) {
          return _DocInfo(
            studentId: studentId,
            filePath: pathFile,
          );
        });
  }

  final String studentId;

  const StudentScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentState = ref.watch(studentProvider(studentId));
    final colors = Theme.of(context).colorScheme;

    ref.listen(studentProvider(studentId), (previous, next) {
      if (next.isFileDownloaded && next.pathFile.isNotEmpty) {
        showDialogInfo(context, next.pathFile);
      }
    });

    ref.listen(studentProvider(studentId), (previous, next) {
      if (next.isStudentDeleted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.message)));
        context.go('/tutor');
      }
    });

    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'pdf',
            icon: studentState.pdfIsDownloading
                ? CircularProgressIndicator(
                    color: Color(colors.onPrimary.value),
                    strokeWidth: 2,
                  )
                : Icon(
                    Icons.download,
                    color: Color(colors.onPrimary.value),
                  ),
            onPressed: () {
              ref.read(studentProvider(studentId).notifier).getFile('pdf');
            },
            label: studentState.pdfIsDownloading
                ? Container()
                : Text(
                    'PDF',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(colors.onPrimary.value),
                    ),
                  ),
            backgroundColor: Color(colors.primary.value),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton.extended(
            heroTag: 'csv',
            icon: studentState.csvIsDownloading
                ? CircularProgressIndicator(
                    color: Color(colors.onPrimary.value),
                    strokeWidth: 2,
                  )
                : Icon(
                    Icons.download,
                    color: Color(colors.onPrimary.value),
                  ),
            onPressed: () {
              ref.read(studentProvider(studentId).notifier).getFile('csv');
            },
            label: studentState.csvIsDownloading
                ? Container()
                : Text(
                    'CSV',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(colors.onPrimary.value),
                    ),
                  ),
            backgroundColor: Color(colors.primary.value),
          ),
        ],
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: const Color(0xFFffffff),
                        actionsAlignment: MainAxisAlignment.center,
                        title:
                            const Text('Eliminar', textAlign: TextAlign.center),
                        content: const Text(
                          '¿Estás seguro de eliminar al alumno?',
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(colors.primary.value),
                                foregroundColor: Color(colors.onPrimary.value)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(colors.tertiary.value),
                              foregroundColor: Color(colors.onTertiary.value),
                            ),
                            onPressed: () {
                              ref
                                  .read(studentProvider(studentId).notifier)
                                  .deleteStudent();
                            },
                            child: const Text('Eliminar'),
                          ),
                        ],
                      );
                    });
                //
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: studentState.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : StudentView(
              student: studentState.student,
            ),
    );
  }
}

class _DocInfo extends ConsumerWidget {
  final String studentId;
  final String filePath;
  const _DocInfo({required this.studentId, required this.filePath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    return AlertDialog(
        title: const Text('Archivo descargado'),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton.icon(
              onPressed: () {
                ref.read(studentProvider(studentId).notifier).closeFileInfo();
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.check, color: Color(colors.secondary.value)),
              label: Text(
                'Aceptar',
                style: TextStyle(color: Color(colors.secondary.value)),
              )),
          TextButton.icon(
              onPressed: () {
                ref.read(studentProvider(studentId).notifier).openFile();
                ref.read(studentProvider(studentId).notifier).closeFileInfo();
                Navigator.of(context).pop();
              },
              icon:
                  Icon(Icons.open_in_new, color: Color(colors.secondary.value)),
              label: Text(
                'Abrir',
                style: TextStyle(color: Color(colors.secondary.value)),
              ))
        ],
        content: SizedBox(
          width: double.maxFinite,
          height: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ruta del archivo:',
                style: TextStyle(
                    fontSize: 16, color: Color(colors.secondary.value)),
              ),
              Text(
                filePath,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ));
  }
}

class StudentView extends StatelessWidget {
  final Student? student;
  const StudentView({super.key, this.student});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderContainer(
              image: student?.image ?? 'Sin fotografía',
              studentId: student?.studentEnrollment ?? 'Sin id',
              name: student?.name ?? 'nombre',
              lastName: student?.lastName ?? 'apellido',
              career: student?.career ?? 'carrera',
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              'Datos del alumno',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(colors.secondary.value)),
            ),
            const SizedBox(
              height: 20,
            ),
            StudentData(student: student),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Contacto',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(colors.secondary.value)),
            ),
            const SizedBox(
              height: 20,
            ),
            ContactData(student: student),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Datos médicos',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(colors.secondary.value)),
            ),
            const SizedBox(
              height: 20,
            ),
            MedicalData(student: student),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Datos acádemicos',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(colors.secondary.value)),
            ),
            const SizedBox(
              height: 20,
            ),
            AcademicData(student: student),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Datos socioeconómicos',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(colors.secondary.value)),
            ),
            const SizedBox(
              height: 20,
            ),
            SocioEconomicData(student: student),
          ],
        ),
      ),
    );
  }
}

class _ImageViewer extends StatelessWidget {
  final String image;
  const _ImageViewer({required this.image});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: FadeInImage(
        fit: BoxFit.cover,
        image: NetworkImage('${Environment.apiUrl}/$image'),
        placeholder: const AssetImage('assets/loaders/loading.gif'),
      ),
    );
  }
}

class HeaderContainer extends StatelessWidget {
  final String image;
  final String studentId;
  final String name;
  final String lastName;
  final String career;
  const HeaderContainer({
    super.key,
    required this.image,
    required this.studentId,
    required this.name,
    required this.lastName,
    required this.career,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: _ImageViewer(image: image),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            studentId,
            style: TextStyle(
                fontSize: 20,
                color: Color(colors.secondary.value),
                fontWeight: FontWeight.w700),
          ),
          Text(
            '$name $lastName',
            style: TextStyle(
                fontSize: 18,
                color: Color(colors.onSurface.value),
                fontWeight: FontWeight.w500),
          ),
          Text(career,
              style: TextStyle(
                  fontSize: 18,
                  color: Color(colors.onSurface.value),
                  fontWeight: FontWeight.w500))
        ],
      ),
    );
  }
}

class StudentData extends StatelessWidget {
  final Student? student;
  const StudentData({super.key, this.student});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Edad: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '${student?.age}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Género: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: student?.gender ?? 'Sin informacion',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Religión: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: student?.religion ?? 'Sin informacion',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Actividad deportiva: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: student?.activity ?? 'Sin informacion',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Fecha de nacimiento: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: student?.birthdate ?? 'Sin informacion',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Lugar de nacimiento: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: student?.placeOfBirth ?? 'Sin informacion',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Tutor o Padre de familia: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: student?.tutorOrParent ?? 'Sin informacion',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ContactData extends StatelessWidget {
  final Student? student;
  const ContactData({super.key, this.student});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Celular: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: student?.cellPhoneNumber ?? 'Sin informacion',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Tel. Casa: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: student?.homePhoneNumber ?? 'Sin informacion',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Correo: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: student?.email ?? 'Sin informacion',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Correo del tutor: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: student?.tutorsEmail ?? 'Sin informacion',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Domicilio actual: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: student?.currentAddress ?? 'Sin informacion',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Domicilio Familiar: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: student?.homeAddress ?? 'Sin informacion',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MedicalData extends StatelessWidget {
  final Student? student;
  const MedicalData({super.key, this.student});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Número de Seguro social: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: student?.socialSecurityNumber ?? 'Sin informacion',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Tipo de sangre: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: student?.bloodType ?? 'Sin informacion',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Enfermedad: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: student?.disease ?? 'Sin informacion',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Discapacidad: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: student?.disability ?? 'Sin informacion',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Alergia: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: student?.allergy ?? 'Sin informacion',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Consumo de sustancias toxicas: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: student?.sustances ?? 'Sin informacion',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AcademicData extends StatelessWidget {
  final Student? student;
  const AcademicData({super.key, this.student});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                  text: 'Preparatoria de origen: ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: student?.highSchool ?? 'Sin informacion',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                  text: 'Promedio: ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: '${student?.average}',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                  text: 'Puntuación de examen CENEVAL: ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: '${student?.scoreCeneval}',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }
}

class SocioEconomicData extends StatelessWidget {
  final Student? student;
  const SocioEconomicData({super.key, this.student});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Trabajo: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: student?.workplace ?? 'Sin informacion',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: '¿Cuenta con apoyo económico?: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: student?.economicalSupport ?? 'Sin informacion',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Vive con: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: student?.livesWith ?? 'Sin informacion',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
