import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          titleLarge:
              TextStyle(color: Colors.white, fontSize: 24), // For larger text
          bodyLarge: TextStyle(color: Colors.white), // For general text
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // Button background color
            foregroundColor: Colors.deepPurple, // Button text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 30), // Adjusted for smaller button size
            textStyle: TextStyle(fontSize: 16), // Font size adjusted
          ),
        ),
      ),
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  final _player1Controller = TextEditingController();
  final _player2Controller = TextEditingController();
  List<String> _board = List.generate(9, (index) => '');
  bool _isXTurn = true;
  String _winner = '';
  String _winnerName = '';
  bool _gameStarted = false;

  void _startGame() {
    final player1 = _player1Controller.text;
    final player2 = _player2Controller.text;

    if (player1.isNotEmpty && player2.isNotEmpty) {
      setState(() {
        _gameStarted = true;
        _winner = '';
        _winnerName = '';
        _board = List.generate(9, (index) => ''); // Reset board
        _isXTurn = true; // Reset turn
      });
    }
  }

  void _handleTap(int index) {
    if (_board[index].isEmpty && _winner.isEmpty) {
      setState(() {
        _board[index] = _isXTurn ? 'X' : 'O';
        _isXTurn = !_isXTurn;
        _checkWinner();
      });
    }
  }

  void _checkWinner() {
    const lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var line in lines) {
      if (_board[line[0]] == _board[line[1]] &&
          _board[line[1]] == _board[line[2]] &&
          _board[line[0]].isNotEmpty) {
        setState(() {
          _winner = _board[line[0]];
          _winnerName = _winner == 'X'
              ? _player1Controller.text
              : _player2Controller.text;
        });
        return;
      }
    }

    if (!_board.contains('')) {
      setState(() {
        _winner = 'Draw';
      });
    }
  }

  void _resetGame() {
    setState(() {
      _board = List.generate(9, (index) => ''); // Reset board
      _winner = '';
      _winnerName = '';
      _isXTurn = true; // Reset turn
      _gameStarted = true; // Keep game started
    });
  }

  void _resetGameWithDifferentNames() {
    setState(() {
      _board = List.generate(9, (index) => ''); // Reset board
      _winner = '';
      _winnerName = '';
      _isXTurn = true; // Reset turn
      _gameStarted = false; // Allow re-entering names
      _player1Controller.clear();
      _player2Controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.deepPurpleAccent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (!_gameStarted) ...[
              TextField(
                controller: _player1Controller,
                decoration: InputDecoration(
                  labelText: 'Player 1 Name',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _player2Controller,
                decoration: InputDecoration(
                  labelText: 'Player 2 Name',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _startGame,
                child: Text('Start Game'),
              ),
            ] else ...[
              Text(
                '${_player1Controller.text} vs ${_player2Controller.text}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 10),
              if (_winner.isNotEmpty) ...[
                Text(
                  _winner == 'Draw' ? 'It\'s a Draw!' : 'Winner: $_winnerName',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _resetGameWithDifferentNames,
                  child: Text('reset'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _resetGame,
                  child: Text('Play Again'),
                ),
              ],
              SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _handleTap(index),
                    child: Container(
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        color: _board[index].isEmpty
                            ? Colors.white24
                            : (_board[index] == 'X' ? Colors.blue : Colors.red),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          _board[index],
                          style: TextStyle(fontSize: 36, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
