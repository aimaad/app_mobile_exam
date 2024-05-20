import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late double playerFortune;
  late double casinoFortune;
  late bool fortuneValidated;
  late bool gameInProgress;
  late Timer diceRollTimer;

  final TextEditingController _fortuneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    playerFortune = 0;
    casinoFortune = Random().nextInt(91) + 10;
    fortuneValidated = false;
    gameInProgress = false;
  }

  void rollDice() {
    diceRollTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      int diceResult = Random().nextInt(6) + 1;

      setState(() {
        if (diceResult == 2 || diceResult == 3) {
          playerFortune += 1;
          casinoFortune -= 1;
        } else {
          playerFortune -= 1;
          casinoFortune += 1;
        }

        if (playerFortune <= 0 || casinoFortune <= 0) {
          _showResult();
          timer.cancel();
        }
      });
    });
  }

  void _showResult() {
    String winner;
    if (playerFortune <= 0 && casinoFortune <= 0) {
      winner = "Aucun vainqueur. Le jeu est interrompu";
    } else if (playerFortune <= 0) {
      winner = "Le casino";
    } else {
      winner = "Le joueur";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Résultat'),
          content: Text('Le vainqueur est $winner'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (playerFortune > 0 && casinoFortune > 0) {
                  // Si aucun des deux joueurs n'a atteint 0, réinitialise le jeu
                  setState(() {
                    playerFortune = 0;
                    casinoFortune = Random().nextInt(91) + 10;
                    gameInProgress = false;
                  });
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void stopGame() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Résultat'),
          content: Text('Vous avez interrompu le jeu'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  gameInProgress = false;
                });
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    diceRollTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ruine de Joueur')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (fortuneValidated)
              Column(
                children: [
                  Text(
                    'Fortune du Joueur: ${playerFortune.toStringAsFixed(2)} €',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Fortune du Casino: ${casinoFortune.toStringAsFixed(2)} €',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _fortuneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Entrez votre fortune en euros'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre fortune';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        playerFortune =
                            double.tryParse(_fortuneController.text) ?? 0;
                        setState(() {
                          fortuneValidated = true;
                          gameInProgress = true;
                        });
                        rollDice();
                      }
                    },
                    child: Text('Valider la Fortune'),
                  ),
                  SizedBox(height: 10),
                  if (gameInProgress)
                    ElevatedButton(
                      onPressed: stopGame,
                      child: Text('Interrompre le Jeu'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
