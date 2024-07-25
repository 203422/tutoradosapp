import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:tutorados_app/form/form_student.dart';
import 'package:tutorados_app/inputs/inputs.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';

class MedicalDataState {
  final Input socialSecurityNumber;
  final Input bloodType;
  final bool disease;
  final String diseaseName;
  final bool disability;
  final bool allergy;
  final String allergyName;
  final bool sustance;
  final bool visual;
  final bool intellectual;
  final bool auditory;
  final bool physical;
  final List<String> disabilities;
  final bool alcohol;
  final bool cigar;
  final bool drugs;
  final List<String> sustances;
  final bool isValid;
  final bool isFormPosted;
  final bool isPosting;
  final bool isCompleted;

  MedicalDataState({
    this.socialSecurityNumber = const Input.pure(),
    this.bloodType = const Input.pure(),
    this.disease = false,
    this.diseaseName = 'Ninguna',
    this.disability = false,
    this.allergy = false,
    this.allergyName = 'Ninguna',
    this.sustance = false,
    this.visual = false,
    this.intellectual = false,
    this.auditory = false,
    this.physical = false,
    this.disabilities = const [],
    this.alcohol = false,
    this.cigar = false,
    this.drugs = false,
    this.sustances = const [],
    this.isValid = false,
    this.isFormPosted = false,
    this.isPosting = false,
    this.isCompleted = false,
  });

  MedicalDataState copyWith({
    Input? socialSecurityNumber,
    Input? bloodType,
    bool? disease,
    String? diseaseName,
    bool? disability,
    bool? allergy,
    String? allergyName,
    bool? sustance,
    bool? visual,
    bool? intellectual,
    bool? auditory,
    bool? physical,
    bool? alcohol,
    bool? cigar,
    bool? drugs,
    List<String>? disabilities,
    List<String>? sustances,
    bool? isValid,
    bool? isFormPosted,
    bool? isPosting,
    bool? isCompleted,
  }) =>
      MedicalDataState(
        socialSecurityNumber: socialSecurityNumber ?? this.socialSecurityNumber,
        bloodType: bloodType ?? this.bloodType,
        disease: disease ?? this.disease,
        diseaseName: diseaseName ?? this.diseaseName,
        disability: disability ?? this.disability,
        allergy: allergy ?? this.allergy,
        allergyName: allergyName ?? this.allergyName,
        sustance: sustance ?? this.sustance,
        visual: visual ?? this.visual,
        intellectual: intellectual ?? this.intellectual,
        auditory: auditory ?? this.auditory,
        physical: physical ?? this.physical,
        disabilities: disabilities ?? this.disabilities,
        alcohol: alcohol ?? this.alcohol,
        cigar: cigar ?? this.cigar,
        drugs: drugs ?? this.drugs,
        sustances: sustances ?? this.sustances,
        isValid: isValid ?? this.isValid,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isPosting: isPosting ?? this.isPosting,
        isCompleted: isCompleted ?? this.isCompleted,
      );
}

class MedicalDataNotifier extends StateNotifier<MedicalDataState> {
  final AuthState userData;
  final FormStudent formStudent;
  MedicalDataNotifier({required this.userData, required this.formStudent})
      : super(MedicalDataState());

  onSocialNumberChanged(String value) {
    final newValue = Input.dirty(value);
    state = state.copyWith(socialSecurityNumber: newValue);
  }

  onBloodTypeChanged(String value) {
    final newValue = Input.dirty(value);
    state = state.copyWith(bloodType: newValue);
  }

  onDiseaseChanged(String value) {
    state = state.copyWith(diseaseName: value);
  }

  onAllergyChanged(String value) {
    state = state.copyWith(allergyName: value);
  }

  diseaseIsSelected(bool value) {
    state = state.copyWith(disease: value);
  }

  allergyIsSelected(bool value) {
    state = state.copyWith(allergy: value);
  }

  disabilityIsSelected() {
    final List<String> disabilitiesUpdated = List.from(state.disabilities);
    disabilitiesUpdated.clear();

    state = state.copyWith(
        disability: false,
        visual: false,
        intellectual: false,
        auditory: false,
        physical: false,
        disabilities: disabilitiesUpdated);
  }

  visualSelected() {
    final List<String> disabilitiesUpdated = List.from(state.disabilities);

    if (!state.visual) {
      disabilitiesUpdated.add('Visual');

      state = state.copyWith(
          visual: true, disability: true, disabilities: disabilitiesUpdated);
      return;
    }

    disabilitiesUpdated.remove('Visual');
    state = state.copyWith(visual: false, disabilities: disabilitiesUpdated);
  }

