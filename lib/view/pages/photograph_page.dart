import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lili_app/component/app_bar.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/component/loading.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/constant/message.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/data_format_utility.dart';
import 'package:lili_app/utility/firebase/firebase_storage_utility.dart';
import 'package:lili_app/utility/notistack_utility.dart';
import 'package:lili_app/utility/path_provider_utility.dart';
import 'package:lili_app/utility/permission_utlity.dart';
import 'package:lili_app/utility/type_updata_utility.dart';
import 'package:lili_app/utility/utility.dart';
import 'package:lili_app/view/pages/now_state_sheet.dart';
import 'package:lili_app/view_model/user_data.dart';
import 'package:lili_app/widget/photograph_page.dart';
import 'package:permission_handler/permission_handler.dart';

CameraController? cameraController;
GlobalKey repaintBoundaryKey = GlobalKey();

class PhotographPage extends HookConsumerWidget {
  const PhotographPage({
    super.key,
    required this.myProfile,
  });
  final UserType myProfile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final isFlash = useState<bool>(false);
    final picture = useState<Uint8List?>(null);
    final isLoading = useState<bool>(false);
    final isTakePictureLoading = useState<bool>(false);
    final isWakeUp = myProfile.postList.wakeUp == null;
    final camControllerState =
        useState<CamControllerState>(CamControllerState.unInitialize);

