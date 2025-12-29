import 'package:flutter/material.dart';
import 'services/radio_service.dart';
import 'dart:async';
import 'package:audio_waveforms/audio_waveforms.dart';

// Simple waveform UI using microphone input (audio_waveforms)
const String agoraAppId = '51ef80a60cca4d878865d3124810d35d';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF002B5B);

    return MaterialApp(
      title: 'F1 Effect Radio',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: darkBlue,
          secondary: Colors.blueAccent,
          surface: Color(0xFF121212),
        ),
        scaffoldBackgroundColor: Colors.black,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: darkBlue,
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'F1 Effect Radio'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RadioService? _radioService;
  bool _inChannel = false;

  // RecorderController (audio_waveforms) for capturing mic PCM and rendering detailed waveform
  late RecorderController _recorderController;

  @override
  void initState() {
    super.initState();
    _recorderController = RecorderController();
  }

  @override
  void dispose() {
    try {
      _recorderController.stop(false);
    } catch (_) {}
    _recorderController.dispose();
    _radioService?.dispose();
    super.dispose();
  }

  Future<void> _toggleChannel() async {
    if (!_inChannel) {
      // join
      try {
        _radioService = await RadioService.create(agoraAppId);
        await _radioService!.joinChannel(channelId: 'test');
        // start recorder waveform (audio_waveforms)
        try {
          await _recorderController.record();
        } catch (e) {
          // ignore: avoid_print
          print('Recorder start failed: $e');
        }
        if (!mounted) return;
        setState(() {
          _inChannel = true;
        });
      } catch (e, st) {
        // ignore: avoid_print
        print('Failed to join channel: $e');
        // ignore: avoid_print
        print(st);
        if (!mounted) return;
        showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Failed to join channel'),
            content: SingleChildScrollView(
              child: Text('$e\n\nSee console for stack trace.'),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK')),
            ],
          ),
        );
      }
    } else {
      // leave
      try {
        await _radioService?.leaveChannel();
        await _radioService?.dispose();
        _radioService = null;
        // stop recorder waveform
        try {
          await _recorderController.stop(false);
        } catch (_) {}
        if (!mounted) return;
        setState(() {
          _inChannel = false;
        });
      } catch (e, st) {
        // ignore: avoid_print
        print('Failed to leave channel: $e');
        // ignore: avoid_print
        print(st);
        if (!mounted) return;
        showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Failed to leave channel'),
            content: SingleChildScrollView(child: Text('$e\n\nSee console for stack trace.')),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK')),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Keep the UI minimal: only waveform and call button
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          height: 220,
          width: MediaQuery.of(context).size.width,
          child: AudioWaveforms(
            enableGesture: false,
            size: Size(MediaQuery.of(context).size.width, 220.0),
            recorderController: _recorderController,
            waveStyle: WaveStyle(
              showMiddleLine: false,
              waveColor: Colors.cyanAccent,
              showDurationLabel: false,
              extendWaveform: true,
              spacing: 8.0, // spacing must be larger than waveThickness
              waveThickness: 3.5,
              waveCap: StrokeCap.round,
              scaleFactor: 80.0, // increase sensitivity / amplification
              backgroundColor: Colors.black,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.large(
        onPressed: _toggleChannel,
        child: Icon(
          _inChannel ? Icons.call_end : Icons.call,
          size: 48,
        ),
      ),
    );
  }
}
