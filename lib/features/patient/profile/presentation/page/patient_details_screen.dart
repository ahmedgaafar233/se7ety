import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/core/widgets/dialogs.dart';

class PatientDetailsScreen extends StatefulWidget {
  const PatientDetailsScreen({super.key});

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  bool isLoading = true;

  final List<String> labelName = ["الاسم", "رقم الهاتف", "المدينة", "نبذة تعريفية", "العمر"];
  final List<String> valueKey = ["name", "phone", "city", "bio", "age"];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('patient').doc(user!.uid).get();
      if (doc.exists) {
        setState(() {
          userData = doc.data();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> updateData(String key, String value) async {
    showLoadingDialog(context);
    try {
      await FirebaseFirestore.instance.collection('patient').doc(user!.uid).set({key: value}, SetOptions(merge: true));
      if (key == "name") {
        await user?.updateDisplayName(value);
      }
      setState(() {
        if (userData == null) {
          userData = {key: value};
        } else {
          userData![key] = value;
        }
      });
      context.pop(); // close dialog
      context.pop(); // close textfield dialog
    } catch (e) {
      context.pop(); // close dialog
      showMyDialog(context, 'حدث خطأ، يرجى المحاولة مرة أخرى');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'إعدادات الحساب',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25.r),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(20.r),
              itemCount: labelName.length,
              itemBuilder: (context, index) {
                String currentValue = (userData?[valueKey[index]] == null || userData?[valueKey[index]] == '')
                    ? 'لم تضاف'
                    : userData?[valueKey[index]];

                return InkWell(
                  onTap: () => _showEditDialog(index, currentValue),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currentValue,
                          style: GoogleFonts.cairo(
                            fontSize: 14.sp,
                            color: currentValue == 'لم تضاف' ? Colors.grey : AppColors.dark,
                          ),
                        ),
                        Text(
                          labelName[index],
                          style: GoogleFonts.cairo(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showEditDialog(int index, String currentValue) {
    var con = TextEditingController(text: currentValue == 'لم تضاف' ? '' : currentValue);
    var form = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Form(
              key: form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'أدخل ${labelName[index]}',
                    style: GoogleFonts.cairo(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Gap(16.h),
                  TextFormField(
                    controller: con,
                    textAlign: TextAlign.right,
                    keyboardType: valueKey[index] == 'phone' || valueKey[index] == 'age'
                        ? TextInputType.number
                        : TextInputType.text,
                    decoration: InputDecoration(
                      hintText: labelName[index],
                      filled: true,
                      fillColor: AppColors.lightBlue,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return 'من فضلك أدخل ${labelName[index]}';
                      return null;
                    },
                  ),
                  Gap(24.h),
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                      ),
                      onPressed: () {
                        if (form.currentState!.validate()) {
                          updateData(valueKey[index], con.text);
                        }
                      },
                      child: Text(
                        'حفظ التعديل',
                        style: GoogleFonts.cairo(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
