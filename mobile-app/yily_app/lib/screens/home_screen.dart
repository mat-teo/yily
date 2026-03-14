import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:yily_app/models/reason.dart';
import 'package:yily_app/services/api_service.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yily_app/widgets/reason_card.dart';
import 'reason_screen.dart';
import 'package:flutter/services.dart'; 
import 'package:provider/provider.dart';
import 'package:yily_app/providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? mioNome;
  String? partnerNome;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).loadUserInfo();
    _loadUserNames();
    _loadRandomReason();
  }

  Future<void> _loadUserNames() async {
    try {
      final userProv = Provider.of<UserProvider>(context, listen: false);
      setState(() {
        mioNome = userProv.myName; 
        partnerNome = userProv.partnerName ?? "Partner";
      });
    } catch (e) {
      setState(() {
        mioNome = "Tu";
        partnerNome = "Partner";
      });
    }
  }
  Reason? randomReason;
  bool isLoadingRandom = true;



  Future<void> _loadRandomReason() async {
    setState(() => isLoadingRandom = true);
    try {
      final api = ApiService();
      final reason = await api.getRandomReason();
      setState(() {
        randomReason = reason;
        isLoadingRandom = false;
      });
    } catch (e) {
      setState(() => isLoadingRandom = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
    appBar: AppBar(
      title: const Text('Yily'),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.vpn_key_rounded, color: Colors.black87, size: 24.w),
          tooltip: 'Mostra codice coppia',
          onPressed: _showTokenPopup,
        ),
      ],
    ),
      backgroundColor: const Color(0xFFFFF8FA),
      body: 
        Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF5F8), Color(0xFFFFE9EF)],
          ),
        ),
          child:  SafeArea(
        child: Column(
          children: [
            // 1. Cuore con nomi in alto
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    mioNome ?? "Tu",
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 12.w),
                  Icon(
                    Icons.favorite,
                    color: const Color(0xFFFF6B6B),
                    size: 28.w,
                  ).animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  ).scale(
                    duration: 1800.ms,
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.1, 1.1),
                    curve: Curves.easeInOut,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    partnerNome ?? "Partner",
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            // 2. Card motivo random
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: isLoadingRandom
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 280.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28.r),
                            ),
                          ),
                        )
                      : randomReason == null
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.favorite_border, size: 64.w, color: Colors.grey[400]),
                                SizedBox(height: 16.h),
                                Text(
                                  "Ancora nessun motivo",
                                  style: TextStyle(fontSize: 18.sp, color: Colors.grey[600]),
                                ),
                              ],
                            )
                          : ReasonCard(
                              reason: randomReason!,
                            ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.94, 0.94), end: const Offset(1.0, 1.0)),
                ),
              ),
            ),

            // 3. Navbar in basso
            BottomNavigationBar(
              backgroundColor: Colors.white,
              selectedItemColor: const Color(0xFFFF6B6B),
              unselectedItemColor: Colors.grey[600],
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              currentIndex: 0,
              onTap: (index) {
                if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const reasonScreen()),
                  );
                }
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.list), label: 'reason'),
              ],
            ),
          ],
        ),
      ),
    )
    );
  }

  void _showTokenPopup() async {
  final api = ApiService();
  final response = await api.getUserInfo();
  final token = response["token"]; 

  if (token == null || token.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Impossibile recuperare il token')),
    );
    return;
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      title: const Text('Codice della coppia'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SelectableText(
            token,
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, letterSpacing: 2),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          Text(
            'Condividi questo codice con il tuo partner',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Chiudi'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: token));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Token copiato negli appunti!')),
            );
            Navigator.pop(context);
          },
          icon: const Icon(Icons.copy, size: 18),
          label: const Text('Copia'),
        ),
      ],
    ),
  );
}
}