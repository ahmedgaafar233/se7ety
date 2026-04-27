import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:se7ty/features/intro/data/models/onboarding_model.dart';
import 'package:se7ty/features/intro/presentation/widgets/onboarding_nav_bar.dart';
import 'package:se7ty/features/intro/presentation/widgets/onboarding_page_view_item.dart';
import 'package:se7ty/features/intro/presentation/widgets/onboarding_skip_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
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
          OnboardingSkipButton(index: _currentIndex),
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
                  return OnboardingPageViewItem(model: _pages[index]);
                },
              ),
            ),
            OnboardingNavBar(
              pageController: _pageController,
              currentIndex: _currentIndex,
              count: _pages.length,
            ),
            Gap(50.h),
          ],
        ),
      ),
    );
  }
}
