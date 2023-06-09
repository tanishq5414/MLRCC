import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mlrcc/features/attendance/controllers/attendance_controller.dart';
import 'package:mlrcc/features/auth/views/insert_user_details.dart';
import 'package:mlrcc/features/explore/controller/explore_controller.dart';
import 'package:mlrcc/features/explore/views/explore.dart';
import 'package:mlrcc/features/home/views/home_view.dart';
import 'package:mlrcc/features/noticeboard/controller/nb_posts_controller.dart';
import 'package:mlrcc/features/noticeboard/views/notice_board.dart';
import 'package:mlrcc/features/pposts/controllers/pposts_controller.dart';
import 'package:mlrcc/features/questions/controller/questions_controller.dart';
import 'package:mlrcc/features/user/controller/user_controller.dart';
import 'package:mlrcc/features/user/views/user_profile.dart';

import 'package:mlrcc/theme/pallete.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class NavView extends ConsumerStatefulWidget {
  final String uid;
  final String name;
  final String email;
  final String imageUrl;
  static route(uid, name, email, imageUrl) => MaterialPageRoute(
        builder: (context) => NavView(
          uid: uid,
          name: name,
          email: email,
          imageUrl: imageUrl,
        ),
      );
  const NavView(
      {super.key,
      required this.uid,
      required this.name,
      required this.email,
      required this.imageUrl});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NavViewState();
}

class _NavViewState extends ConsumerState<NavView> {
  int _currentIndex = 0;
  void onPageChange(int index) {
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getData() async {
        await ref
            .read(userControllerProvider.notifier)
            .getUserData(context: context, uid: widget.uid);
        var user = ref.read(userDataProvider);
        // print(user!.uid);
        if (user == null && context.mounted) {
          Navigator.popUntil(context, (route) => false);
          Navigator.push(
              context,
              InsertUserDetailsView.route(
                  widget.uid, widget.name, widget.email, widget.imageUrl));
        }
        if (context.mounted){
        await ref.read(pPostsControllerProvider.notifier).getPPosts(context);
        await ref.read(nBPostsControllerProvider.notifier).getNBPosts(context);
        await ref
            .read(questionsControllerProvider.notifier)
            .getQuestions(context);
        await ref
            .read(exploreControllerProvider.notifier)
            .getExplorePosts(context);
        await ref
            .read(attendanceControllerProvider.notifier)
            .getAttendance(context, user!.rno!);
        await ref.read(userControllerProvider.notifier).getTimeTableUrl(
            context: context,
            branch: user.branch!,
            year: user.year!,
            section: user.section!);
      }
      }
        getData();
    });
  }

  List<Widget> _children = [];
  @override
  Widget build(BuildContext context) {
    _children = [
      HomeView(),
      NoticeBoardView(),
      ExploreView(),
      UserProfileView(),
    ];
    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      body: _children[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Pallete.backgroundColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12),
            child: GNav(
              onTabChange: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              duration: const Duration(milliseconds: 500),
              tabBackgroundColor: Pallete.accentColor,
              color: Pallete.accentColor,
              tabs: const [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                  textStyle: TextStyle(color: Pallete.whiteColor),
                ),
                GButton(
                  icon: LineIcons.pollH,
                  text: 'Notice Board',
                  textStyle: TextStyle(color: Pallete.whiteColor),
                ),
                GButton(
                  icon: LineIcons.search,
                  text: 'Explore',
                  textStyle: TextStyle(color: Pallete.whiteColor),
                ),
                GButton(
                  icon: LineIcons.user,
                  text: 'Profile',
                  textStyle: TextStyle(color: Pallete.whiteColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
