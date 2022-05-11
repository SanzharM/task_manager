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
import 'package:task_manager/core/supporting/app_router.dart';
import 'package:task_manager/core/utils.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/pages/voice_authentication/bloc/voice_authentication_bloc.dart';

typedef _Fn = void Function();

const theSource = AudioSource.microphone;

class VoiceAuthenticationPage extends StatefulWidget {
  const VoiceAuthenticationPage({Key? key}) : super(key: key);

  @override
  State<VoiceAuthenticationPage> createState() => _VoiceAuthenticationPageState();
}

class _VoiceAuthenticationPageState extends State<VoiceAuthenticationPage> {
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
    _mPlayer!.openPlayer().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });

    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });
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

  void record() {
    _startTimer();
    _mRecorder!
        .startRecorder(
      toFile: _mPath,
      codec: _codec,
      audioSource: theSource,
    )
        .then((value) {
      setState(() {});
    });
  }

  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((url) async {
      if (url != null && url.isNotEmpty) {
        try {
          _bloc.authByVoice(File(url));
        } catch (e) {
          print('$e');
        }
      }
      setState(() => _mplaybackReady = true);
    });
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
    return Scaffold(
      appBar: AppBar(leading: AppBackButton()),
      body: BlocListener(
        bloc: _bloc,
        listener: (context, state) {
          isLoading = state is AuthenticationProcessing;

          if (state is ErrorState) {
            AlertController.showSnackbar(context: context, message: state.error);
          }

          if (state is VoiceAuthenticationSucceeded) {
            AppRouter.toMainPage(context);
            AlertController.showSnackbar(context: context, message: state.message);
          }

          setState(() {});
        },
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: Padding(
                //     padding: const EdgeInsets.all(16.0),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.end,
                //       children: [
                //         Text('Recording controller', style: const TextStyle(fontSize: 18.0)),
                //         const EmptyBox(height: 12.0),
                //         CupertinoButton(
                //           padding: EdgeInsets.zero,
                //           child: _mPlayer!.isPlaying
                //               ? const Icon(CupertinoIcons.pause_circle, size: 32.0)
                //               : const Icon(CupertinoIcons.play_circle, size: 32.0),
                //           onPressed: getPlaybackFn(),
                //         ),
                //         Text(_mPlayer!.isPlaying ? 'Playback in progress' : 'Player is stopped'),
                //       ],
                //     ),
                //   ),
                // ),
                Spacer(),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Application.isDarkMode(context) ? AppColors.lightGrey : AppColors.darkGrey,
                      border: Border.all(color: AppColors.lightAction, width: 0.5),
                    ),
                    child: AvatarGlow(
                      endRadius: (Theme.of(context).iconTheme.size ?? 32.0) + 32.0,
                      animate: _mRecorder!.isRecording,
                      glowColor: AppColors.lightAction,
                      repeatPauseDuration: Duration.zero,
                      duration: const Duration(milliseconds: 1400),
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
                Spacer(),
                Center(
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: _mRecorder!.isRecording
                        ? const Icon(CupertinoIcons.mic_off, size: 32.0)
                        : const Icon(CupertinoIcons.mic_fill, size: 32.0),
                    onPressed: getRecorderFn(),
                  ),
                ),
                const EmptyBox(height: 32.0),
              ],
            ),
            if (isLoading)
              AnimatedOpacity(
                opacity: isLoading ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  color: AppColors.metal.withOpacity(0.75),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 32, maxWidth: 32),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
