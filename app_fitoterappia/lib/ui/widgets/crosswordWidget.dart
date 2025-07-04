import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_search_safety/word_search_safety.dart';
import 'package:app_fitoterappia/models/Plants.dart';

class Crosswordwidget extends StatefulWidget {
  final Function()? onGameComplete;
  const Crosswordwidget({super.key, this.onGameComplete});

  @override
  State<Crosswordwidget> createState() => _CrosswordwidgetState();
}

class _CrosswordwidgetState extends State<Crosswordwidget> {
  List<String> plantNames = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  Future<void> _initGame() async {
    await _checkSync();
    await _loadPlantNames();
    setState(() => isLoading = false);
  }

  Future<void> _checkSync() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSync = prefs.getString('lastSyncDate');
    final today = DateTime.now().toString().split(' ')[0];
    if (lastSync != today) {
      await _syncData();
      prefs.setString('lastSyncDate', today);
    }
  }

  Future<void> _syncData() async {
    try {
      final apiUrl = dotenv.env['API_URL'];
      final resp = await http.get(Uri.parse('$apiUrl/plantas'));
      if (resp.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        await File('${dir.path}/plantas.json').writeAsString(resp.body);
      }
    } catch (e) {
      debugPrint('Error sincronizando: $e');
    }
  }

  Future<void> _loadPlantNames() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/plantas.json');
      if (!await file.exists()) return;
      final data = json.decode(await file.readAsString()) as List;
      final plantas = data.map((e) => Plants.fromJson(e)).toList();
      plantNames = plantas
          .map((p) => p.nombreComun?.toLowerCase().trim())
          .where((n) => n != null && n.length >= 3)
          .cast<String>()
          .toSet()
          .toList();
    } catch (e) {
      debugPrint('Error cargando nombres: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
      ? const Center(child: CircularProgressIndicator())
      : CrosswordGame(
          plantNames: plantNames,
          onGameComplete: widget.onGameComplete,
        );
  }
}

class CrosswordGame extends StatefulWidget {
  final List<String> plantNames;
  final Function()? onGameComplete;
  const CrosswordGame({super.key, required this.plantNames, this.onGameComplete});

  @override
  State<CrosswordGame> createState() => _CrosswordGameState();
}

class _CrosswordGameState extends State<CrosswordGame> {
  int numBoxperRow = 0;
  final int numBoxperRowMin = 4;
  final int numBoxperRowMax = 7;
  final int totalLevels = 4;

  int currentLevel = 1;
  double padding = 5;
  late Size sizeBox;

  late ValueNotifier<List<List<String>>> listChars;
  late ValueNotifier<List<CrosswordAnswer>> answerList;
  late ValueNotifier<CurrentDragObj> currentDragObj;
  late ValueNotifier<List<int>> charsDone;

  String message = '';

  @override
  void initState() {
    super.initState();
    listChars = ValueNotifier<List<List<String>>>([]);
    answerList = ValueNotifier<List<CrosswordAnswer>>([]);
    currentDragObj = ValueNotifier<CurrentDragObj>(
      CurrentDragObj(indexArrayOnTouch: -1),
    );
    charsDone = ValueNotifier<List<int>>([]);
    generateRandomWord();
    answerList.addListener(_checkGameCompletion);
  }

  @override
  void dispose() {
    answerList.removeListener(_checkGameCompletion);
    listChars.dispose();
    answerList.dispose();
    currentDragObj.dispose();
    charsDone.dispose();
    super.dispose();
  }

  void _checkGameCompletion() {
    if (answerList.value.isNotEmpty &&
        answerList.value.every((answer) => answer.done)) {
      if (currentLevel < totalLevels) {
        setState(() {
          message = '¡Siguiente nivel!';
          currentLevel++;
        });
        Future.delayed(const Duration(seconds: 2), () {
          setState(() => message = '');
          generateRandomWord();
        });
      } else {
        setState(() {
          message = '🎉 ¡Felicitaciones por completar la sopa de letras!';
          _availableWords.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    sizeBox = Size(MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.width);

    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          // Stack para sopa de letras + mensaje sobrepuesto
          SizedBox(
            height: sizeBox.width,
            width: sizeBox.width,
            child: Stack(
              children: [
                // Sopa de letras
                Listener(
                  onPointerDown: (event) {
                    int index =
                        calculateIndexBasePosLocal(event.localPosition);
                    if (index >= 0) {
                      onDragStart(index);
                    }
                  },
                  onPointerMove: (event) {
                    onDragUpdate(event);
                  },
                  onPointerUp: (event) {
                    onDragEnd();
                  },
                  child: drawCrossWordBox(),
                ),

                // Mensaje sobrepuesto (centrado)
                if (message.isNotEmpty)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        message,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Palabras a encontrar
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: drawAnswerList(),
              ),
            ),
          ),
        ],
      );
    });
  }