  intellectualSelected() {
    final List<String> disabilitiesUpdated = List.from(state.disabilities);

    if (!state.intellectual) {
      disabilitiesUpdated.add('Intelectual');

      state = state.copyWith(
          intellectual: true,
          disability: true,
          disabilities: disabilitiesUpdated);
      return;
    }

    disabilitiesUpdated.remove('Intelectual');

    state =
        state.copyWith(intellectual: false, disabilities: disabilitiesUpdated);
    verifyDisabilities();
  }

  auditorySelected() {
    final List<String> disabilitiesUpdated = List.from(state.disabilities);

    if (!state.auditory) {
      disabilitiesUpdated.add('Auditiva');

      state = state.copyWith(
          auditory: true, disability: true, disabilities: disabilitiesUpdated);
      return;
    }

    disabilitiesUpdated.remove('Auditiva');
    state = state.copyWith(auditory: false, disabilities: disabilitiesUpdated);
    verifyDisabilities();
  }

  physicalSelected() {
    final List<String> disabilitiesUpdated = List.from(state.disabilities);

    if (!state.physical) {
      disabilitiesUpdated.add('Física/Motriz');

      state = state.copyWith(
          physical: true, disability: true, disabilities: disabilitiesUpdated);
      verifyDisabilities();
      return;
    }

    disabilitiesUpdated.remove('Física/Motriz');
    state = state.copyWith(physical: false, disabilities: disabilitiesUpdated);
    verifyDisabilities();
  }

  sustancesIsSelected() {
    final List<String> sustancesUpdated = List.from(state.sustances);
    sustancesUpdated.clear();

    state = state.copyWith(
        sustance: false,
        alcohol: false,
        cigar: false,
        drugs: false,
        sustances: sustancesUpdated);
  }

  alcoholSelected() {
    final List<String> sustancesUpdated = List.from(state.sustances);

    if (!state.alcohol) {
      sustancesUpdated.add('Alcohol');

      state = state.copyWith(
          alcohol: true, sustance: true, sustances: sustancesUpdated);
      return;
    }

    sustancesUpdated.remove('Alcohol');

    state = state.copyWith(alcohol: false, sustances: sustancesUpdated);
    verifySustances();
  }

  cigarSelected() {
    final List<String> sustancesUpdated = List.from(state.sustances);

    if (!state.cigar) {
      sustancesUpdated.add('Cigarro');

      state = state.copyWith(
          cigar: true, sustance: true, sustances: sustancesUpdated);
      return;
    }

    sustancesUpdated.remove('Cigarro');

    state = state.copyWith(cigar: false, sustances: sustancesUpdated);
    verifySustances();
  }

  drugsSelected() {
    final List<String> sustancesUpdated = List.from(state.sustances);

    if (!state.drugs) {
      sustancesUpdated.add('Drogas');

      state = state.copyWith(
          drugs: true, sustance: true, sustances: sustancesUpdated);
      return;
    }

    sustancesUpdated.remove('Drogas');

    state = state.copyWith(drugs: false, sustances: sustancesUpdated);
    verifySustances();
  }

  verifySustances() {
    if (!state.alcohol && !state.cigar && !state.drugs) {
      state = state.copyWith(sustance: false);
    }
  }

  verifyDisabilities() {
    if (!state.visual &&
        !state.intellectual &&
        !state.auditory &&
        !state.physical) {
      state = state.copyWith(disability: false);
    }
  }

  onFormSubmit() {
    _touchEveryField();
    if (!state.isValid) return;
    state = state.copyWith(isPosting: true);
    sendData();
    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final socialSecurityNumber = Input.dirty(state.socialSecurityNumber.value);
    final bloodType = Input.dirty(state.bloodType.value);

    state = state.copyWith(
        isFormPosted: true,
        socialSecurityNumber: socialSecurityNumber,
        bloodType: bloodType,
        isValid: Formz.validate([
          socialSecurityNumber,
          bloodType,
        ]));
  }

  sendData() async {
    final String disability =
        state.disability ? jsonEncode(state.disabilities) : 'Ninguna';
    final String sustances =
        state.disability ? jsonEncode(state.sustances) : 'Ninguna';

    try {
      await formStudent.saveMedicalData(
          userData.user!.id,
          state.socialSecurityNumber.value,
          state.bloodType.value,
          state.diseaseName,
          disability,
          state.allergyName,
          sustances);
      state = state.copyWith(isCompleted: true);
    } catch (e) {
      state = state.copyWith(isCompleted: false);
    }
  }
}

final medicalDataProvider =
    StateNotifierProvider<MedicalDataNotifier, MedicalDataState>((ref) {
  final userData = ref.watch(authProvider);
  final accessToken = ref.watch(authProvider).user?.token ?? '';
  final formStudent = FormStudent(accessToken: accessToken);
  return MedicalDataNotifier(userData: userData, formStudent: formStudent);
});
