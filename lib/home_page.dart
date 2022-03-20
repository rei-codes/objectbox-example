import 'package:flutter/material.dart';
import 'package:objectbox_example/main.dart';

import 'user.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void addToList() {
    store.box<User>().put(User(controller.text));
    controller.text = '';
    Navigator.pop(context);
  }

  void removeSelectedItem(User user) {
    store.box<User>().remove(user.id);
  }

  void addToListDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return Center(
          child: Material(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 60,
                  width: 300,
                  child: TextField(controller: controller),
                ),
                ElevatedButton(
                  onPressed: addToList,
                  child: const Text('add'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final stream = store
      .box<User>()
      .query()
      .watch(triggerImmediately: true)
      .map((e) => e.find());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<User>>(
        stream: stream,
        initialData: const <User>[],
        builder: (_, snapshot) {
          return ListView(
            children: snapshot.data!.map((user) {
              return Card(
                child: ListTile(
                  title: Text(user.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => removeSelectedItem(user),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: addToListDialog,
      ),
    );
  }
}
