import 'package:bika/src/api/login.dart';
import 'package:bika/src/base/logger.dart';
import 'package:bika/src/views/toast.dart';
import 'package:flutter/material.dart';
import 'package:bika/src/theme/color.dart';
import 'package:intl/intl.dart';

class RegisterWidget extends StatelessWidget {
  static const String routeName = '/register';
  const RegisterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('注册'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AppColors.backgroundColor(context),
        surfaceTintColor: AppColors.backgroundColor(context),
      ),
      backgroundColor: AppColors.backgroundColor(context),
      body: const RegisterBodyWidget(),
    );
  }
}

class RegisterBodyWidget extends StatefulWidget {
  const RegisterBodyWidget({super.key});

  @override
  State<RegisterBodyWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterBodyWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _securityQuestion1Controller = TextEditingController();
  final _securityAnswer1Controller = TextEditingController();
  final _securityQuestion2Controller = TextEditingController();
  final _securityAnswer2Controller = TextEditingController();
  final _securityQuestion3Controller = TextEditingController();
  final _securityAnswer3Controller = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedGender;
  final List<String> _genders = ['绅士', '淑女', '机器人'];

  bool _registerButtonBusy = false;

  Future<void> _register() async {
    setState(() {
      _registerButtonBusy = true;
    });
    try {
      final nickname = _nicknameController.text;
      final username = _usernameController.text;
      final password = _passwordController.text;
      final securityQuestion1 = _securityQuestion1Controller.text;
      final securityAnswer1 = _securityAnswer1Controller.text;
      final securityQuestion2 = _securityQuestion2Controller.text;
      final securityAnswer2 = _securityAnswer2Controller.text;
      final securityQuestion3 = _securityQuestion3Controller.text;
      final securityAnswer3 = _securityAnswer3Controller.text;
      final selectBirthday = _selectedDate;
      final selectGender = _selectedGender ?? '';

      final birthday = selectBirthday != null
          ? DateFormat('yyyy-MM-dd').format(selectBirthday)
          : '2000-01-01';
      final gender = selectGender == '绅士'
          ? 'm'
          : selectGender == '淑女'
              ? 'f'
              : 'bot';

      await LoginApi.register(
        nickname,
        username,
        password,
        birthday,
        gender,
        securityQuestion1,
        securityAnswer1,
        securityQuestion2,
        securityAnswer2,
        securityQuestion3,
        securityAnswer3,
      );

      // 注册成功，返回登录页面并传递账号密码
      if (mounted) {
        Navigator.of(context).pop({
          'username': username,
          'password': password,
        });
      }
    } catch (e) {
      BikaLogger().e(e.toString());
      GlobalToast.show("注册失败", debugMessage: e.toString());
    } finally {
      setState(() {
        _registerButtonBusy = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _securityQuestion1Controller.dispose();
    _securityAnswer1Controller.dispose();
    _securityQuestion2Controller.dispose();
    _securityAnswer2Controller.dispose();
    _securityQuestion3Controller.dispose();
    _securityAnswer3Controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18 + 5)),
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18 + 5)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: '昵称 (2-50字)',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入昵称';
                }
                if (value.length < 2 || value.length > 50) {
                  return '昵称长度必须在2-50字之间';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: '哔咔登录账号 [0-9a-z_]',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入登录账号';
                }
                if (!RegExp(r'^[0-9a-z_]+$').hasMatch(value)) {
                  return '账号只能包含数字、小写字母和下划线';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: '哔咔登录密码 (8字以上)',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入密码';
                }
                if (value.length < 8) {
                  return '密码长度必须大于8位';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: '确认密码',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value != _passwordController.text) {
                  return '两次输入的密码不一致';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text('你的生日和性别(18+)', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      _selectedDate == null
                          ? '选择日期'
                          : '${_selectedDate!.year}年${_selectedDate!.month}月${_selectedDate!.day}日',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: '性别',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedGender,
                    items: _genders.map((String gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return '请选择性别';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('请输入你的安全问题和答案', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _securityQuestion1Controller,
              decoration: const InputDecoration(
                labelText: '安全问题 1',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入安全问题';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _securityAnswer1Controller,
              decoration: const InputDecoration(
                labelText: '答案1',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入答案';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _securityQuestion2Controller,
              decoration: const InputDecoration(
                labelText: '安全问题 2',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入安全问题';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _securityAnswer2Controller,
              decoration: const InputDecoration(
                labelText: '答案2',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入答案';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _securityQuestion3Controller,
              decoration: const InputDecoration(
                labelText: '安全问题 3',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入安全问题';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _securityAnswer3Controller,
              decoration: const InputDecoration(
                labelText: '答案3',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入答案';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _registerButtonBusy
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          await _register();
                        } else {
                          GlobalToast.show("有格式不对的内容，请检查");
                        }
                      },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: _registerButtonBusy
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('注册', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
