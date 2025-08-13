import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late Future<List<dynamic>> _leaderboardFuture;

  @override
  void initState() {
    super.initState();
    _leaderboardFuture = ApiService.getLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Leaderboard"), backgroundColor: Colors.blue),
      body: FutureBuilder<List<dynamic>>(
        future: _leaderboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay datos en el leaderboard'));
          }

          final leaderboard = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: leaderboard.length,
            itemBuilder: (context, index) {
              final user = leaderboard[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text("${index + 1}"),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  title: Text(user['username'] ?? 'Usuario ${index + 1}'),
                  subtitle: Text("Puntos: ${user['points'] ?? 0}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
