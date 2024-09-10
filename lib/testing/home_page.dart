import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vigo_smart_app/testing/cubit/counter_cubit.dart';
import 'package:vigo_smart_app/testing/inc_dec_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});
  
  final String title;

  @override
  Widget build(BuildContext context) {
    final counterCubit = BlocProvider.of<CounterCubit>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            BlocBuilder<CounterCubit, int>(
              bloc: counterCubit,
              builder: (context, counter) {
                return Text('$counter', style: const TextStyle(fontSize: 24));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => IncDecPage()));
          },
        child: const Icon(Icons.navigate_next),
      
      ),
    );
  }
}
