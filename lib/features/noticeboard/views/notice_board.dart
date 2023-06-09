import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:mlrcc/features/home/home_widgets.dart';
import 'package:mlrcc/features/noticeboard/controller/nb_posts_controller.dart';
import 'package:mlrcc/theme/pallete.dart';

import '../../../common/app_bar.dart';

class NoticeBoardView extends ConsumerStatefulWidget {
  const NoticeBoardView({Key? key}) : super(key: key);

  @override
  ConsumerState<NoticeBoardView> createState() => _NoticeBoardViewState();
}

class _NoticeBoardViewState extends ConsumerState<NoticeBoardView> {
  @override
  @override
  Widget build(BuildContext context) {
    final nbData = ref.watch(nBPostsDataProvider)!;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LiquidPullToRefresh(
            color: Pallete.accentColor,
            onRefresh: () async {
              ref.watch(nBPostsControllerProvider.notifier).getNBPosts(context);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(
                  title: 'Notice Board',
                ),
                SizedBox(
                  height: size.height * 0.72,
                  child: ListView.builder(
                      itemCount: nbData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return NoticeBoardCard(size, nbData[index].hastag,
                            nbData[index].title, nbData[index].description);
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
