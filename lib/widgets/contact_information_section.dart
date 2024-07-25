import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';
import 'package:tutorados_app/widgets/widgets.dart';

class ContactInformationSection extends ConsumerWidget {
  const ContactInformationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactProvider = ref.watch(contactDataProvider);
    final userData = ref.watch(authProvider);
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        CustomTextField(
          isFormStudent: true,
          label: 'Domicilio actual',
          onChanged:
              ref.read(contactDataProvider.notifier).onCurrentAddressChanged,
          errorMessage: contactProvider.isFormPosted
              ? contactProvider.currentAddress.errorMessage
              : null,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomTextField(
          isFormStudent: true,
          label: 'Domicilio familiar',
          onChanged:
              ref.read(contactDataProvider.notifier).onHomeAddressChanged,
          errorMessage: contactProvider.isFormPosted
              ? contactProvider.homeAddress.errorMessage
              : null,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomTextField(
          isFormStudent: true,
          label: 'Celular',
          keyboardType: TextInputType.phone,
          onChanged:
              ref.read(contactDataProvider.notifier).onCellPhoneNumberChanged,
          errorMessage: contactProvider.isFormPosted
              ? contactProvider.cellPhoneNumber.errorMessage
              : null,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomTextField(
          isFormStudent: true,
          label: 'Tel. Casa',
          keyboardType: TextInputType.phone,
          onChanged:
              ref.read(contactDataProvider.notifier).onHomePhoneNumberChanged,
          errorMessage: contactProvider.isFormPosted
              ? contactProvider.homePhoneNumber.errorMessage
              : null,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomTextField(
          isFormStudent: true,
          label: 'Correo',
          keyboardType: TextInputType.emailAddress,
          initialValue: userData.user!.email,
          onChanged: ref.read(contactDataProvider.notifier).onEmailChanged,
          errorMessage: contactProvider.isFormPosted
              ? contactProvider.email.errorMessage
              : null,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomTextField(
          isFormStudent: true,
          label: 'Correo del tutor',
          keyboardType: TextInputType.emailAddress,
          onChanged:
              ref.read(contactDataProvider.notifier).onTutorsEmailChanged,
          errorMessage: contactProvider.isFormPosted
              ? contactProvider.tutorsEmail.errorMessage
              : null,
              onFieldSubmitted: (_) => ref.read(contactDataProvider.notifier).onFormSubmit(),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Color(colors.primary.value),
                  foregroundColor: Color(colors.onPrimary.value)),
              onPressed: contactProvider.isPosting
                  ? null
                  : ref.read(contactDataProvider.notifier).onFormSubmit,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'Siguiente',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              )),
        ),
      ],
    );
  }
}
