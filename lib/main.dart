import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_two/image.dart';
import 'package:flutter_application_two/reg.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _key = GlobalKey();
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    TextEditingController _userNameController = TextEditingController();
    TextEditingController _userPasswordController = TextEditingController();

    final FirebaseAuth auth = FirebaseAuth.instance;

    Future<void> signWithEmail(String email, String password) async {
      try {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        const snackBar = SnackBar(
          content: Text('Авторизация прошла успешно'),
        );
      } on FirebaseAuthException catch (e) {
        const snackBar = SnackBar(
          content: Text('Данные введены неверно'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    void signAnonimous() async {
      try {
        final user = await FirebaseAuth.instance.signInAnonymously();
        const snackBar = SnackBar(
          content: Text('Анонимная авторизация успешна'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } on FirebaseAuthException catch (e) {
        print(e);
        const snackBar = SnackBar(
          content: Text('Ошибка'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Авторизация',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Введите ваш email',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _userPasswordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                signWithEmail(
                    _userNameController.text, _userPasswordController.text);
              },
              child: Text('Авторизация'),
            ),
            ElevatedButton(
              onPressed: () {
                // signWithEmail(
                //     _userNameController.text, _userPasswordController.text);

                signAnonimous();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ImageView()));
              },
              child: Text('Анонимно'),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Reg()),
                );
              },
              child: const Text(
                'Регистрация',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
