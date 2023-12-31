import 'dart:ffi';

import 'package:bloc_test/bloc_test.dart';
import 'package:counter_bloc/features/contacts/list/bloc/contact_list_bloc.dart';
import 'package:counter_bloc/models/contact_model.dart';
import 'package:counter_bloc/repositories/contact_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockContactRepository extends Mock implements ContactRepository {}

void main() {
  // declaração
  late ContactRepository repository;
  late ContactListBloc bloc;
  late List<ContactModel> contacts;

  // preparação
  setUp(() {
    repository = MockContactRepository();
    bloc = ContactListBloc(repository: repository);
    contacts = [
      ContactModel(id: 1, name: 'Adeilson', email: 'adeilson@gmail.com'),
      ContactModel(id: 2, name: 'Juliana', email: 'juliana@gmail.com'),
    ];
  });

  // execução
  blocTest<ContactListBloc, ContactListState>(
    'Deve buscar os contatos',
    build: () => bloc,
    act: (bloc) => bloc.add(const ContactListEvent.findAll()),
    setUp: () {
      when(
        () => repository.findAll(),
      ).thenAnswer((_) async => contacts);
    },
    expect: () => [
      const ContactListState.loading(),
      ContactListState.data(contacts: contacts),
    ],
  );

  blocTest<ContactListBloc, ContactListState>(
    'Deve retornar erro ao buscar contatos',
    build: () => bloc,
    act: (bloc) => bloc.add(const ContactListEvent.findAll()),
    expect: () => [
      const ContactListState.loading(),
      const ContactListState.error(error: 'Erro ao buscar contatos'),
    ],
  );

  blocTest<ContactListBloc, ContactListState>(
    'Deve excluir um contato',
    build: () => bloc,
    act: (bloc) => bloc.add(ContactListEvent.delete(id: contacts[0].id!)),
    setUp: () {
      when(
        () => repository.delete(contacts[0].id!),
      ).thenAnswer((_) async {});
      when(
        () => repository.findAll(),
      ).thenAnswer((_) async {
        contacts.removeAt(0);
        return contacts;
      });
    },
    expect: () => [
      const ContactListState.loading(),
      ContactListState.data(contacts: contacts),
    ],
  );

  blocTest<ContactListBloc, ContactListState>(
    'Deve retornar erro ao excluir um contato',
    build: () => bloc,
    act: (bloc) => bloc.add(const ContactListEvent.delete(id: 1)),
    expect: () => [
      const ContactListState.loading(),
      const ContactListState.error(error: 'Erro ao excluir o contato'),
    ],
  );
}
