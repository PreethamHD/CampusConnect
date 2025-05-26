import 'package:campusconnect/components/drawer.dart';
import 'package:campusconnect/core/constants/constants.dart';
import 'package:campusconnect/features/auth/controller/auth_controller.dart';
import 'package:campusconnect/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _page = 0;

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SizedBox(
          height: 55,
          child: Image.asset(
            'assets/images/campusconnectLogo.png',
            fit: BoxFit.contain,
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => displayDrawer(context),
              icon: CircleAvatar(
                backgroundImage: NetworkImage(user.ProfilePic),
              ),
            );
          },
        ),
      ),
      body: Constants.tabs[_page],

      drawer: MyDrawer(),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Pallete.blueColor,
        unselectedItemColor: Pallete.whiteColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.question_answer), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: ''),
        ],
        onTap: onPageChange,
        currentIndex: _page,
      ),
    );
  }
}
