import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/constant/data.dart';
import 'package:lili_app/constant/img.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/firebase/firebase_firestore_utility.dart';
import 'package:lili_app/utility/firebase/firebase_storage_utility.dart';
import 'package:lili_app/utility/type_updata_utility.dart';
import 'package:lili_app/view_model/all_friends.dart';
import 'package:lili_app/view_model/post_timer.dart';
import 'package:lili_app/view_model/user_data.dart';

class HomePage2 extends HookConsumerWidget {
  const HomePage2({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final selectIndex = useState<int>(0);

    return SafeArea(
      bottom: false,
      child: Scaffold(
        extendBody: true,
        backgroundColor: mainBackGroundColor,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: StaggeredGrid.count(
                crossAxisCount: 6,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                children: [
                  for (int i = 0; i < postSizeList.length; i++)
                    StaggeredGridTile.count(
                      crossAxisCellCount: postSizeList[i],
                      mainAxisCellCount: postSizeList[i],
                      child: imgWidget(
                        borderRadius: 15,
                        networkUrl:
                            "https://i.pinimg.com/474x/8f/9b/1a/8f9b1aac68c19c782a8e22a60a52007f.jpg",
                      ),
                    ),
                  SizedBox(
                    height: safeAreaHeight * 0.02,
                  ),
                ],
              ),
            ),
            Padding(
              padding: yPadding(context),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Opacity(
                    opacity: 0.7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        logoWidget(context),
                        Padding(
                          padding: yPadding(
                            context,
                            ySize: safeAreaHeight * 0.005,
                            left: safeAreaWidth * 0.02,
                          ),
                          child: nText(
                            "2023/03/16",
                            fontSize: safeAreaWidth / 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: xPadding(
              context,
              xSize: safeAreaWidth * 0.01,
              bottom: safeAreaHeight * 0.02,
            ),
            child: nContainer(
              padding: xPadding(context, xSize: safeAreaWidth * 0.005),
              height: safeAreaHeight * 0.065,
              width: safeAreaWidth,
              radius: 50,
              color: Colors.black.withOpacity(0.8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < postTimeData.values.length; i++)
                      onTag(
                        context,
                        isSelect: i == selectIndex.value,
                        text: postTimeData.values.elementAt(i),
                        onTap: () => selectIndex.value = i,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> reFetch(WidgetRef ref, UserType myProfile) async {
    final userData = ref.read(userDataNotifierProvider.notifier);
    final allFriendsNotifier = ref.read(allFriendsNotifierProvider.notifier);
    final postTimerNotifier = ref.read(postTimerNotifierProvider.notifier);
    final profileData = await dbFirestoreReadUser(myProfile.openId);
    if (profileData == null) return;
    final postData =
        await dbStoragePostDownload(id: profileData.openId) ?? PostListType();
    await allFriendsNotifier.reFetch(profileData.friendList);
    final setUserData = userTypeUpDate(profileData, postListType: postData);
    await userData.userDataUpDate(setUserData);
    postTimerNotifier.timerPeriodic();
  }
}
