import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:se7ty/core/routing/app_router.dart';
import 'package:se7ty/core/theme/app_colors.dart';

class RoleView extends StatelessWidget {
  const RoleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/on1.png', // Background image from assets
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withAlpha(128),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  'أهلاً بك في Se7ety',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
                Gap(10.h),
                Text(
                  'سجل الآن كـ طبيب أو مريض للبدء',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
                Gap(50.h),
                _RoleButton(
                  title: 'دكتور',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.login,
                      arguments: true,
                    );
                  },
                ),
                Gap(20.h),
                _RoleButton(
                  title: 'مريض',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.login,
                      arguments: false,
                    );
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const _RoleButton({
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary.withAlpha(200),
          padding: EdgeInsets.symmetric(vertical: 20.h),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
