import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:yily_app/models/reason.dart';
import 'package:yily_app/services/api_service.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yily_app/widgets/reason_card.dart';
import 'add_reason_screen.dart';
import 'reason_screen.dart';

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
    _loadUserNames();
    _loadRandomReason();
  }

  Future<void> _loadUserNames() async {
    try {
      final api = ApiService();
      final userInfo = await api.getUserInfo(); // implementa getUserInfo() in ApiService
      setState(() {
        mioNome = userInfo['users'][0]['name']; 
        partnerNome = userInfo['users'][1]['name'];
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
      backgroundColor: const Color(0xFFFFF8FA),
      body: SafeArea(
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
    );
  }
}