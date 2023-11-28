import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/bloc');
              },
              child: Text(
                'Bloc',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/cubit');
              },
              child: Text(
                'Cubit',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/bloc/example');
              },
              child: Text(
                'Example',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/bloc/example');
              },
              child: Text(
                'Example',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/bloc/example/freezed');
              },
              child: Text(
                'Example Freezed',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/contacts/list');
              },
              child: Text(
                'Contact',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/contacts/cubit/list');
              },
              child: Text(
                'Contact Cubit',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
