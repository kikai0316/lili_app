import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/app_bar.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/permission_utlity.dart';
import 'package:lili_app/widget/photograph_page.dart';

CameraController? cameraController;

class PhotographPage extends HookConsumerWidget {
  const PhotographPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final isFlash = useState<bool>(false);
    final camControllerState =
        useState<CamControllerState>(CamControllerState.unInitialize);

    useEffect(
      () {
        cameraControllerInitialize(context, camControllerState);
        return () => cameraController?.dispose();
      },
      [],
    );
    return Scaffold(
      backgroundColor: mainBackGroundColor,
      appBar: nAppBar(
        context,
        customTitle: nText(
          "RoyalHy",
          fontSize: safeAreaWidth / 14,
        ),
      ),
      body: Center(
        child: Padding(
          padding: xPadding(
            context,
          ),
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
                child: () {
                  switch (camControllerState.value) {
                    case CamControllerState.success:
                      return photographPageSuccessWidget(
                        context,
                        cameraController!,
                        isFlash,
                      );
                    case CamControllerState.systemError:
                      return photographPageSystemErrorWidget(
                        context,
                        onTap: () => cameraControllerInitialize(
                          context,
                          camControllerState,
                        ),
                      );
                    case CamControllerState.accessError:
                      return photographPageAccessErrorWidget(context);
                    case CamControllerState.unInitialize:
                      return Center(
                        child: photographPageLoagingWidget(context),
                      );
                  }
                }(),
              ),
            ],
          ),
        ),
      ),
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
}
