import 'dart:async';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:task_manager/core/alert_controller.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/constants/app_constraints.dart';
import 'package:task_manager/core/supporting/app_router.dart';
import 'package:task_manager/core/utils.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/pages/voice_authentication/bloc/voice_authentication_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

typedef _Fn = void Function();

const theSource = AudioSource.microphone;

enum AuthMode { register, login }

class VoiceAuthenticationPage extends StatefulWidget {
  const VoiceAuthenticationPage({
    Key? key,
    this.mode = AuthMode.login,
    this.canEscape = true,
    this.needAppBar = true,
    this.onNext,
  }) : super(key: key);

  final AuthMode mode;
  final bool canEscape;
  final bool needAppBar;
  final void Function()? onNext;

  @override
  State<VoiceAuthenticationPage> createState() => _VoiceAuthenticationPageState();
}

class _VoiceAuthenticationPageState extends State<VoiceAuthenticationPage> with TickerProviderStateMixin {
  final _bloc = VoiceAuthenticationBloc();

  Codec _codec = Codec.aacMP4;
  String _mPath = 'tau_file.mp4';
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;

  Timer? _timer;
  int _minutes = 0;
  int _timerSeconds = 0;

  bool isLoading = false;

  bool _hasVoiceRegistered = false;
  late AuthMode _mode;

  String text =
      'I can’t say enough about these headphones. They’re excellent for the gym! They don’t fall off and aren’t uncomfortable after a while. The sound is amazing and the controls are easy to use without needing your phone picked up.';

  late AnimationController _animationController;
  late Animation<AlignmentGeometry> _animation;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds >= 0 && _timerSeconds <= 59) {
        setState(() => _timerSeconds++);
      } else if (_timerSeconds == 60) {
        setState(() {
          _minutes++;
          _timerSeconds = 0;
        });
      }
    });
  }

  void _endTimer() => setState(() {
        _timer?.cancel();
        _timer = null;
        _minutes = 0;
        _timerSeconds = 0;
      });

  @override
  void initState() {
    _bloc.getTexts();
    _mode = widget.mode;

    _mPlayer!.openPlayer().then((value) {
      setState(() => _mPlayerIsInited = true);
    });

    openTheRecorder().then((value) {
      setState(() => _mRecorderIsInited = true);
    });

    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _animation = Tween<AlignmentGeometry>(begin: Alignment.center, end: Alignment.topRight)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    super.initState();
  }

  @override
  void dispose() {
    _mPlayer!.closePlayer();
    _mPlayer = null;

    _mRecorder!.closeRecorder();
    _mRecorder = null;

    _bloc.close();
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder!.openRecorder();
    if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      _mPath = 'tau_file.mp4';
      if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInited = true;
        return;
      }
    }
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.allowBluetooth | AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _mRecorderIsInited = true;
  }

  // ----------------------  Here is the code for recording and playback -------

  bool isRecordingShort(int seconds) => (_timer?.tick ?? 0) < seconds || (_minutes == 0 && _timerSeconds < seconds);

  void record() {
    _startTimer();
    _animationController.forward();
    _mRecorder!.startRecorder(toFile: _mPath, codec: _codec, audioSource: theSource).then((value) => setState(() {}));
  }

  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((url) async {
      if (url != null && url.isNotEmpty) {
        switch (_mode) {
          case AuthMode.login:
            if (isRecordingShort(5)) {
              return AlertController.showResultDialog(
                context: context,
                message: 'recording_too_short_for_login'.tr(),
                isSuccess: null,
              );
            }
            _bloc.authByVoice(File(url));
            return;
          case AuthMode.register:
            if (isRecordingShort(15)) {
              return AlertController.showResultDialog(
                context: context,
                message: 'recording_too_short_for_registration'.tr(),
                isSuccess: null,
              );
            }
            _bloc.registerVoice(File(url));
            return;
        }
      }
      setState(() => _mplaybackReady = true);
    });

    _animationController.reverse();
    _endTimer();
  }

  void play() {
    assert(_mPlayerIsInited && _mplaybackReady && _mRecorder!.isStopped && _mPlayer!.isStopped);
    _mPlayer!
        .startPlayer(
            fromURI: _mPath,
            //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
            whenFinished: () {
              setState(() {});
            })
        .then((value) {
      setState(() {});
    });
  }

  void stopPlayer() {
    _mPlayer!.stopPlayer().then((value) {
      setState(() {});
    });
  }

