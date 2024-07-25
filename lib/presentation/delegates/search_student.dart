import 'package:flutter/material.dart';
import 'package:tutorados_app/config/config.dart';

typedef SearchStudentCallback = Function(String query);

class SearchStudent extends SearchDelegate {
  final SearchStudentCallback searchStudent;

  SearchStudent({required this.searchStudent});

  @override
  String get searchFieldLabel => 'Matrícula del alumno';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('BuildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List>(
        future: searchStudent(query),
        builder: (context, snapshot) {
          final students = snapshot.data ?? [];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return StudentItem(
                  onStudentSelected: close,
                  student: student,
                );
              },
            ),
          );
        });
  }
}

class StudentItem extends StatelessWidget {
  final Function onStudentSelected;
  final dynamic student;

  const StudentItem({
    super.key,
    required this.onStudentSelected,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        onStudentSelected(context, student);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsetsDirectional.only(bottom: 10),
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: Color(colors.primaryContainer.value),
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student['usuario_id'],
                  style: TextStyle(
                      color: Color(colors.secondary.value),
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  '${student['nombre']} ${student['apellido']}',
                  style: TextStyle(color: Color(colors.onPrimaryContainer.value)),
                ),
                Text(
                  student['correo'],
                   style: TextStyle(color: Color(colors.onPrimaryContainer.value)),
                ),
              ],
            ),
            SizedBox(
              width: 50,
              height: 50,
              child: _ImageViewer(image: student['imagen']),
            )
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