  void onDragStart(int index) {
    currentDragObj.value = CurrentDragObj(indexArrayOnTouch: index);
    currentDragObj.value.currentDragLine.add(index);
    currentDragObj.notifyListeners();
  }

  void onDragEnd() {
    if (currentDragObj.value.indexArrayOnTouch < 0) return;
    checkAnswer();
    currentDragObj.value = CurrentDragObj(indexArrayOnTouch: -1);
    currentDragObj.notifyListeners();
  }

  void onDragUpdate(PointerMoveEvent event) {
    if (currentDragObj.value.indexArrayOnTouch < 0) return;
    final startIndex = currentDragObj.value.currentDragLine.first;
    final currentIndex = calculateIndexBasePosLocal(event.localPosition);
    if (currentIndex < 0 || (currentDragObj.value.currentDragLine.isNotEmpty &&
        currentIndex == currentDragObj.value.currentDragLine.last)) return;

    final newLine = _getLineIndices(startIndex, currentIndex, numBoxperRow);
    if (newLine.isNotEmpty &&
        currentDragObj.value.currentDragLine.join('-') != newLine.join('-')) {
      currentDragObj.value.currentDragLine = newLine;
      currentDragObj.notifyListeners();
    }
  }

  void checkAnswer() {
    final currentLine = currentDragObj.value.currentDragLine;
    if (currentLine.length < 2) return;

    final forward = currentLine.join("-");
    final backward = currentLine.reversed.toList().join("-");

    final indexFound = answerList.value.indexWhere((answer) {
      if (answer.done) return false;
      final answerLine = answer.answerLines.join("-");
      final answerLineReversed = answer.answerLines.reversed.toList().join("-");
      return answerLine == forward || answerLine == backward ||
          answerLineReversed == forward || answerLineReversed == backward;
    });

    if (indexFound >= 0) {
      final newAnswerList = List<CrosswordAnswer>.from(answerList.value);
      newAnswerList[indexFound].done = true;
      final newCharsDone = List<int>.from(charsDone.value);
      newCharsDone.addAll(newAnswerList[indexFound].answerLines);
      answerList.value = newAnswerList;
      charsDone.value = newCharsDone;
    }
  }

  int calculateIndexBasePosLocal(Offset localPosition) {
    final gridSize = sizeBox.width - (padding * 2);
    final cellSize = (gridSize - (numBoxperRow - 1) * padding) / numBoxperRow;
    final slotSize = cellSize + padding;
    final adjusted = localPosition - Offset(padding, padding);

    if (adjusted.dx < 0 || adjusted.dy < 0 || adjusted.dx > gridSize || adjusted.dy > gridSize) {
      return -1;
    }

    final col = (adjusted.dx / slotSize).floor().clamp(0, numBoxperRow - 1);
    final row = (adjusted.dy / slotSize).floor().clamp(0, numBoxperRow - 1);
    return row * numBoxperRow + col;
  }

