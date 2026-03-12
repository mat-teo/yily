import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yily_app/models/reason.dart';
import 'package:yily_app/models/counts.dart';
import 'package:yily_app/services/api_service.dart';
import 'package:yily_app/screens/add_reason_screen.dart';
import 'package:yily_app/widgets/reason_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Reason> _reasons = [];
  ReasonCounts? _counts;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

 Future<void> _loadData() async {
  setState(() => _isLoading = true);
  final api = ApiService();
  try {
    final reasons = await api.getReceivedReasons();
    
    // Qui il fix: parsiamo la Map in ReasonCounts
    final countsMap = await api.getCounts(); // è Map<String, dynamic>
    final counts = ReasonCounts.fromJson(countsMap); // convertiamo in oggetto

    setState(() {
      _reasons = reasons;
      _counts = counts; // ora è ReasonCounts, non Map
      _isLoading = false;
    });
  } catch (e) {
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Errore caricamento: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yily - I miei motivi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: Column(
                children: [
                  if (_counts != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildCount('Scritti', _counts!.sent),
                              _buildCount('Ricevuti', _counts!.received),
                              _buildCount('Totale', _counts!.total),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: _reasons.isEmpty
                        ? const Center(child: Text('Nessun motivo ricevuto ancora'))
                        : ListView.builder(
                            itemCount: _reasons.length,
                            itemBuilder: (context, index) {
                              return ReasonCard(reason: _reasons[index]);
                            },
                          ),
                  ),
                ],
              ),
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddReasonScreen()),
              );
              if (result == true) _loadData();
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'random',
            onPressed: () async {
              final api = ApiService();
              final randomReason = await api.getRandomReason();
              if (randomReason != null) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Motivo casuale'),
                    content: Text(randomReason.content),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Chiudi'),
                      ),
                    ],
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nessun motivo ricevuto')),
                );
              }
            },
            child: const Icon(Icons.casino),
          ),
        ],
      ),
    );
  }

  Widget _buildCount(String label, int value) {
    return Column(
      children: [
        Text('$value', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label),
      ],
    );
  }
}