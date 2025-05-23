import 'package:campusconnect/screens/chat_screen.dart';
import 'package:campusconnect/screens/discussion_screen.dart';
import 'package:campusconnect/screens/feed_screen.dart';
import 'package:campusconnect/screens/notes_screen.dart';

class Constants {
  static const userProfile =
      'https://res.cloudinary.com/den2kvu2j/image/upload/v1735864663/ynxab5z9adzrzt6ebb3j.jpg';

  static const tabs = [
    FeedScreen(),
    DiscussionScreen(),
    NotesScreen(),
    ChatScreen(),
  ];
}
