import 'dart:async';
import 'package:lili_app/model/model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_data.g.dart';

@Riverpod(keepAlive: true)
class UserDataNotifier extends _$UserDataNotifier {
  @override
  Future<UserType?> build() async {
    return UserType(
      name: "daisuke_0315",
      id: "fwskdvmwsdlvm",
      toDayMood: "😭",
      profileImg:
          "https://i.pinimg.com/564x/e2/e1/b3/e2e1b383b649b5e40837db655bbe562e.jpg",
      postList: dummyData(),
    );
  }
}

PostListType dummyData() {
  final DateTime sevenAM = DateTime.now();
  return PostListType(
    wakeUp: PostType(
      dateText: "起床",
      postDateTime: DateTime(sevenAM.year, sevenAM.month, sevenAM.day, 8),
      postImg:
          "https://i.pinimg.com/474x/d8/05/e5/d805e534e773b808cc7ff685cbdba1c7.jpg",
    ),
    am10: PostType(
      dateText: "10:00",
      postDateTime:
          DateTime(sevenAM.year, sevenAM.month, sevenAM.day, 10),
      postImg:
          "https://i.pinimg.com/474x/5a/16/0c/5a160cf5a3736110b473fc2f95624869.jpg",
    ),
    pm12: PostType(
      dateText: "12:00",
      postDateTime:
          DateTime(sevenAM.year, sevenAM.month, sevenAM.day, 10),
      postImg:
          "https://i.pinimg.com/474x/e3/70/1f/e3701fd085fd63c652d5bc6c6aeb5484.jpg",
    ),
    pm15: PostType(
      dateText: "15:00",
      postDateTime:
          DateTime(sevenAM.year, sevenAM.month, sevenAM.day, 10),
      postImg:
          "https://i.pinimg.com/474x/1d/c4/f9/1dc4f936a80d3af8ce019ea9fd1ce956.jpg",
    ),
  );
}
