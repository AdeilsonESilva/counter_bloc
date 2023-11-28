import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:counter_bloc/models/contact_model.dart';
import 'package:counter_bloc/repositories/contact_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_register_cubit_state.dart';
part 'contact_register_cubit.freezed.dart';

class ContactRegisterCubit extends Cubit<ContactRegisterCubitState> {
  final ContactRepository _repository;

  ContactRegisterCubit({required ContactRepository repository})
      : _repository = repository,
        super(const ContactRegisterCubitState.initial());

  Future<void> save({required String name, required String email}) async {
    try {
      emit(const ContactRegisterCubitState.loading());

      final contactModel = ContactModel(name: name, email: email);

      await _repository.create(contactModel);
      emit(const ContactRegisterCubitState.success());
    } catch (e, s) {
      log('Erro ao criar contato', error: e, stackTrace: s);
      emit(const ContactRegisterCubitState.error(
          message: 'Erro ao criar contato'));
    }
  }
}
