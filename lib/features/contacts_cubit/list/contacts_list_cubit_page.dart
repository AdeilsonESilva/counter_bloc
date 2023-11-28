import 'package:counter_bloc/features/contacts_cubit/list/cubit/contact_list_cubit.dart';
import 'package:counter_bloc/models/contact_model.dart';
import 'package:counter_bloc/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsListCubitPage extends StatelessWidget {
  const ContactsListCubitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact List Cubit'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final contactListCubit = context.read<ContactListCubit>();

          await Navigator.pushNamed(context, '/contacts/cubit/register');
          contactListCubit.findAll();
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<ContactListCubit>().findAll(),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: Column(
                children: [
                  Loader<ContactListCubit, ContactListCubitState>(
                    selector: (state) {
                      return state.maybeWhen(
                        loading: () => true,
                        orElse: () => false,
                      );
                    },
                  ),
                  BlocSelector<ContactListCubit, ContactListCubitState,
                      List<ContactModel>>(
                    selector: (state) {
                      return state.maybeWhen(
                        data: (contacts) => contacts,
                        orElse: () => [],
                      );
                    },
                    builder: (context, contacts) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: contacts.length,
                        itemBuilder: (_, index) {
                          final contact = contacts[index];

                          return ListTile(
                            onTap: () async {
                              final contactListCubit =
                                  context.read<ContactListCubit>();

                              await Navigator.pushNamed(
                                  context, '/contacts/cubit/update',
                                  arguments: contact);
                              contactListCubit.findAll();
                            },
                            title: Text(contact.name),
                            subtitle: Text(contact.email),
                            trailing: InkWell(
                              borderRadius: BorderRadius.circular(32),
                              onTap: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (_) {
                                    return SizedBox(
                                      height: 200,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            const Text(
                                                'Deseja realmente excluir esse contato?'),
                                            ElevatedButton(
                                              child: const Text('Excluir'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                context
                                                    .read<ContactListCubit>()
                                                    .deleteById(contact.id!);
                                              },
                                            ),
                                            ElevatedButton(
                                              child: const Text('Cancelar'),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.delete),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
