import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:phytopathy_prediction/models/chat_model.dart' as chat;
import 'package:phytopathy_prediction/models/phytopathy_encyclopedia_model.dart';
import 'package:phytopathy_prediction/models/user_model.dart';
import 'package:phytopathy_prediction/route.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {

  static const routeName = 'splash';
  static Widget builder(BuildContext context) =>Splash();

  @override
  _SplashState createState() => _SplashState();

  //static const _splashDuration = const Duration(milliseconds: 1200);
}

class _SplashState extends State<Splash> with TickerProviderStateMixin<Splash> ,WidgetsBindingObserver {
  late AnimationController _leafController;
  late AnimationController _titleController;
  late AnimationController _loginController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _leafController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loginController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _initAndShowLogin();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      print(MediaQuery.of(context).viewInsets.bottom);
      if(MediaQuery.of(context).viewInsets.bottom==0){
        _titleController.forward();
      }else{
        _titleController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _leafController.dispose();
    _titleController.dispose();
    _loginController.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final leaf = FadeTransition(
      opacity: CurvedAnimation(
        curve: Interval(
          0.0,
          0.4,
        ),
        parent: _leafController,
      ),
      child: Image.asset('assets/pic/splash/leaf.png'),
    );

    final title = FadeTransition(
      opacity: CurvedAnimation(
        curve: Interval(
          0.6,
          1.0,
        ),
        parent: _titleController,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '寻害助手',
            style: TextStyle(
              fontSize: 40.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 36.0),
          SizedBox(
            height: 80.0,
            child: Image.asset('assets/pic/splash/icons.png'),
          )
        ],
      ),
    );

    final login = FadeTransition(
      opacity: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _loginController,
          curve: Curves.easeIn,
        ),
      ),
      child: _Login(),
    );

    final stack = Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          child: leaf,
          right: 0.0,
          top: 0.0,
          height: 256.0,
          width: 256.0,
        ),
        Positioned(
          child: title,
          left: 0.0,
          top: 200.0,
        ),
        Positioned(
          child: SingleChildScrollView(
            reverse: true,
            padding: const EdgeInsets.all(0.0),
            child: SafeArea(
              child: login,
            ),
          ),
          bottom: 0.0,
          right: 0.0,
          height: 320.0,
          width: size.width * 0.8,
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Padding(
        padding: EdgeInsets.only(left: size.width * 0.12),
        child: stack,
      ),
    );
  }

  Future<void> _initAndShowLogin() async {
    await _initialize();
    await Future.delayed(const Duration(milliseconds: 100));
    _showLoginForm();
  }

  void _showLoginForm() {
    _loginController.forward();
  }

  Future<void> _initialize() async {
    await Future.wait([
      context.read<PhytopathyEncyclopediaModel>().initialize(),
      context.read<UserModel>().loadUser(),
      _leafController.forward().then((_) {
        return _titleController.forward();
      }),
    ]);
    print('initialize end');
  }
}

class _Login extends StatefulWidget {
  @override
  __LoginState createState() => __LoginState();
}

class __LoginState extends State<_Login> {
  bool _isLoading = false;
  bool _check = false;

  final _loginFormKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    context
        .findAncestorStateOfType<_SplashState>()
        ?._loginController
        .addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final user = context.read<UserModel>().savedUser;
        _usernameController.text = user?.username ?? '';
        _passwordController.text = user?.password ?? '';
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget inputField(
      TextEditingController controller,
      IconData leading,
      String hint, [
      bool obscure = false,
    ]) {
      final textField = TextFormField(
        obscureText: obscure,
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
        ),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
        cursorColor: Theme.of(context).primaryColor,
        validator: (value) {
          if (value == null || value.length == 0) {
            return '$hint不能为空';
          }
          if (value.length > 10) {
            return '$hint格式错误';
          }
          return null;
        },
      );

      return Container(
          height: 50.0,
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).primaryColorLight,
                width: 0.8,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                leading,
                color: Theme.of(context).primaryColorLight,
              ),
              Expanded(child: textField),
            ],
          ));
    }

    final uidInput = inputField(
      _usernameController,
      Icons.person,
      '账号',
    );
    final passwordInput = inputField(
      _passwordController,
      Icons.lock,
      '密码',
      true,
    );

    final loginBtn = GestureDetector(
      child: Container(
        width: 216.0,
        height: 64.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _isLoading ? Colors.grey : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32.0),
            bottomLeft: Radius.circular(32.0),
          )
        ),
        child: Text(
          _isLoading ? '加载中，请稍后' : '登   录',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      onTap: _isLoading ? null : _handleLogin,
    );

    final registerBtn = GestureDetector(
      child: Text(
        '注册账号',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
      onTap: _handleJumpRegisterPage,
    );

    final isExpert = Row(
      children: [
        Checkbox(value: _check, onChanged: (value){
          setState(() {
            _check = !_check;
          });
        },checkColor: Theme.of(context).primaryColorLight,tristate: false,),
        Text(
          '专家',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(width: 25.0),
      ],
    );

    final child = Container(
      // color: Colors.red,
      // padding: const EdgeInsets.symmetric(
      //   horizontal: 20.0,
      //   vertical: 8.0,
      // ),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(15.0),
      //   //color: Theme.of(context).canvasColor,
      // ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              uidInput,
              //const SizedBox(height: 8.0),
              passwordInput,
            ],
          ),
          const SizedBox(
            height: 12.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              registerBtn,
              isExpert,
              //const SizedBox(width: 5.0),
            ],
          ),
          const SizedBox(
            height: 80.0,
          ),
          SizedBox(
            // height: 48.0,
            // width: 56.0,
            child: Align(
              alignment: Alignment.bottomRight,
              child: loginBtn,
            ),
          ),
        ],
      ),
    );

    return SafeArea(
      child: Form(
        key: _loginFormKey,
        child: child,
      ),
    );
  }

  void _handleLogin() async {
    final model = context.read<UserModel>();

    if (_isLoading) {
      return;
    }

    if (!(_loginFormKey.currentState?.validate() ?? true)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    var result = await model.login(
      _usernameController.text,
      _passwordController.text,
      false,
    );

    if (result) {
      result = await context.read<chat.ChatModel>().connectServer(
            _usernameController.text,
            _check,
          );
      if (result) {
        Navigator.pushReplacementNamed(context, Routes.navigation);

        /// save user info
      } else {
        _alert('连接服务器失败，请检查网络');
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      _alert('用户名或者密码错误，登陆失败');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _alert(String content) {
    showToast(
      content,
      position: ToastPosition.bottom,
    );
  }

  void _handleJumpRegisterPage() {
    Navigator.pushNamed(context, Routes.register);
  }
}
