import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:counter_bloc/models/contact_model.dart';
import 'package:counter_bloc/repositories/contact_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_list_cubit_state.dart';
part 'contact_list_cubit.freezed.dart';

class ContactListCubit extends Cubit<ContactListCubitState> {
  final ContactRepository _repository;

  ContactListCubit({required ContactRepository repository})
      : _repository = repository,
        super(ContactListCubitState.initial());

  Future<void> findAll() async {
    try {
      emit(ContactListCubitState.loading());

      final contacts = await _repository.findAll();
      // await Future.delayed(const Duration(seconds: 1));
      emit(ContactListCubitState.data(contacts: contacts));
    } catch (e, s) {
      log('Erro ao buscar contatos', error: e, stackTrace: s);
      emit(ContactListCubitState.error(error: 'Erro ao buscar contatos'));
    }
  }

  Future<void> deleteById(int id) async {
    emit(ContactListCubitState.loading());
    await _repository.delete(id);
    findAll();
  }
}
