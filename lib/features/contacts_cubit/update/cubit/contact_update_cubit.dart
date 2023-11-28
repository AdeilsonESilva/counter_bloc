import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:counter_bloc/models/contact_model.dart';
import 'package:counter_bloc/repositories/contact_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_update_cubit_state.dart';
part 'contact_update_cubit.freezed.dart';

class ContactUpdateCubit extends Cubit<ContactUpdateCubitState> {
  final ContactRepository _repository;

  ContactUpdateCubit({required ContactRepository repository})
      : _repository = repository,
        super(const ContactUpdateCubitState.initial());

  Future<void> save(
      {required int id, required String name, required String email}) async {
    try {
      emit(const ContactUpdateCubitState.loading());

      final contact = ContactModel(id: id, name: name, email: email);

      await _repository.update(contact);
      emit(const ContactUpdateCubitState.success());
    } catch (e, s) {
      log('Erro ao atualizar contato', error: e, stackTrace: s);
      emit(const ContactUpdateCubitState.error(
          message: 'Erro ao atualizar contato'));
    }
  }
}
