import 'package:bloc_test/bloc_test.dart';
import 'package:counter_bloc/features/contacts_cubit/list/cubit/contact_list_cubit.dart';
import 'package:counter_bloc/models/contact_model.dart';
import 'package:counter_bloc/repositories/contact_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockContactRepository extends Mock implements ContactRepository {}

extension VoidAnswer on When<Future<void>> {
  void thenAnswerWithVoid() => thenAnswer((_) async {});
}

void main() {
  // declaração
  late ContactRepository repository;
  late ContactListCubit cubit;
  late List<ContactModel> contacts;

  // preparação
  setUp(() {
    repository = MockContactRepository();
    cubit = ContactListCubit(repository: repository);
    contacts = [
      ContactModel(name: 'Adeilson', email: 'adeilson@gmail.com'),
      ContactModel(name: 'Juliana', email: 'juliana@gmail.com'),
    ];
  });

  blocTest<ContactListCubit, ContactListCubitState>(
    'Deve buscar os contatos cubit',
    build: () => cubit,
    act: (cubit) => cubit.findAll(),
    setUp: () {
      when(
        () => repository.findAll(),
      ).thenAnswer((_) async => contacts);
    },
    expect: () => [
      ContactListCubitState.loading(),
      ContactListCubitState.data(contacts: contacts),
    ],
  );

  blocTest<ContactListCubit, ContactListCubitState>(
    'Deve retornar erro ao buscar contatos',
    build: () => cubit,
    act: (cubit) => cubit.findAll(),
    expect: () => [
      ContactListCubitState.loading(),
      ContactListCubitState.error(error: 'Erro ao buscar contatos'),
    ],
  );

  /* blocTest<ContactListCubit, ContactListCubitState>(
    'Deve excluir um contato',
    build: () => cubit,
    act: (cubit) => cubit.deleteById(1),
    setUp: () {
      when(
        () => repository.delete(any()),
      ).thenAnswer(
        (_) async {
          contacts.removeAt(0);
          return;
        },
      );
      when(
        () => repository.findAll(),
      ).thenAnswer((_) async => contacts);
    },
    expect: () {
      return [
        ContactListCubitState.loading(),
        ContactListCubitState.data(contacts: contacts),
      ];
    },
  );

  blocTest<ContactListCubit, ContactListCubitState>(
    'Deve retornar erro ao excluir um contato',
    build: () => cubit,
    act: (cubit) => cubit.deleteById(1),
    setUp: () {
      when(
        () => repository.delete(any()),
      ).thenThrow(() {
        return Exception();
      });
    },
    expect: () => [
      ContactListCubitState.loading(),
      ContactListCubitState.error(error: 'Erro ao excluir o contato'),
    ],
  ); */
}
