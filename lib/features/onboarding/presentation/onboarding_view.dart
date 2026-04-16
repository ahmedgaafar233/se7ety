import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:se7ty/core/routing/app_router.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/core/utils/prefs_helper.dart';

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
      title: 'ابحث عن طبيبك',
      description: 'أفضل الأطباء في جميع التخصصات متاحين الآن لحجز موعدك بسهولة.',
    ),
    OnboardingModel(
      image: 'assets/images/on2.png',
      title: 'احجز موعدك',
      description: 'اختر الوقت الذي يناسبك وقم بتأكيد حجزك في ثوانٍ معدودة.',
    ),
    OnboardingModel(
      image: 'assets/images/on3.png',
      title: 'تابع حالتك الصحية',
      description: 'نحن هنا لمساعدتك في الحفاظ على صحتك ومتابعة أدويتك وفحوصاتك.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (_currentIndex != 2)
            TextButton(
              onPressed: () {
                PrefsHelper.setIsOnboarded(true);
                Navigator.pushReplacementNamed(context, AppRoutes.role);
              },
              child: Text(
                'تخطي',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.primary,
                    ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
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
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      Gap(20.h),
                      Text(
                        _pages[index].description,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (_currentIndex == 2) {
                      PrefsHelper.setIsOnboarded(true);
                      Navigator.pushReplacementNamed(context, AppRoutes.role);
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  child: Text(_currentIndex == 2 ? 'ابدأ الآن' : 'التالي'),
                ),
              ],
            ),
            Gap(30.h),
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
