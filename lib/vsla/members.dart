import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ratek/vsla/add_member.dart';
import 'package:ratek/vsla/meeting.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final List<Map<String, dynamic>> members = [
    {
      "name": "Athanas Shauritanga",
      "location": "Dar es salaam",
      "phone": "+255 655 591 660"
    },
    {
      "name": "Joseph kibelezo",
      "location": "Mbozi",
      "phone": "+255 628 501 670"
    },
    {
      "name": "James Mjelansimi",
      "location": "Saza",
      "phone": "+255 788 591 663"
    },
    {"name": "Jamila Zuberi", "location": "Mlowo", "phone": "+255 655 591 660"},
    {"name": "Shabani Yata", "location": "Mbozi", "phone": "+255 655 591 660"},
    {
      "name": "Alex Milambo",
      "location": "Mkwajuni",
      "phone": "+255 655 591 660"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 80,
            padding: EdgeInsets.only(left: 16, right: 12),
            color: const Color.fromARGB(255, 64, 149, 108),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Members",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Row(
                    children: [
                      Icon(
                        HugeIcons.strokeRoundedSearch01,
                        color: Colors.white,
                      ),
                      SizedBox(width: 24),
                      Icon(
                        CupertinoIcons.info_circle_fill,
                        color: Colors.white,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Center(
                  child: Icon(
                    HugeIcons.strokeRoundedUserGroup,
                  ),
                ),
              ),
              title: Text("meetings and Attendance"),
              trailing: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowRight01,
                color: Colors.black,
                size: 24.0,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MeetingScreen(),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  return Column(
                    children: [
                      ListTile(
                        leading: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5),
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: Center(
                            child: Icon(
                              HugeIcons.strokeRoundedUser,
                            ),
                          ),
                        ),
                        title: Text(member['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(member['location']),
                            Text(member['phone']),
                          ],
                        ),
                        trailing: HugeIcon(
                          icon: HugeIcons.strokeRoundedArrowRight01,
                          color: Colors.black,
                          size: 24.0,
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (_) => AddMemberScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