  Widget drawCrossWordBox() {
    return ValueListenableBuilder(
      valueListenable: listChars,
      builder: (context, List<List<String>> list, child) {
        if (list.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1,
            crossAxisCount: numBoxperRow,
            crossAxisSpacing: padding,
            mainAxisSpacing: padding,
          ),
          itemCount: numBoxperRow * numBoxperRow,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final char = list.expand((e) => e).toList()[index];
            return ValueListenableBuilder(
              valueListenable: currentDragObj,
              builder: (context, CurrentDragObj value, child) {
                Color color = Colors.white;
                Color textColor = Colors.black;

                if (charsDone.value.contains(index)) {
                  color = Colors.blue.shade300;
                  textColor = Colors.white;
                }
                if (value.currentDragLine.contains(index)) {
                  color = Colors.yellow.shade400;
                }

                return Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 3),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    char.toUpperCase(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
  List<String> _availableWords = [];
  List<String> _usedWords = [];

  void generateRandomWord() {
    if (_availableWords.isEmpty) {
      _availableWords = List<String>.from(widget.plantNames.toSet().toList());
      _availableWords.shuffle();
      _usedWords.clear();
    }

    // Filtra por largo máximo
    final int maxLen = 3 + currentLevel;
    final usableWords = _availableWords.where((w) =>
      !_usedWords.contains(w) && w.length <= maxLen).toList();

    if (usableWords.length < 2) {
      // Si quedan pocas palabras, reinicia para una nueva ronda
      _availableWords = List<String>.from(widget.plantNames.toSet().toList());
      _availableWords.shuffle();
      _usedWords.clear();
    }

    final selected = usableWords.take(min(6, usableWords.length)).toList();
    _usedWords.addAll(selected);

    final longest = selected.map((w) => w.length).fold(0, max);
    numBoxperRow = max(numBoxperRowMin + currentLevel - 1, longest)
      .clamp(numBoxperRowMin, numBoxperRowMax);

    final settings = WSSettings(
      width: numBoxperRow,
      height: numBoxperRow,
      orientations: WSOrientation.values.toList(),
    );

    final ws = WordSearchSafety();
    WSNewPuzzle puzzle;
    WSSolved? solved;
    int tries = 0;

    do {
      puzzle = ws.newPuzzle(selected, settings);
      if (puzzle.errors!.isNotEmpty) { tries++; continue; }
      solved = ws.solvePuzzle(puzzle.puzzle!, selected);
      tries++;
    } while ((puzzle.errors!.isNotEmpty || solved!.found!.length < selected.length) && tries < 5);

    if (puzzle.errors!.isEmpty && solved != null && solved.found!.length == selected.length) {
      listChars.value = puzzle.puzzle!;
      answerList.value = solved.found!
        .map((s) => CrosswordAnswer(s, numBoxperRow: numBoxperRow))
        .toList();
      charsDone.value = [];
    } else {
      // fallback si no se pudo
      final fallbackWords = selected.take(max(2, selected.length - 1)).toList();
      final fallbackPuzzle = ws.newPuzzle(fallbackWords, settings);
      final fallbackSolved = ws.solvePuzzle(fallbackPuzzle.puzzle!, fallbackWords);
      listChars.value = fallbackPuzzle.puzzle!;
      answerList.value = fallbackSolved.found!
        .map((s) => CrosswordAnswer(s, numBoxperRow: numBoxperRow))
        .toList();
      charsDone.value = [];
  }
  }

  Widget drawAnswerList() {
    return ValueListenableBuilder(
      valueListenable: answerList,
      builder: (context, List<CrosswordAnswer> value, child) {
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: value.map((answer) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: answer.done ? Colors.grey.shade300 : Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: answer.done ? Colors.grey : Colors.green.shade700),
              ),
              child: Text(
                answer.wsLocation.word,
                style: TextStyle(
                  fontSize: 19,
                  color: answer.done ? Colors.grey : Colors.green.shade900,
                  decoration: answer.done
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

// Helpers

List<int> _getLineIndices(int startIndex, int endIndex, int numBoxPerRow) {
  final startRow = startIndex ~/ numBoxPerRow;
  final startCol = startIndex % numBoxPerRow;
  final endRow = endIndex ~/ numBoxPerRow;
  final endCol = endIndex % numBoxPerRow;

  final isHorizontal = startRow == endRow;
  final isVertical = startCol == endCol;
  final isDiagonal = (endRow - startRow).abs() == (endCol - startCol).abs();

  if (!isHorizontal && !isVertical && !isDiagonal) return [];

  final line = <int>[startIndex];
  final dx = (endCol - startCol).sign;
  final dy = (endRow - startRow).sign;
  final steps = max((endRow - startRow).abs(), (endCol - startCol).abs());

  for (int i = 1; i <= steps; i++) {
    final nextCol = startCol + i * dx;
    final nextRow = startRow + i * dy;
    line.add(nextRow * numBoxPerRow + nextCol);
  }
  return line;
}

class CurrentDragObj {
  int indexArrayOnTouch;
  List<int> currentDragLine = <int>[];
  CurrentDragObj({required this.indexArrayOnTouch});
}

class CrosswordAnswer {
  bool done = false;
  WSLocation wsLocation;
  late List<int> answerLines;

  CrosswordAnswer(this.wsLocation, {required int numBoxperRow}) {
    generateAnswerLine(numBoxperRow);
  }

  void generateAnswerLine(int numBoxperRow) {
    final startX = wsLocation.x;
    final startY = wsLocation.y;
    final len = wsLocation.overlap;

    final dx = _orientationToDx(wsLocation.orientation);
    final dy = _orientationToDy(wsLocation.orientation);

    final List<int> line = [];

    for (int i = 0; i < len; i++) {
      final x = startX + dx * i;
      final y = startY + dy * i;
      if (x < 0 || y < 0 || x >= numBoxperRow || y >= numBoxperRow) continue;
      line.add(y * numBoxperRow + x);
    }

    answerLines = line;
  }

  int _orientationToDx(WSOrientation orientation) {
    switch (orientation) {
      case WSOrientation.horizontal:
        return 1;
      case WSOrientation.horizontalBack:
        return -1;
      case WSOrientation.vertical:
      case WSOrientation.verticalUp:
        return 0;
      case WSOrientation.diagonal:
        return 1;
      case WSOrientation.diagonalBack:
        return -1;
      case WSOrientation.diagonalUp:
        return 1;
      case WSOrientation.diagonalUpBack:
        return -1;
      default:
        return 0;
    }
  }

  int _orientationToDy(WSOrientation orientation) {
    switch (orientation) {
      case WSOrientation.horizontal:
      case WSOrientation.horizontalBack:
        return 0;
      case WSOrientation.vertical:
        return 1;
      case WSOrientation.verticalUp:
        return -1;
      case WSOrientation.diagonal:
        return 1;
      case WSOrientation.diagonalBack:
        return 1;
      case WSOrientation.diagonalUp:
        return -1;
      case WSOrientation.diagonalUpBack:
        return -1;
      default:
        return 0;
    }
  }
}
