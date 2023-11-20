import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/constant_functions/modal_bottom_sheet.dart';
import 'package:to_do_list/constants/styling.dart';
import 'package:to_do_list/main.dart';

class ToDoListWidget extends StatefulWidget {
  const ToDoListWidget({super.key});

  @override
  State<ToDoListWidget> createState() => _ToDoListWidgetState();
}

class _ToDoListWidgetState extends State<ToDoListWidget> {
  String userId = firebaseAuth.currentUser!.uid;
  String documentId = 'documentId';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 600,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: fireStore
              .collection('users')
              .doc(userId)
              .collection('todos')
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final todos = snapshot.data!.docs;
            final groupedTodos = groupTodosByDate(todos);

            return ListView.builder(
              itemCount: groupedTodos.length,
              itemBuilder: (context, index) {
                final date = groupedTodos.keys.elementAt(index);
                final dateTodos = groupedTodos[date]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        getHeading(date),
                        style: kSubHeading(context),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: dateTodos.length,
                      itemBuilder: (context, index) {
                        final todoData =
                            dateTodos[index].data() as Map<String, dynamic>;
                        final todoTitle = todoData['heading'] as String;
                        final todoBody = todoData['body'] as String;
                        // final todoTime = todoData['time'] as Timestamp;
                        return GestureDetector(
                          onTap: () async {
                            final QuerySnapshot snapshot = await FirebaseFirestore
                                .instance
                                .collection('users')
                                .doc(userId)
                                .collection(
                                    'todos') // Replace with your collection name
                                .where('heading',
                                    isEqualTo:
                                        todoTitle) // Replace with the title you're looking for
                                .get();

                            if (snapshot.docs.isNotEmpty) {
                              final DocumentSnapshot documentSnapshot =
                                  snapshot.docs[0];
                              documentId = documentSnapshot.id;
                              // Now you have the document ID, which you can use to update the document
                            }
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Theme.of(context).primaryColor,
                              isScrollControlled: true,
                              useSafeArea: false,
                              builder: (context) {
                                return ModalBottomSheet(
                                  buttonName: 'Update',
                                  docId: documentId,
                                  heading: todoTitle,
                                  body: todoBody,
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xffcfacb8),
                                    Color(0xffffb6b3),
                                    Color(0xffffbfa7),
                                  ],
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    todoTitle[0].toUpperCase() +
                                        todoTitle.substring(1),
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      try {
                                        final QuerySnapshot snapshot =
                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(userId)
                                                .collection(
                                                    'todos') // Replace with your collection name
                                                .where('heading',
                                                    isEqualTo:
                                                        todoTitle) // Replace with the title you're looking for
                                                .get();

                                        if (snapshot.docs.isNotEmpty) {
                                          final DocumentSnapshot
                                              documentSnapshot =
                                              snapshot.docs[0];
                                          documentId = documentSnapshot.id;
                                          // Now you have the document ID, which you can use to update the document
                                        }
                                        await fireStore
                                            .collection('users')
                                            .doc(userId)
                                            .collection('todos')
                                            .doc(documentId)
                                            .delete();
                                      } catch (error) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              error.toString(),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Map<String, List<DocumentSnapshot>> groupTodosByDate(
      List<QueryDocumentSnapshot> todos) {
    final groupedTodos = <String, List<DocumentSnapshot>>{};

    for (final todo in todos) {
      final todoData = todo.data() as Map<String, dynamic>;
      final timestamp = todoData['time'] as Timestamp;
      final todoDate = timestamp.toDate();
      final todoDateString = getDateString(todoDate);

      if (!groupedTodos.containsKey(todoDateString)) {
        groupedTodos[todoDateString] = [];
      }

      groupedTodos[todoDateString]!.add(todo);
    }

    return groupedTodos;
  }

  String getDateString(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1) {
      return 'Yesterday';
    } else {
      return 'Older';
    }
  }

  String getHeading(String date) {
    if (date == 'Today') {
      return 'Today';
    } else if (date == 'Yesterday') {
      return 'Yesterday';
    } else {
      return 'Older';
    }
  }
}
