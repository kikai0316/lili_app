import 'package:lili_app/model/model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'all_friends.g.dart';

@Riverpod(keepAlive: true)
class AllFriendsNotifier extends _$AllFriendsNotifier {
  @override
  Future<List<UserType>?> build() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return [];
    //  [f1(), f2()];
  }
}

// UserType f1() {
//   return UserType(
//     userId: "daisuke_0315",
//     name: "fwskdvmwsdlvm",
//     openId: "mdlmvldmclmdlvmldmvldm",
//     toDayMood: "😍",
//     img:
//         "https://i.pinimg.com/474x/89/99/8b/89998be7b88e48e828d25c1a7da653db.jpg",
//     postList: f1dummyData(),
//   );
// }

// PostListType f1dummyData() {
//   final DateTime sevenAM = DateTime.now();
//   return PostListType(
//     wakeUp: PostType(
//       dateText: "起床",
//       doing: "移動中",
//       postDateTime: DateTime(sevenAM.year, sevenAM.month, sevenAM.day, 12),
//       postImg:
//           "https://i.pinimg.com/474x/d8/05/e5/d805e534e773b808cc7ff685cbdba1c7.jpg",
//     ),
//     pm15: PostType(
//       dateText: "15:00",
//       postDateTime: DateTime(sevenAM.year, sevenAM.month, sevenAM.day, 10),
//       postImg:
//           "https://i.pinimg.com/474x/1d/c4/f9/1dc4f936a80d3af8ce019ea9fd1ce956.jpg",
//     ),
//     pm18: PostType(
//       doing: "移動中",
//       dateText: "18:00",
//       postDateTime: DateTime(sevenAM.year, sevenAM.month, sevenAM.day, 10),
//       postImg:
//           "https://i.pinimg.com/474x/40/8b/c0/408bc0849dd6f0df70ee828ca4917508.jpg",
//     ),
//   );
// }

// UserType f2() {
//   return UserType(
//     userId: "daisuke_0315",
//     name: "fwskdvmwsdlvm",
//     openId: "mdlmvldmclmdlvmldmvldm",
//     toDayMood: "😍",
//     img:
//         "https://i.pinimg.com/474x/d2/84/a3/d284a3f4c649c7811d6dce2de3a55c61.jpg",
//     postList: f2dummyData(),
//   );
// }

// PostListType f2dummyData() {
//   final DateTime sevenAM = DateTime.now();
//   return PostListType(
//     wakeUp: PostType(
//       dateText: "起床",
//       doing: "移動中",
//       postDateTime: DateTime(sevenAM.year, sevenAM.month, sevenAM.day, 6),
//       postImg:
//           "https://i.pinimg.com/474x/98/a1/32/98a132af51cdd0d06880e17a30c7f45e.jpg",
//     ),
//     am7: PostType(
//       dateText: "15:00",
//       postDateTime: DateTime(sevenAM.year, sevenAM.month, sevenAM.day, 10),
//       postImg:
//           "https://i.pinimg.com/474x/1d/c4/f9/1dc4f936a80d3af8ce019ea9fd1ce956.jpg",
//     ),
//     am10: PostType(
//       dateText: "15:00",
//       doing: "移動中",
//       postDateTime: DateTime(sevenAM.year, sevenAM.month, sevenAM.day, 10),
//       postImg:
//           "https://i.pinimg.com/474x/1d/c4/f9/1dc4f936a80d3af8ce019ea9fd1ce956.jpg",
//     ),
//     pm15: PostType(
//       dateText: "15:00",
//       doing: "移動中",
//       postDateTime: DateTime(sevenAM.year, sevenAM.month, sevenAM.day, 10),
//       postImg:
//           "https://i.pinimg.com/474x/1d/c4/f9/1dc4f936a80d3af8ce019ea9fd1ce956.jpg",
//     ),
//     pm18: PostType(
//       dateText: "18:00",
//       doing: "移動中",
//       postDateTime: DateTime(sevenAM.year, sevenAM.month, sevenAM.day, 10),
//       postImg:
//           "https://i.pinimg.com/474x/40/8b/c0/408bc0849dd6f0df70ee828ca4917508.jpg",
//     ),
//   );
// }
