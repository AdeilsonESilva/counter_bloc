import 'package:counter_bloc/features/bloc_example/bloc/example_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocExample extends StatefulWidget {
  const BlocExample({super.key});

  @override
  State<BlocExample> createState() => _BlocExampleState();
}

class _BlocExampleState extends State<BlocExample> {
  final nameEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc Example'),
      ),
      body: BlocListener<ExampleBloc, ExampleState>(
        listener: (context, state) {
          print('ade: BlocListener');
          if (state is ExampleStateData) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('A quantidade de nomes é ${state.names.length}'),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameEC),
              ElevatedButton(
                  onPressed: () {
                    context
                        .read<ExampleBloc>()
                        .add(ExampleAddNameEvent(name: nameEC.text));
                    nameEC.clear();
                  },
                  child: const Text('Adicionar')),
              BlocConsumer<ExampleBloc, ExampleState>(
                listener: (context, state) {
                  print(
                      'ade: BlocConsumer estado alterado - ${state.runtimeType}');
                },
                builder: (_, state) {
                  if (state is ExampleStateData) {
                    return Text('Total de nomes é: ${state.names.length}');
                  }

                  return const SizedBox.shrink();
                },
              ),
              BlocSelector<ExampleBloc, ExampleState, bool>(
                selector: (state) {
                  if (state is ExampleStateInitial) {
                    return true;
                  }

                  return false;
                },
                builder: (context, showLoader) {
                  print('ade: BlocSelector - $showLoader');

                  if (showLoader) {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
              BlocSelector<ExampleBloc, ExampleState, List<String>>(
                selector: (state) {
                  if (state is ExampleStateData) {
                    return state.names;
                  }
                  return [];
                },
                builder: (context, names) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: names.length,
                    itemBuilder: (context, index) {
                      final name = names[index];
                      return ListTile(
                        onTap: () {
                          context
                              .read<ExampleBloc>()
                              .add(ExampleRemoveNameEvent(name: name));
                        },
                        title: Text(name),
                      );
                    },
                  );
                },
              ),
              // BlocBuilder<ExampleBloc, ExampleState>(
              //   builder: (context, state) {
              //     print('ade: BlocBuilder - ${state.runtimeType}');
              //     if (state is ExampleStateData) {
              //       return ListView.builder(
              //         shrinkWrap: true,
              //         itemCount: state.names.length,
              //         itemBuilder: (context, index) {
              //           final name = state.names[index];
              //           return ListTile(
              //             title: Text(name),
              //           );
              //         },
              //       );
              //     }

              //     return const SizedBox.shrink();
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
