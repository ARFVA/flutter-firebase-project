import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyquest/core/theme/app_theme.dart';
import 'package:studyquest/controllers/auth_controller.dart';
import 'package:studyquest/features/auth/views/auth_page_shell.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final args = Get.arguments as Map<String, dynamic>;
    final phoneNumber = args['phoneNumber'] as String;
    final verificationId = args['verificationId'] as String;

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: AuthPageShell(
        icon: Icons.sms_outlined,
        title: 'Enter OTP',
        subtitle: 'Enter the six-digit code sent to $phoneNumber',
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 8,
                ),
                decoration: const InputDecoration(
                  labelText: 'OTP code',
                  hintText: '123456',
                  prefixIcon: Icon(Icons.security_outlined, size: 20),
                  prefixIconColor: AppTheme.primaryColor,
                  counterText: '',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter OTP code';
                  }
                  if (value.length != 6) {
                    return 'OTP must be 6 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Obx(
                () => FilledButton(
                  onPressed: authController.isLoading
                      ? null
                      : () {
                          if (_formKey.currentState?.validate() ?? false) {
                            authController.verifyOtp(
                              verificationId,
                              _otpController.text.trim(),
                            );
                          }
                        },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: authController.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Verify code',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => _showResendDialog(authController, phoneNumber),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                ),
                child: const Text('Resend OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showResendDialog(AuthController authController, String phoneNumber) {
    Get.dialog(
      AlertDialog(
        title: const Text('Resend OTP'),
        content: const Text('Send a new verification code?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Get.back();
              authController.sendOtp(phoneNumber);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Resend'),
          ),
        ],
      ),
    );
  }
}
