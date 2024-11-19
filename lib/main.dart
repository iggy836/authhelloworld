import 'package:flutter/material.dart'; // FlutterのUIライブラリをインポート
import 'package:firebase_core/firebase_core.dart'; // Firebaseの初期化を行うためのパッケージをインポート
import 'package:firebase_auth/firebase_auth.dart'; // Firebaseの認証機能を使用するためのパッケージをインポート
import 'firebase_options.dart'; // Firebaseのオプション設定をインポート
import 'newsignup.dart'; //新規登録画面
import 'home_screen.dart'; // ホーム画面



void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutterのバインディングを初期化（Firebase初期化前に必要）
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Firebaseの初期化オプションを設定
  );
  runApp(const MyApp()); // MyAppウィジェットを起動
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // デバッグバナーを非表示に設定
      home: LoginScreen(), // 最初に表示する画面としてLoginScreenを設定
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState(); // LoginScreenの状態を管理するためのStateを作成
}

class _LoginScreenState extends State<LoginScreen> {
  // ユーザー入力を保持する変数
  String email = ""; // メールアドレス
  String password = ""; // パスワード
  String message = ""; // エラーメッセージ

  final FirebaseAuth _auth = FirebaseAuth.instance; // FirebaseAuthのインスタンスを作成

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログイン画面'), // ログイン画面のタイトル
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 画面全体に16ピクセルのパディングを設定
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 中央に配置
          children: [
            // メールアドレス入力フィールド
            TextFormField(
              decoration: const InputDecoration(
                labelText: "メールアドレス", // ラベル
                hintText: "example@domain.com", // ヒントテキスト
              ),
              keyboardType: TextInputType.emailAddress, // 入力タイプをメールアドレスに設定
              onChanged: (value) {
                setState(() {
                  email = value; // メールアドレスの入力値を保持
                });
              },
            ),
            // パスワード入力フィールド
            TextFormField(
              decoration: const InputDecoration(
                labelText: "パスワード", // ラベル
                hintText: "******", // ヒントテキスト
              ),
              obscureText: true, // パスワード入力内容を隠す設定
              onChanged: (value) {
                setState(() {
                  password = value; // パスワードの入力値を保持
                });
              },
            ),
            const SizedBox(height: 20), // 20ピクセルのスペースを追加
            // ログインボタン
            ElevatedButton(
              onPressed: () async {
                if (email.isEmpty || password.isEmpty) { // 入力が空の場合の処理
                  setState(() {
                    message = "全てのフィールドを入力してください"; // エラーメッセージを設定
                  });
                  return;
                }
                try {
                  // Firebaseの認証処理
                  UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  print("ログイン成功: ${userCredential.user?.email}"); // デバッグ用のログ
                  // ログイン成功時にホーム画面に遷移
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found' || e.code == 'wrong-password') {
                    setState(() {
                      message = "メールアドレスまたはパスワードが正しくありません"; // 認証失敗メッセージ
                    });
                  } else if (e.code == 'network-request-failed') {
                    setState(() {
                      message = "ネットワークに接続できません。接続を確認してください"; // ネットワークエラーメッセージ
                    });
                  } else {
                    setState(() {
                      message = "エラーが発生しました: ${e.message}"; // その他のエラーメッセージ
                    });
                  }
                  print("エラーコード: ${e.code}"); // デバッグ用のエラーログ
                } catch (e) {
                  setState(() {
                    message = "エラーが発生しました: ${e.toString()}"; // その他のエラーメッセージ
                  });
                  print("予期しないエラー: ${e.toString()}"); // デバッグ用の予期しないエラーログ
                }
              },
              child: const Text("ログイン"), // ボタンのテキスト
            ),
            const SizedBox(height: 20), // 新規登録ボタンとの間に20ピクセルのスペースを追加
              ElevatedButton(
                onPressed: () { // 新規登録ボタンが押されたときの処理
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()), // 新規登録画面に遷移
                  );
                },
                child: const Text("新規登録"), // 新規登録ボタンに表示されるテキスト
              ),
            // エラーメッセージの表示
            Text(message),
          ],
        ),
      ),
    );
  }
}


