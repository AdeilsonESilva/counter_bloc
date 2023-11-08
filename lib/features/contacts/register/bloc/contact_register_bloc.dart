import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:counter_bloc/models/contact_model.dart';
import 'package:counter_bloc/repositories/contact_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_register_event.dart';
part 'contact_register_state.dart';
part 'contact_register_bloc.freezed.dart';

class ContactRegisterBloc
    extends Bloc<ContactRegisterEvent, ContactRegisterState> {
  final ContactRepository _repository;

  ContactRegisterBloc({required ContactRepository repository})
      : _repository = repository,
        super(const ContactRegisterState.initial()) {
    on<_Save>(_save);
  }

  FutureOr<void> _save(_Save event, Emitter<ContactRegisterState> emit) async {
    try {
      emit(const ContactRegisterState.loading());

      await Future.delayed(const Duration(seconds: 2));

      final contactModel = ContactModel(name: event.name, email: event.email);

      await _repository.create(contactModel);
      emit(const ContactRegisterState.success());
    } catch (e, s) {
      log('Erro ao salvar um novo contato', error: e, stackTrace: s);
      emit(const ContactRegisterState.error(
          message: 'Erro ao salvar um novo contato'));
    }
  }
}
