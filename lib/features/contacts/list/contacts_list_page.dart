import 'package:counter_bloc/features/contacts/delete/bloc/contact_delete_bloc.dart';
import 'package:counter_bloc/features/contacts/list/bloc/contact_list_bloc.dart';
import 'package:counter_bloc/models/contact_model.dart';
import 'package:counter_bloc/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsListPage extends StatelessWidget {
  const ContactsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final contactListBloc = context.read<ContactListBloc>();

          await Navigator.pushNamed(context, '/contacts/register');
          contactListBloc.add(const ContactListEvent.findAll());
        },
        child: const Icon(Icons.add),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ContactListBloc, ContactListState>(
            listenWhen: (previous, current) {
              return current.maybeWhen(
                error: (error) => true,
                orElse: () => false,
              );
            },
            listener: (context, state) {
              state.whenOrNull(
                error: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        error,
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              );
            },
          ),
          BlocListener<ContactDeleteBloc, ContactDeleteState>(
            listenWhen: (previous, current) {
              return current.maybeWhen(
                error: (error) => true,
                orElse: () => false,
              );
            },
            listener: (context, state) {
              state.whenOrNull(
                error: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        error,
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              );
            },
          ),
        ],
        child: RefreshIndicator(
          onRefresh: () async => context
              .read<ContactListBloc>()
              .add(const ContactListEvent.findAll()),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: Column(
                  children: [
                    Loader<ContactListBloc, ContactListState>(
                      selector: (state) {
                        return state.maybeWhen(
                          loading: () => true,
                          orElse: () => false,
                        );
                      },
                    ),
                    BlocSelector<ContactListBloc, ContactListState,
                        List<ContactModel>>(
                      selector: (state) {
                        return state.maybeWhen(
                          data: (contacts) => contacts,
                          orElse: () => [],
                        );
                      },
                      builder: (_, contacts) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: contacts.length,
                          itemBuilder: (context, index) {
                            final contact = contacts[index];

                            return ListTile(
                              onTap: () async {
                                final contactListBloc =
                                    context.read<ContactListBloc>();

                                await Navigator.pushNamed(
                                    context, '/contacts/update',
                                    arguments: contact);
                                contactListBloc
                                    .add(const ContactListEvent.findAll());
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
                                                      .read<ContactDeleteBloc>()
                                                      .add(ContactDeleteEvent
                                                          .delete(
                                                              id: contact.id!));
                                                  context
                                                      .read<ContactListBloc>()
                                                      .add(
                                                          const ContactListEvent
                                                              .findAll());
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
