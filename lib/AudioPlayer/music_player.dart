import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:file_picker/file_picker.dart';

class LocalMusicPlayer extends StatefulWidget {
  const LocalMusicPlayer({super.key});

  @override
  State<LocalMusicPlayer> createState() => _LocalMusicPlayerState();
}

class _LocalMusicPlayerState extends State<LocalMusicPlayer> {
  final AudioPlayer _player = AudioPlayer();
  String? _filePath;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null && result.files.single.path != null) {
      _filePath = result.files.single.path!;
      await _player.setFilePath(_filePath!);
      _player.play();
      setState(() {});
    }
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Local Music Player")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_filePath != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Now Playing:\n$_filePath",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          StreamBuilder<PlayerState>(
            stream: _player.playerStateStream,
            builder: (context, snapshot) {
              final playing = snapshot.data?.playing ?? false;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                    iconSize: 40,
                    onPressed: () {
                      if (playing) {
                        _player.pause();
                      } else {
                        _player.play();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.stop),
                    iconSize: 40,
                    onPressed: () => _player.stop(),
                  ),
                ],
              );
            },
          ),
          StreamBuilder<Duration>(
            stream: _player.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final total = _player.duration ?? Duration.zero;
              return Column(
                children: [
                  Slider(
                    value: position.inSeconds.toDouble(),
                    max: total.inSeconds.toDouble() > 0
                        ? total.inSeconds.toDouble()
                        : 1,
                    onChanged: (value) {
                      _player.seek(Duration(seconds: value.toInt()));
                    },
                  ),
                  Text(
                    "${_formatDuration(position)} / ${_formatDuration(total)}",
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickAudioFile,
            child: const Text("Pick Audio File"),
          ),
        ],
      ),
    );
  }
}
