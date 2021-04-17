import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/chats/messages.dart';
import '../widgets/chats/new_message.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: Text('Connect'),
        actions: [
          DropdownButton(
            underline: Container(),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout')
                    ],
                  ),
                ),
                value: 'Logout', // works as an identifier
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'Logout') {
                FirebaseAuth.instance.signOut();
              }
            },
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.2,
            child: Center(
              child: CircleAvatar(
                radius: 150,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                backgroundImage: AssetImage('assets/image/img3.jpg'),
              ),
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Messages(),
                ),
                NewMessage(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// snapshots() => they return stream i.e it emmits new value whenever data changes.

// StreamBuilder() => takes a stream and a builder, with every change in stream build function runs.
