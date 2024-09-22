import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ratek/models/group.dart';
import 'package:ratek/widgets/group_entry_dialog.dart';

class GroupsScreen extends ConsumerStatefulWidget {
  const GroupsScreen({super.key});

  @override
  ConsumerState<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends ConsumerState<GroupsScreen> {
  Stream getGroups() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore.collection("uwamambo-groups").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: getGroups(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final documents =
            snapshot.data.docs.map((document) => document.data()).toList();

        List groups = [];
        if (documents.isNotEmpty) {
          groups = documents.map((doc) => Group.fromMap(doc)).toList();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Vikundi"),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
              ),
            ],
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          backgroundColor: const Color.fromARGB(255, 221, 221, 221),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView.builder(
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  Group group = groups[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    height: size.height * 0.47,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0.5, 1),
                            blurRadius: 0.5,
                            spreadRadius: 1,
                            color: Colors.grey)
                      ],
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            SizedBox(height: size.height * 0.25),
                            Container(
                              height: size.height * 0.20,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(group.groupPhoto),
                                  fit: BoxFit.cover,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            Positioned(
                              left: 20,
                              top: size.height * 0.15,
                              child: Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(group.leaderPhoto),
                                    fit: BoxFit.cover,
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Jina la Kikundi"),
                            Text(group.name),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text("Status"), Text("Active")],
                        ),
                        const SizedBox(height: 16),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Wanachama"),
                            SizedBox(width: 66),
                            Expanded(
                              child: Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  SizedBox(height: 56),
                                  Positioned(
                                    left: 16,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          "https://images.unsplash.com/photo-1564564321837-a57b7070ac4f?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8ODR8fHBlcnNvbnxlbnwwfHwwfHx8MA%3D%3D"),
                                      radius: 25,
                                    ),
                                  ),
                                  Positioned(
                                    left: 46,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          "https://images.unsplash.com/photo-1614880353165-e56fac2ea9a8?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8ODJ8fHBlcnNvbnxlbnwwfHwwfHx8MA%3D%3D"),
                                      radius: 25,
                                    ),
                                  ),
                                  Positioned(
                                    left: 74,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          "https://images.unsplash.com/photo-1530268729831-4b0b9e170218?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTA3fHxwZXJzb258ZW58MHx8MHx8fDA%3D"),
                                      radius: 25,
                                    ),
                                  ),
                                  Positioned(
                                    left: 99,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          "https://images.unsplash.com/photo-1545167622-3a6ac756afa4?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTE0fHxwZXJzb258ZW58MHx8MHx8fDA%3D"),
                                      radius: 25,
                                    ),
                                  ),
                                  Positioned(
                                    left: 126,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.green,
                                      radius: 25,
                                      child: Text(
                                        "37",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<Null>(
                    builder: (BuildContext context) {
                      return const GroupEntryDialog();
                    },
                    fullscreenDialog: true),
              );
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
