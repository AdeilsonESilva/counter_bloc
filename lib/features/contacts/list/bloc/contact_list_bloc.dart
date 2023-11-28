import 'dart:async';
import 'dart:developer';
import 'package:counter_bloc/models/contact_model.dart';
import 'package:counter_bloc/repositories/contact_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_list_event.dart';
part 'contact_list_state.dart';
part 'contact_list_bloc.freezed.dart';

class ContactListBloc extends Bloc<ContactListEvent, ContactListState> {
  final ContactRepository _repository;

  ContactListBloc({required ContactRepository repository})
      : _repository = repository,
        super(const ContactListState.initial()) {
    on<_ContactListEventFindAll>(_findAll);
    on<_ContactListEventDelete>(_delete);
  }

  Future<void> _findAll(
      _ContactListEventFindAll event, Emitter<ContactListState> emit) async {
    try {
      emit(const ContactListState.loading());
      final contacts = await _repository.findAll();
      // await Future.delayed(const Duration(seconds: 2));
      // throw Exception();
      emit(ContactListState.data(contacts: contacts));
    } catch (e, s) {
      log('Erro ao buscar contatos', error: e, stackTrace: s);
      emit(const ContactListState.error(error: 'Erro ao buscar contatos'));
    }
  }

  FutureOr<void> _delete(
      _ContactListEventDelete event, Emitter<ContactListState> emit) async {
    try {
      emit(const ContactListState.loading());

      await _repository.delete(event.id);
      add(const ContactListEvent.findAll());
    } catch (e, s) {
      log('Erro ao excluir o contato', error: e, stackTrace: s);
      emit(const ContactListState.error(error: 'Erro ao excluir o contato'));
    }
  }
}
