import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lili_app/component/app_bar.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/component/loading.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/constant/data.dart';
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
    final isFrontCamera = useState<bool>(true);
    final picture = useState<Uint8List?>(null);
    final isLoading = useState<bool>(false);
    final timeMessage = useState<String?>("");
    final isTakePictureLoading = useState<bool>(false);
    final isWakeUp = myProfile.postList.wakeUp == null;
    final camControllerState =
        useState<CamControllerState>(CamControllerState.unInitialize);
    Timer? timer;
    void startTimer(PostTimeType postTime) {
      final time = convertTimeStringToDateTime(postTimeData[postTime]!, null);
      final targetTime = time.add(const Duration(minutes: 10));
      timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) => timeMessageUpData(
          timeMessage,
          targetTime,
          onTimeOut: () => timer.cancel(),
        ),
      );
    }

    useEffect(
      () {
        cameraControllerInitialize(context, camControllerState, isFrontCamera);
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (isWakeUp) {
            timeMessage.value = "おはようございます！";
          } else {
            final postTime = getPostTimeType(DateTime.now());
            if (postTime == null) {
              timeMessage.value = null;
            } else {
              startTimer(postTime);
            }
          }
        });
        return () {
          cameraController?.dispose();
          timer?.cancel();
        };
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
          body: Stack(
            children: [
              SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: customPadding(bottom: safeAreaHeight * 0.02),
                        child: nText(
                          timeMessage.value ?? "",
                          fontSize: timeMessage.value == "おはようございます！"
                              ? safeAreaWidth / 25
                              : safeAreaWidth / 17,
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
                                            cancelOnTap: () =>
                                                picture.value = null,
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
                                                      BorderRadius.circular(
                                                    40,
                                                  ),
                                                  child: RepaintBoundary(
                                                    key: repaintBoundaryKey,
                                                    child: CameraPreview(
                                                      cameraController!,
                                                    ),
                                                  ),
                                                );
                                              case CamControllerState
                                                    .systemError:
                                                return photographPageSystemErrorWidget(
                                                  context,
                                                  onTap: () =>
                                                      cameraControllerInitialize(
                                                    context,
                                                    camControllerState,
                                                    isFrontCamera,
                                                  ),
                                                );
                                              case CamControllerState
                                                    .accessError:
                                                return photographPageAccessErrorWidget(
                                                  context,
                                                );
                                              case CamControllerState
                                                    .unInitialize:
                                                return const SizedBox();
                                            }
                                          }(),
                                  ),
                                  if (picture.value == null)
                                    AnimatedOpacity(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      opacity:
                                          isTakePictureLoading.value ? 1 : 0,
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
                                flashTapEvent: (value) {
                                  final flashMode =
                                      value ? FlashMode.torch : FlashMode.off;
                                  cameraController?.setFlashMode(flashMode);
                                },
                                returnTapEvent: () =>
                                    cameraControllerInitialize(
                                  context,
                                  camControllerState,
                                  isFrontCamera,
                                ),
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
              if (timeMessage.value == null) timeOutWidget(context),
            ],
          ),
        ),
        loadinPage(context: context, isLoading: isLoading.value),
      ],
    );
  }

  Future<void> cameraControllerInitialize(
    BuildContext context,
    ValueNotifier<CamControllerState> camControllerState,
    ValueNotifier<bool> isFrontCamera,
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
      try {
        if (!isFrontCamera.value) {
          final frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
            orElse: () => cameras.first,
          );
          cameraController =
              CameraController(frontCamera, ResolutionPreset.medium);
          await cameraController?.initialize();
          isFrontCamera.value = true;
        } else {
          cameraController =
              CameraController(cameras.first, ResolutionPreset.medium);
          await cameraController?.initialize();
          isFrontCamera.value = false;
        }

        camControllerState.value = CamControllerState.success;
      } catch (error) {
        camControllerState.value = CamControllerState.systemError;
        cameraController?.dispose();
      }
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
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        "${file.absolute.path}_bubu.jpg",
        quality: 60,
      );
      if (!context.mounted) return;
      if (compressedFile == null) {
        errorAlertDialog(context, subTitle: eMessageSystem);
        return;
      }
      final fileImg = File(compressedFile.path);
      final postUpload = isWakeUp
          ? await dbStorageWakeUpPostUpload(
              id: myProfile.openId,
              img: fileImg,
              onError: () {
                errorAlertDialog(context, subTitle: eMessageSystem);
              },
            )
          : await dbStoragePostUpload(
              nowTime: nowTime,
              id: myProfile.openId,
              img: fileImg,
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
      final postTimeType =
          isWakeUp ? PostTimeType.wakeUp : getPostTimeType(nowTime)!;
      final postListData = postListTypeUpDate(
        myProfile.postList,
        postTimeType,
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
      await localWritePastPostData(
        postTimeType,
        PastPostType(
          postImg: fileImg,
          doing: nowState,
          postDateTime: nowTime,
        ),
      );
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

  void timeMessageUpData(
    ValueNotifier<String?> timeMessage,
    DateTime targetTime, {
    VoidCallback? onTimeOut,
  }) {
    final now = DateTime.now();
    final timer = targetTime.difference(now);
    if (timer.isNegative) {
      timeMessage.value = null;
      onTimeOut?.call();
    } else {
      timeMessage.value = formatDuration(timer);
    }
  }
}