    useEffect(
      () {
        cameraControllerInitialize(context, camControllerState);
        return () => cameraController?.dispose();
      },
      [],
    );
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: mainBackGroundColor,
          appBar: nAppBar(
            context,
            leftIconType: BackIconStyleType.arrowBackBottomIcon,
            customTitle: nText(
              "RoyalHy",
              fontSize: safeAreaWidth / 14,
            ),
          ),
          body: SafeArea(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: customPadding(bottom: safeAreaHeight * 0.02),
                    child: nText(
                      "03:01",
                      fontSize: safeAreaWidth / 17,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 3 / 4,
                          child: Stack(
                            children: [
                              SizedBox(
                                child: picture.value != null
                                    ? afterTakingPhoto(
                                        context,
                                        picture.value!,
                                        cancelOnTap: () => picture.value = null,
                                        saveOnTap: () => saveImageToGallery(
                                          context,
                                          picture.value!,
                                          isLoading,
                                        ),
                                      )
                                    : () {
                                        switch (camControllerState.value) {
                                          case CamControllerState.success:
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              child: imgWidget(
                                                size: double.infinity,
                                                assetFile: "photograph.png",
                                              ),
                                            );
                                          // case CamControllerState.systemError:
                                          //   return photographPageSystemErrorWidget(
                                          //     context,
                                          //     onTap: () => cameraControllerInitialize(
                                          //       context,
                                          //       camControllerState,
                                          //     ),
                                          //   );
                                          // case CamControllerState.accessError:
                                          //   return photographPageAccessErrorWidget(context);
                                          // case CamControllerState.unInitialize:
                                          //   return Center(
                                          //     child: photographPageLoagingWidget(context),
                                          //   );
                                          default:
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              child: RepaintBoundary(
                                                key: repaintBoundaryKey,
                                                child: imgWidget(
                                                  size: double.infinity,
                                                  assetFile: "photograph.png",
                                                ),
                                              ),
                                            );
                                        }
                                      }(),
                              ),
                              if (picture.value == null)
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 100),
                                  opacity: isTakePictureLoading.value ? 1 : 0,
                                  child: nContainer(
                                    height: double.infinity,
                                    color: Colors.black,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (picture.value == null)
                          photographShootingButtonWidget(
                            context,
                            isAccess: camControllerState.value ==
                                CamControllerState.success,
                            isFlash: isFlash,
                            flashTapEvent: (valiue) {},
                            returnTapEvent: () {},
                            shootingTapEvent: () => takePicture(
                              context,
                              picture,
                              isTakePictureLoading,
                            ),
                          ),
                        if (picture.value != null)
                          photographPostButtonWidget(
                            context,
                            picture: picture,
                            postTapEvent: isWakeUp
                                ? () => postEvent(
                                      context,
                                      ref,
                                      picture.value!,
                                      isLoading,
                                      "",
                                      true,
                                    )
                                : () => bottomSheet(
                                      context,
                                      page: NowStateSheet(
                                        onSuccess: (value) => postEvent(
                                          context,
                                          ref,
                                          picture.value!,
                                          isLoading,
                                          value,
                                          false,
                                        ),
                                      ),
                                    ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        loadinPage(context: context, isLoading: isLoading.value),
      ],
    );
  }

  Future<void> cameraControllerInitialize(
    BuildContext context,
    ValueNotifier<CamControllerState> camControllerState,
  ) async {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final isPermission = await checkCameraPermission();
      if (!context.mounted) return;
      if (!isPermission) {
        camControllerState.value = CamControllerState.accessError;
        return;
      }
      final cameras = await availableCameras();
      if (!context.mounted) return;
      cameraController =
          CameraController(cameras.first, ResolutionPreset.medium);
      cameraController
          ?.initialize()
          .then((_) => camControllerState.value = CamControllerState.success)
          .onError(
            (error, stackTrace) =>
                camControllerState.value = CamControllerState.systemError,
          );
    });
  }

  Future<void> takePicture(
    BuildContext context,
    ValueNotifier<Uint8List?> picture,
    ValueNotifier<bool> isLoading,
  ) async {
    try {
      isLoading.value = true;
      final RenderRepaintBoundary boundary = repaintBoundaryKey.currentContext!
          .findRenderObject()! as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (!context.mounted) return;
      if (byteData == null) {
        isLoading.value = false;
        return;
      }
      isLoading.value = false;
      picture.value = byteData.buffer.asUint8List();
    } catch (e) {
      isLoading.value = false;
      return;
    }
  }

  Future<void> saveImageToGallery(
    BuildContext context,
    Uint8List imageBytes,
    ValueNotifier<bool> isLoading,
  ) async {
    try {
      isLoading.value = true;
      final isPermission = await checkPhotoPermission();
      if (!context.mounted) return;
      if (!isPermission) {
        isLoading.value = false;
        showAlertDialog(
          context,
          title: "カメラへのアクセス権がありません。",
          subTitle: eMessageNotPhotoPermission,
          rightButtonText: "設定画面へ",
          leftButtonText: "キャンセル",
          rightButtonOnTap: () => openAppSettings(),
        );
        return;
      }
      await ImageGallerySaver.saveImage(imageBytes);
      if (!context.mounted) return;
      isLoading.value = false;
      showAlertDialog(
        context,
        title: "保存が完了しました",
        leftButtonText: "とじる",
      );
    } catch (e) {
      isLoading.value = false;
      errorAlertDialog(context, subTitle: eMessageSystem);
      return;
    }
  }

  Future<void> postEvent(
    BuildContext context,
    WidgetRef ref,
    Uint8List imageBytes,
    ValueNotifier<bool> isLoading,
    String nowState,
    bool isWakeUp,
  ) async {
    try {
      isLoading.value = true;
      final nowTime = DateTime.now();
      final File file = await localFile("captured_image.png");
      await file.writeAsBytes(
        imageBytes,
      );
      if (!context.mounted) return;
      final postUpload = isWakeUp
          ? await dbStorageWakeUpPostUpload(
              id: myProfile.openId,
              img: file,
              onError: () =>
                  errorAlertDialog(context, subTitle: eMessageSystem),
            )
          : await dbStoragePostUpload(
              nowTime: nowTime,
              id: myProfile.openId,
              img: file,
              nowState: nowState,
              onTimeOut: () {
                isLoading.value = false;
                errorAlertDialog(
                  context,
                  subTitle: "投稿時間が過ぎてしまいました。次の投稿時間までお待ちください。",
                );
              },
              onError: () {
                isLoading.value = false;
                errorAlertDialog(context, subTitle: eMessageSystem);
              },
            );
      if (!context.mounted || postUpload == null) return;
      final postListData = postListTypeUpDate(
        myProfile.postList,
        isWakeUp ? PostTimeType.wakeUp : getPostTimeType(nowTime)!,
        PostType(
          postImg: postUpload,
          postDateTime: nowTime,
          doing: nowState,
        ),
      );
      final userDataNotifier = ref.read(userDataNotifierProvider.notifier);
      await userDataNotifier.userDataUpDate(
        userTypeUpDate(myProfile, postListType: postListData),
      );
      await localWritePostData(postListData);
      if (!context.mounted) return;
      isLoading.value = false;
      Navigator.pop(context);
      successSnackbar(context, "投稿のアップロードに成功しました！");
    } catch (e) {
      if (!context.mounted) return;
      isLoading.value = false;
      errorAlertDialog(context, subTitle: eMessageSystem);
    }
  }
}
