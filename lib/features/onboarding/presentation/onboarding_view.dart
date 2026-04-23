import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:se7ty/core/routes/routes.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/core/utils/prefs_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingModel> _pages = [
    OnboardingModel(
      image: 'assets/images/on1.png',
      title: 'ابحث عن دكتور متخصص',
      description: 'اكتشف مجموعة واسعة من الأطباء الخبراء والمتخصصين في مختلف المجالات.',
    ),
    OnboardingModel(
      image: 'assets/images/on2.png',
      title: 'سهولة الحجز',
      description: 'احجز مواعيدك بضغطة زر في أي وقت وفي أي مكان.',
    ),
    OnboardingModel(
      image: 'assets/images/on3.png',
      title: 'أمن وسري',
      description: 'كن مطمئناً لأن خصوصيتك وأمانك هما أهم أولوياتنا.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_currentIndex != 2)
            TextButton(
              onPressed: () {
                PrefsHelper.setIsOnboarded(true);
                context.go(Routes.welcome);
              },
              child: Text(
                'تخطي',
                style: GoogleFonts.cairo(
                  color: AppColors.primary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        _pages[index].image,
                        height: 300.h,
                      ),
                      Gap(40.h),
                      Text(
                        _pages[index].title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Gap(20.h),
                      Text(
                        _pages[index].description,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 16.sp,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: _pages.length,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey.shade300,
                    activeDotColor: AppColors.primary,
                    dotHeight: 8.h,
                    dotWidth: 8.w,
                    expansionFactor: 4,
                    spacing: 5.w,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_currentIndex == 2) {
                      PrefsHelper.setIsOnboarded(true);
                      context.go(Routes.welcome);
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    _currentIndex == 2 ? 'ابدأ الآن' : 'التالي',
                    style: GoogleFonts.cairo(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Gap(50.h),
          ],
        ),
      ),
    );
  }
}

class OnboardingModel {
  final String image;
  final String title;
  final String description;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
  });
}
