import 'package:counter_bloc/features/contacts_cubit/update/cubit/contact_update_cubit.dart';
import 'package:counter_bloc/models/contact_model.dart';
import 'package:counter_bloc/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactUpdateCubitPage extends StatefulWidget {
  final ContactModel contact;

  const ContactUpdateCubitPage({required this.contact, super.key});

  @override
  State<ContactUpdateCubitPage> createState() => _ContactUpdateCubitPageState();
}

class _ContactUpdateCubitPageState extends State<ContactUpdateCubitPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameEC;
  late final TextEditingController _emailEC;

  @override
  void initState() {
    super.initState();
    _nameEC = TextEditingController(text: widget.contact.name);
    _emailEC = TextEditingController(text: widget.contact.email);
  }

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
        title: const Text('Contact Update Cubit'),
      ),
      body: BlocListener<ContactUpdateCubit, ContactUpdateCubitState>(
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
                      context.read<ContactUpdateCubit>().save(
                            id: widget.contact.id!,
                            name: _nameEC.text,
                            email: _emailEC.text,
                          );
                    }
                  },
                  child: const Text('Salvar'),
                ),
                Loader<ContactUpdateCubit, ContactUpdateCubitState>(
                  selector: (state) {
                    return state.maybeWhen(
                      loading: () => true,
                      orElse: () => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
