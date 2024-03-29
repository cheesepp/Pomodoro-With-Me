import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:pomodoro/providers/category_component.dart';
import 'package:pomodoro/services/auth_methods.dart';
import 'package:pomodoro/services/firebase_services.dart';
import 'package:pomodoro/services/storage_data.dart';
import 'package:pomodoro/utils/ThemeColor.dart';
import 'package:pomodoro/widgets/digital_clock.dart';
import 'package:pomodoro/widgets/notification_dialog_widget.dart';
import 'package:pomodoro/widgets/settings_drawer.dart';
import 'package:pomodoro/widgets/video_player_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:volume_controller/volume_controller.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'components_detail_screen.dart/tomato_rounds.dart';
import 'components_detail_screen.dart/widgets/detail_header.dart';
import 'components_detail_screen.dart/widgets/label_video.dart';

class ComponentDetailScreen extends StatefulWidget {
  static const routeName = 'component-detail';
  final CategoryComponent component;

  const ComponentDetailScreen({Key? key, required this.component})
      : super(key: key);

  @override
  State<ComponentDetailScreen> createState() => _ComponentDetailScreenState();
}

class _ComponentDetailScreenState extends State<ComponentDetailScreen>
    with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  double _setVolumeValue = 0;
  int rounds = 5;
  int initRounds = 5;
  Duration learningDuration = const Duration(minutes: 25);
  Duration breakingDuration = const Duration(minutes: 5);
  Timer? learningTimer;
  Timer? breakingTimer;

  String twoDigits(int n) => n.toString().padLeft(2, '0');
  late AnimationController controller;
  bool isMuted = false;
  bool isPlaying = false;
  bool isBreaking = false;
  bool isLearningCompleted = false;
  bool isBreakingCompleted = true;
  Duration? _selectedDuration;
  TextEditingController roundsController = TextEditingController();
  VideoPlayerController? videoController;

  int secondsLearned = 0;

  @override
  void initState() {
    videoController = VideoPlayerController.network(widget.component.videoUrl)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((value) => videoController!.pause());

    VolumeController().getVolume().then((volume) => _setVolumeValue = volume);
    learningDuration =
        Duration(minutes: SavingDataLocally.getLearningDuration());
    breakingDuration =
        Duration(minutes: SavingDataLocally.getBreakingDuration());
    rounds = SavingDataLocally.getRounds();

    super.initState();
  }

  void changeLearnDuration(bool isLearn, BuildContext context) async {
    _selectedDuration = await showDurationPicker(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Theme.of(context).accentColor,
        ),
        context: context,
        initialTime: isLearn ? learningDuration : breakingDuration);
    if (_selectedDuration != null) {
      if (isLearn) {
        learningDuration = _selectedDuration as Duration;
        SavingDataLocally.setLearningDuration(_selectedDuration!.inMinutes);
      } else {
        breakingDuration = _selectedDuration as Duration;
        SavingDataLocally.setBreakingDuration(_selectedDuration!.inMinutes);
      }
      setState(() {});
    }
  }

  changeRounds() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Theme.of(context).accentColor,
            title: Text('choose_round'.tr),
            content: TextFormField(
              decoration: const InputDecoration(
                  icon: ImageIcon(
                AssetImage('assets/icons/tomato.png'),
              )),
              controller: roundsController,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('cancel'.tr)),
              TextButton(
                  onPressed: () {
                    if (int.parse(roundsController.text) < 10) {
                      setState(() {
                        rounds = int.parse(roundsController.text);
                        SavingDataLocally.setRounds(rounds);
                      });
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                              'Your rounds must be less or equal to 10!')));
                    }
                  },
                  child: const Text('OK')),
            ],
          );
        });
  }

  void addTime(BuildContext context) {
    const subSecond = -1;
    setState(() {
      final seconds = learningDuration.inSeconds + subSecond;
      secondsLearned++;
      SavingDataLocally.setSecondsLearned(
        secondsLearned,
        DateFormat('EEEE').format(DateTime.now()),
      );
      if (seconds < 0) {
        learningTimer?.cancel();
        // assetsAudioPlayer.play();
        isBreakingCompleted = !isBreakingCompleted;
        isLearningCompleted = !isLearningCompleted;
        Future.delayed(Duration(seconds: 5), () {
          startBreak();
        });
        showSnackBar(context, "Let's take some break! ☕",
            color: Theme.of(context).accentColor, textColor: Colors.black);
        print('start');
        reset();
      } else {
        learningDuration = Duration(seconds: seconds);
      }
    });
  }

  void addBreakTime() {
    const subSecond = -1;
    setState(() {
      final seconds = breakingDuration.inSeconds + subSecond;

      print(seconds);
      if (seconds < 0) {
        breakingTimer?.cancel();
        isPlaying = !isPlaying;
        isBreakingCompleted = !isBreakingCompleted;
        isLearningCompleted = !isLearningCompleted;
        rounds = rounds - 1;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            content: Text(
              '✧･ﾟ Yay! You have just finished ${initRounds - rounds} ${initRounds - rounds > 1 ? 'rounds' : 'round'}! Keep learning ᕦ(ò_óˇ)ᕤ',
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            )));
        videoController!.pause();
        resetBreak();
      } else {
        breakingDuration = Duration(seconds: seconds);
      }
    });
  }

  Widget buildTime() {
    final minutes = twoDigits(learningDuration.inMinutes.remainder(60));
    final seconds = twoDigits(learningDuration.inSeconds.remainder(60));
    return Text(
      '$minutes:$seconds',
      style: const TextStyle(
          fontSize: 25, color: Colors.white70, fontWeight: FontWeight.bold),
    );
  }

  void reset() {
    setState(() {
      learningDuration = _selectedDuration ?? const Duration(minutes: 25);
    });
  }

  void startTimer(BuildContext context) {
    learningTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => addTime(context));
    setState(() {
      isBreakingCompleted = true;
      isLearningCompleted = false;
    });
  }

  Widget buildBreakTime() {
    final minutes = twoDigits(breakingDuration.inMinutes.remainder(60));
    final seconds = twoDigits(breakingDuration.inSeconds.remainder(60));
    return Text(
      '$minutes:$seconds',
      style: const TextStyle(
          fontSize: 25, color: Colors.white70, fontWeight: FontWeight.bold),
    );
  }

  void resetBreak() {
    setState(() {
      breakingDuration = _selectedDuration ?? const Duration(minutes: 5);
    });
  }

  void startBreak() {
    breakingTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => addBreakTime());
    setState(() {
      isPlaying = true;
      isBreakingCompleted = false;
      isLearningCompleted = true;
    });
  }

  IconData volumeIcon(double value) {
    if (value == 0 || isMuted) return Icons.volume_mute;
    if (value >= 0.01 && value < 0.4) {
      return Icons.volume_down;
    }
    if (value >= 0.4 && value < 0.7 || !isMuted) {
      return Icons.volume_up;
    }
    return Icons.volume_up;
  }

  @override
  void dispose() {
    breakingTimer?.cancel();
    learningTimer?.cancel();
    videoController!.dispose();
    VolumeController().removeListener();
    roundsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final firebaseService = Provider.of<FirebaseService>(context);
    return Scaffold(
      key: _scaffoldState,
      endDrawer: SettingDrawer(
          learnDuration: () => changeLearnDuration(true, context),
          breakDuration: () => changeLearnDuration(false, context),
          rounds: changeRounds),
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              DetailHeader(scaffoldState: _scaffoldState),
              const SizedBox(
                height: 40,
              ),
              TomatoRounds(rounds: rounds),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(5, 8),
                          blurRadius: 5.4,
                        )
                      ]),
                  child: VideoPlayerWidget(
                    controller: videoController,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              LabelVideo(widget: widget),
              const SizedBox(
                height: 50,
              ),
              Column(
                children: [
                  !isLearningCompleted ? buildTime() : buildBreakTime(),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        if (!isMuted) {
                          setState(() {
                            isMuted = !isMuted;
                            _setVolumeValue = 0;
                          });
                          VolumeController().muteVolume(showSystemUI: false);
                        } else {
                          setState(() {
                            _setVolumeValue = 1;
                            isMuted = !isMuted;
                          });
                          VolumeController().maxVolume(showSystemUI: false);
                        }
                      },
                      icon: Icon(
                        volumeIcon(_setVolumeValue),
                        color: Colors.white70,
                      )),
                  Slider(
                    activeColor: Colors.white70,
                    inactiveColor: const Color.fromARGB(255, 81, 80, 80),
                    min: 0,
                    max: 1,
                    onChanged: (double value) {
                      _setVolumeValue = value;
                      VolumeController().setVolume(_setVolumeValue);
                      setState(() {});
                    },
                    value: _setVolumeValue,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: isBreakingCompleted,
                    child: IconButton(
                        color: Colors.white70,
                        splashColor: Colors.transparent,
                        icon: Icon(isPlaying
                            ? Icons.pause
                            : Icons.play_arrow_outlined),
                        iconSize: 50,
                        onPressed: () {
                          if (videoController!.value.isInitialized) {
                            setState(() {
                              isPlaying = !isPlaying;
                              if (isPlaying) {
                                videoController!.play();
                                startTimer(context);
                              } else {
                                learningTimer?.cancel();
                                videoController!.pause();
                              }
                            });
                          }
                        }),
                  ),
                  Visibility(
                    visible: isLearningCompleted,
                    child: IconButton(
                      color: Colors.white70,
                      splashColor: Colors.transparent,
                      icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow_outlined),
                      iconSize: 50,
                      onPressed: () {
                        setState(() {
                          isPlaying = !isPlaying;
                          if (isPlaying) {
                            videoController!.play();
                            startBreak();
                          } else {
                            breakingTimer?.cancel();
                            videoController!.pause();
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    splashColor: Colors.transparent,
                    iconSize: 60,
                    onPressed: () async {
                      bool isloading = true;
                      if (isloading) {
                        await firebaseService.addFavorite(widget.component);
                        isloading = false;
                      }
                      if (widget.component.isFavorite)
                        showSnackBar(context, "fav_snack".tr,
                            color: Color(0xffb22b27));
                    },
                    icon: widget.component.isFavorite
                        ? const Icon(
                            Icons.favorite_outlined,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            color: Colors.white70,
                          ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    splashColor: Colors.transparent,
                    iconSize: 40,
                    onPressed: () {
                      if (isBreakingCompleted) {
                        reset();
                      } else if (isLearningCompleted) {
                        resetBreak();
                      }
                    },
                    icon: const Icon(
                      Icons.restore_outlined,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("youtube".tr + ": ",
                      style: TextStyle(color: Colors.white)),
                  IconButton(
                      onPressed: () async {
                        final url = widget.component.ytbUrl;
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(
                            Uri.parse(url),
                          );
                        }
                      },
                      icon: Image.asset(
                        'assets/icons/youtube.png',
                        color: Colors.white,
                        width: 30,
                        height: 20,
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
