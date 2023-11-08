import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:counter_bloc/repositories/contact_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_delete_event.dart';
part 'contact_delete_state.dart';
part 'contact_delete_bloc.freezed.dart';

class ContactDeleteBloc extends Bloc<ContactDeleteEvent, ContactDeleteState> {
  final ContactRepository _repository;

  ContactDeleteBloc({required ContactRepository repository})
      : _repository = repository,
        super(const _Initial()) {
    on<_Delete>(_delete);
  }

  FutureOr<void> _delete(
      _Delete event, Emitter<ContactDeleteState> emit) async {
    try {
      emit(const ContactDeleteState.loading());

      await _repository.delete(event.id);
      emit(const ContactDeleteState.success());
    } catch (e, s) {
      log('Erro ao excluir o contato', error: e, stackTrace: s);
      emit(
          const ContactDeleteState.error(message: 'Erro ao excluir o contato'));
    }
  }
}
