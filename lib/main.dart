import 'package:counter_bloc/features/bloc_example/bloc/example_bloc.dart';
import 'package:counter_bloc/features/bloc_example/bloc_example.dart';
import 'package:counter_bloc/features/bloc_freezed_example/bloc_freezed/example_freezed_bloc.dart';
import 'package:counter_bloc/features/bloc_freezed_example/bloc_freezed_example.dart';
import 'package:counter_bloc/features/contacts/list/bloc/contact_list_bloc.dart';
import 'package:counter_bloc/features/contacts/list/contacts_list_page.dart';
import 'package:counter_bloc/features/contacts/register/bloc/contact_register_bloc.dart';
import 'package:counter_bloc/features/contacts/register/contact_register_page.dart';
import 'package:counter_bloc/features/contacts/update/bloc/contact_update_bloc.dart';
import 'package:counter_bloc/features/contacts/update/contact_update_page.dart';
import 'package:counter_bloc/features/contacts_cubit/list/contacts_list_cubit_page.dart';
import 'package:counter_bloc/features/contacts_cubit/list/cubit/contact_list_cubit.dart';
import 'package:counter_bloc/features/contacts_cubit/register/contact_register_cubit_page.dart';
import 'package:counter_bloc/features/contacts_cubit/register/cubit/contact_register_cubit.dart';
import 'package:counter_bloc/features/contacts_cubit/update/contact_update_cubit_page.dart';
import 'package:counter_bloc/features/contacts_cubit/update/cubit/contact_update_cubit.dart';
import 'package:counter_bloc/home_page.dart';
import 'package:counter_bloc/models/contact_model.dart';
import 'package:counter_bloc/page_bloc/bloc/counter_bloc.dart';
import 'package:counter_bloc/page_bloc/counter_bloc_page.dart';
import 'package:counter_bloc/page_cubit/counter_cubit_page.dart';
import 'package:counter_bloc/page_cubit/cubit/counter_cubit.dart';
import 'package:counter_bloc/repositories/contact_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => ContactRepository(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: {
          '/bloc': (_) => BlocProvider(
                create: (_) => CounterBloc(),
                child: const CounterBlocPage(),
              ),
          '/cubit': (_) => BlocProvider(
                create: (_) => CounterCubit(),
                child: const CounterCubitPage(),
              ),
          '/bloc/example': (_) => BlocProvider(
                create: (_) => ExampleBloc()..add(ExampleFindNameEvent()),
                child: const BlocExample(),
              ),
          '/bloc/example/freezed': (_) => BlocProvider(
                create: (_) =>
                    ExampleFreezedBloc()..add(ExampleFreezedEvent.findNames()),
                child: const BlocFreezedExample(),
              ),
          '/contacts/list': (context) => BlocProvider(
                create: (_) => ContactListBloc(
                  repository: context.read<ContactRepository>(),
                )..add(const ContactListEvent.findAll()),
                child: const ContactsListPage(),
              ),
          '/contacts/register': (context) => BlocProvider(
                create: (context) => ContactRegisterBloc(
                  repository: context.read<ContactRepository>(),
                ),
                child: const ContactRegisterPage(),
              ),
          '/contacts/update': (context) {
            final contact =
                ModalRoute.of(context)!.settings.arguments as ContactModel;

            return BlocProvider(
              create: (context) => ContactUpdateBloc(
                  repository: context.read<ContactRepository>()),
              child: ContactUpdatePage(
                contact: contact,
              ),
            );
          },
          '/contacts/cubit/list': (context) => BlocProvider(
                create: (_) => ContactListCubit(
                  repository: context.read<ContactRepository>(),
                )..findAll(),
                child: const ContactsListCubitPage(),
              ),
          '/contacts/cubit/register': (context) => BlocProvider(
                create: (context) => ContactRegisterCubit(
                  repository: context.read<ContactRepository>(),
                ),
                child: const ContactRegisterCubitPage(),
              ),
          '/contacts/cubit/update': (context) {
            final contact =
                ModalRoute.of(context)!.settings.arguments as ContactModel;

            return BlocProvider(
              create: (context) => ContactUpdateCubit(
                  repository: context.read<ContactRepository>()),
              child: ContactUpdateCubitPage(
                contact: contact,
              ),
            );
          },
        },
        home: const HomePage(),
      ),
    );
  }
}
