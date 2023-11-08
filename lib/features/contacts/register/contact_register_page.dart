import 'package:counter_bloc/features/contacts/register/bloc/contact_register_bloc.dart';
import 'package:counter_bloc/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactRegisterPage extends StatefulWidget {
  const ContactRegisterPage({super.key});

  @override
  State<ContactRegisterPage> createState() => _ContactRegisterPageState();
}

class _ContactRegisterPageState extends State<ContactRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _emailEC = TextEditingController();

  @override
  void dispose() {
    _nameEC.dispose();
    _emailEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: BlocListener<ContactRegisterBloc, ContactRegisterState>(
        listenWhen: (previous, current) {
          return current.maybeWhen(
            success: () => true,
            error: (_) => true,
            orElse: () => false,
          );
        },
        listener: (context, state) {
          state.whenOrNull(
            success: () => Navigator.pop(context),
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameEC,
                  decoration: const InputDecoration(
                    label: Text('nome'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nome é Obrigatório';
                    }

                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailEC,
                  decoration: const InputDecoration(
                    label: Text('email'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'E-mail é Obrigatório';
                    }

                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    final validate = _formKey.currentState?.validate() ?? false;

                    if (validate) {
                      context.read<ContactRegisterBloc>().add(
                          ContactRegisterEvent.save(
                              name: _nameEC.text, email: _emailEC.text));
                    }
                  },
                  child: const Text('Salvar'),
                ),
                Loader<ContactRegisterBloc, ContactRegisterState>(
                  selector: (state) {
                    return state.maybeWhen(
                      loading: () => true,
                      orElse: () => false,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
