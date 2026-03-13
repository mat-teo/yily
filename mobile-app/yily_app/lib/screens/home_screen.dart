import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:yily_app/models/reason.dart';
import 'package:yily_app/models/counts.dart';
import 'package:yily_app/screens/add_reason_screen.dart';
import 'package:yily_app/services/api_service.dart';

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
      final countsMap = await api.getCounts();
      final counts = ReasonCounts.fromJson(countsMap);

      setState(() {
        _reasons = reasons;
        _counts = counts;
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
        title: const Text('Yily'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Conteggi in alto (con animazione fade)
          if (_counts != null)
            Animate(
              effects: const [FadeEffect(delay: Duration(milliseconds: 300))],
              child: Padding(
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
            ),

          // Lista motivi con shimmer
          Expanded(
            child: _isLoading
                ? ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[200]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 140,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      );
                    },
                  )
                : _reasons.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Ancora nessun motivo',
                              style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Aggiungine uno per il tuo partner!',
                              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _reasons.length,
                        itemBuilder: (context, index) {
                          final reason = _reasons[index];
                          return Animate(
                            effects: [FadeEffect(delay: Duration(milliseconds: index * 100))],
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reason.content,
                                    style: const TextStyle(fontSize: 16, height: 1.5),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        DateTime.now().difference(reason.createdAt).inDays == 0
                                            ? 'Oggi'
                                            : '${reason.createdAt.day}/${reason.createdAt.month}',
                                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddReasonScreen()),
          );
          if (result == true) _loadData();
        },
        child: const Icon(Icons.favorite),
      ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
    );
  }

  Widget _buildCount(String label, int value) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
        ),
        Text(label, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }
}