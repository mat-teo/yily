import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:yily_app/models/reason.dart';
import 'package:yily_app/services/api_service.dart';
import 'package:yily_app/widgets/reason_card.dart';
import 'add_reason_screen.dart';
import 'package:provider/provider.dart';
import 'package:yily_app/providers/user_provider.dart';

class reasonScreen extends StatefulWidget {
  const reasonScreen({super.key});

  @override
  State<reasonScreen> createState() => _reasonScreenState();
}

class _reasonScreenState extends State<reasonScreen> {
  List<Reason> _allReasons = [];
  bool _isLoading = true;
  int _selectedTab = 0; // 0 = Received (default), 1 = Sent

  @override
  void initState() {
    super.initState();
    _loadReasons();
  }

  Future<void> _loadReasons() async {
    setState(() => _isLoading = true);
    try {
      final api = ApiService();
      final receivedReasons = await api.getReceivedReasons(); 
      final sentReasons = await api.getSentReasons();
      setState(() {
        _allReasons = [...receivedReasons, ...sentReasons];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore caricamento: $e')),
      );
    }
  }

  List<Reason> get _filteredReasons {
    final UserProvider userProv = Provider.of<UserProvider>(context, listen: true);
    final currentUserId = userProv.userId;
    if (_selectedTab == 0) {
      return _allReasons.where((r) => r.toUserId == currentUserId).toList(); // received
    } else {
      return _allReasons.where((r) => r.fromUserId == currentUserId).toList(); // sent
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context, listen: true);
    final currentUserId = userProv.userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reason'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddReasonScreen()),
              );
              if (result == true) _loadReasons();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab piccoli in alto
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabButton('Received', 0),
                SizedBox(width: 12.w),
                _buildTabButton('Sent', 1),
              ],
            ),
          ),

          // Lista
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadReasons,
              color: const Color(0xFFFF9EAA),
              child: _isLoading
                  ? ListView.builder(
                      padding: EdgeInsets.all(16.w),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 140.h,
                            margin: EdgeInsets.only(bottom: 16.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24.r),
                            ),
                          ),
                        );
                      },
                    )
                  : _filteredReasons.isEmpty
                      ? Center(
                          child: Text(
                            _selectedTab == 0 ? 'You have no received reasons' : 'You have not sent any reasons... try to impress ${userProv.partnerName}!',
                            style: TextStyle(fontSize: 18.sp, color: Colors.grey[600]),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(16.w),
                          itemCount: _filteredReasons.length,
                          itemBuilder: (context, index) {
                            final reason = _filteredReasons[index];
                            final isMyReason = reason.fromUserId == currentUserId; 

                            return Dismissible(
                              key: Key(reason.id.toString()),
                              direction: isMyReason ? DismissDirection.horizontal : DismissDirection.none,
                              background: Container(
                                color: Colors.blue,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 20.w),
                                child: Icon(Icons.edit, color: Colors.white, size: 32.w),
                              ),
                              secondaryBackground: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 20.w),
                                child: Icon(Icons.delete, color: Colors.white, size: 32.w),
                              ),
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  // Delete
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Elimina reason'),
                                      content: const Text('Sei sicuro?'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annulla')),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: const Text('Elimina', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    final api = ApiService();
                                    await api.deleteReason(reason.id);
                                    setState(() => _allReasons.remove(reason));
                                    return true;
                                  }
                                  return false;
                                } else if (direction == DismissDirection.startToEnd) {
                                  final newContent = await showDialog<String>(
                                  context: context,
                                  builder: (context) {
                                    final controller = TextEditingController(text: reason.content);
                                    return AlertDialog(
                                      title: const Text('Modifica motivo'),
                                      content: TextField(
                                        controller: controller,
                                        maxLines: 5,
                                        decoration: const InputDecoration(hintText: 'Nuovo testo...'),
                                      ),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annulla')),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, controller.text.trim()),
                                          child: const Text('Salva'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (newContent != null && newContent.isNotEmpty && newContent != reason.content) {
                                  try {
                                    final api = ApiService();
                                    await api.updateReason(reason.id, newContent); // da implementare in ApiService
                                    setState(() {
                                      _loadReasons();
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Motivo modificato')),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Errore modifica: $e')),
                                    );
                                  }
                                }
                                return false;
                                }
                                return false;
                              },
                              child: ReasonCard(reason: reason),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF9EAA) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}