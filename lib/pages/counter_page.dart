import 'package:flutter/material.dart';
import 'package:shop/providers/counter.dart';

class CounterPage extends StatefulWidget {
  //final Product product;
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    final provider = CounterProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('ExemploContador'),
      ),
      body: Column(
        children: [
          Text(provider?.state.value.toString() ?? '0'),
          IconButton(
              onPressed: () {
                setState(() {
                  provider?.state.inc();
                  print(provider?.state.value);
                });
              },
              icon: Icon(Icons.add)),
          IconButton(
              onPressed: () {
                setState(() {
                  provider?.state.dec();
                  print(provider?.state.value);
                });
              },
              icon: Icon(Icons.remove)),
        ],
      ),
    );
  }
}