// ----------------------------- UI --------------------------------------------

  _Fn? getRecorderFn() {
    if (!_mRecorderIsInited || !_mPlayer!.isStopped) {
      return null;
    }

    return _mRecorder!.isStopped ? record : stopRecorder;
  }

  _Fn? getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder!.isStopped) {
      return null;
    }
    return _mPlayer!.isStopped ? play : stopPlayer;
  }

  @override
  Widget build(BuildContext context) {
    final fullWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: !widget.needAppBar
          ? null
          : AppBar(
              leading: AppBackButton(
                onBack: () async {
                  if (widget.mode == AuthMode.login && !widget.canEscape) {
                    return await AlertController.showNativeDialog(
                      context: context,
                      title: 'confirm_logout'.tr(),
                      onNo: () => Navigator.of(context).pop(),
                      onYes: () => Application.logout(context),
                    );
                  }
                  Navigator.of(context).pop();
                  return;
                },
              ),
            ),
      body: BlocListener(
        bloc: _bloc,
        listener: (context, state) async {
          isLoading = state is AuthenticationProcessing;

          if (state is ErrorState) {
            if (state.error == 'wrong_attempts_limited') {
              setState(() {});
              Application.logout(context);
              return AlertController.showResultDialog(
                context: context,
                message: 'wrong_attempts_limited'.tr(),
                isSuccess: null,
              );
            }
            AlertController.showResultDialog(context: context, message: state.error, isSuccess: null);
          }

          if (state is VoiceAuthenticationSucceeded) {
            await AlertController.showResultDialog(context: context, message: state.message);
            if (widget.onNext != null) return widget.onNext!();
            if (await Application.getPin() == null) await AppRouter.toPinPage(context, shouldSetupPin: true);
            AppRouter.toMainPage(context);
          }

          if (state is VoiceAuthenticationRegistered) {
            _hasVoiceRegistered = true;
            _mode = AuthMode.login;
            AlertController.showResultDialog(context: context, message: state.message);
            _bloc.getTexts();
          }

          if (state is RecordedVoiceChecked) {
            _hasVoiceRegistered = state.hasVoice;
            if (_hasVoiceRegistered)
              _mode = AuthMode.login;
            else
              _mode = AuthMode.register;
          }

          if (state is VoiceDeleted) {
            _hasVoiceRegistered = false;
            AlertController.showResultDialog(context: context, message: 'Voice recording was deleted', isSuccess: false);
          }

          if (state is VoiceAuthTextLoaded) {
            text = state.text;
          }

          setState(() {});
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Speak at least ${_mode == AuthMode.login ? '5' : '15'} seconds.',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            if (_mRecorder!.isRecording)
              AnimatedOpacity(
                opacity: _mRecorder!.isRecording ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                          alignment: Alignment.centerLeft,
                          height: 2.0,
                          width: _mode == AuthMode.login ? (_timerSeconds * (fullWidth * 0.2)) : (_timerSeconds * (fullWidth * 0.1)),
                          decoration: BoxDecoration(borderRadius: AppConstraints.borderRadius, color: AppColors.success),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16.0, 56.0, 48.0, 16.0),
                          child: Text(
                            'Support text:\n' + text,
                            style: const TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                      const EmptyBox(height: 148.0),
                    ],
                  ),
                ),
              ),
            AlignTransition(
              alignment: _animation,
              child: GestureDetector(
                onTap: () {
                  if (_animationController.value == 1)
                    _animationController.reverse();
                  else
                    _animationController.forward();
                  getRecorderFn();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: _mRecorder!.isRecording ? const EdgeInsets.all(16.0) : const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Application.isDarkMode(context) ? AppColors.lightGrey : AppColors.darkGrey,
                    border: Border.all(color: AppColors.lightAction, width: 0.5),
                  ),
                  child: Text(
                    '${Utils.getTimerNumber(_minutes)}:${Utils.getTimerNumber(_timerSeconds)}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Application.isDarkMode(context) ? AppColors.darkGrey : AppColors.lightGrey,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CupertinoButton(
                padding: const EdgeInsets.only(bottom: 32.0),
                onPressed: getRecorderFn(),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Application.isDarkMode(context) ? AppColors.metal : AppColors.darkGrey,
                      width: 0.5,
                    ),
                  ),
                  child: AvatarGlow(
                    endRadius: (Theme.of(context).iconTheme.size ?? 32.0) + 32.0,
                    animate: _mRecorder!.isRecording,
                    glowColor: Application.isDarkMode(context) ? AppColors.darkAction : AppColors.lightAction,
                    repeatPauseDuration: Duration.zero,
                    duration: const Duration(milliseconds: 1400),
                    child: _mRecorder!.isRecording
                        ? const Icon(CupertinoIcons.mic_off, size: 32.0)
                        : const Icon(CupertinoIcons.mic_fill, size: 32.0),
                  ),
                ),
              ),
            ),
            if (isLoading)
              AnimatedOpacity(
                opacity: isLoading ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  color: Application.isDarkMode(context) ? AppColors.metal.withOpacity(0.33) : AppColors.darkGrey.withOpacity(0.33),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 32, maxWidth: 32),
                    child: const CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
