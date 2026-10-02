import 'package:flutter/material.dart';
import 'package:shortest_distance/algorithms/pathfinder.dart';
import 'package:shortest_distance/models/tasks.dart';
import 'package:shortest_distance/screens/result_screen.dart';
import 'package:shortest_distance/services/api_service.dart';

class ProcessScreen extends StatefulWidget {
  final String apiUrl;
  const ProcessScreen({super.key, required this.apiUrl});

  @override
  State<StatefulWidget> createState() {
    return __ProcessScreenState();
  }
}

class __ProcessScreenState extends State<ProcessScreen> {
  late ApiService _apiService;
  bool _isCalculating = false;
  bool _isSending = false;
  int _progress = 0;
  String? _statusMessage;
  List<TaskResult> _calculatedResults = [];

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(widget.apiUrl);
    _startProcess();
  }

  Future<void> _startProcess() async {
    try {
      setState(() => _statusMessage = 'Downloading tasks...');
      final tasks = await _apiService.getTask();

      if (tasks.isEmpty) {
        throw Exception('Сервер повернув порожній список завдань');
      }
      List<TaskResult> results = [];
      int totalTasks = tasks.length;

      for (int i = 0; i < totalTasks; i++) {
        final task = tasks[i];
        final pathfinder = Pathfinder(task.grid);
        final path = pathfinder.findShortestPath(task.start, task.end);
        final pathString = path.map((p) => p.toString()).join('->');

        results.add(
          TaskResult(task: task, steps: path, pathString: pathString),
        );
        setState(() {
          _progress = ((i + 1) / totalTasks * 100).round();
          _statusMessage = 'Calculating... $_progress%';
        });

        await Future.delayed(const Duration(milliseconds: 100));
      }

      setState(() {
        _calculatedResults = results;
        _isCalculating = false;
        _statusMessage =
            'All calculations has finished, you can send\nyour results to server';
      });
    } catch (e) {
      _showError('$e');
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _sendResults() async {
    setState(() {
      _isSending = true;
    });

    try {
      final jsonData = _calculatedResults.map((r) => r.toJson()).toList();
      final success = await _apiService.sendResults(jsonData);

      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultListScreen(results: _calculatedResults),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSending = false;
      });
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Process Screen',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlueAccent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              _statusMessage ?? 'Calculating...',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              '$_progress%',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: _progress / 100.0,
                strokeWidth: 4,
                color: Colors.indigo,
              ),
            ),
            const Spacer(),
            if (!_isCalculating)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSending ? null : _sendResults,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    foregroundColor: Colors.black,
                  ),
                  child: _isSending
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Send results to server',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
