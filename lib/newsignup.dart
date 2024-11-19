import 'package:flutter/material.dart'; // FlutterのUIライブラリをインポート
import 'package:firebase_auth/firebase_auth.dart'; // Firebaseの認証機能を使用するためのパッケージをインポート

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState(); // SignupScreenの状態を管理するためのStateを作成
}

class _SignupScreenState extends State<SignupScreen> {
  // 新規登録に必要な情報を保持する変数
  String email = ""; // メールアドレスを保持する変数
  String password = ""; // パスワードを保持する変数
  String confirmPassword = ""; // 確認用パスワードを保持する変数
  String signupMessage = ""; // 新規登録メッセージを保持する変数

  final FirebaseAuth _auth = FirebaseAuth.instance; // FirebaseAuthのインスタンスを作成

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新規登録'), // 新規登録画面のタイトル
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 16ピクセルのパディングを設定
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 中央に配置
          children: [
            // メールアドレス入力フィールド
            TextFormField(
              decoration: const InputDecoration(
                labelText: "メールアドレス", // メールアドレス入力フィールドのラベル
                hintText: "example@domain.com", // ヒントテキストを設定
              ),
              keyboardType: TextInputType.emailAddress, // 入力タイプをメールアドレスに設定
              onChanged: (value) {
                setState(() {
                  email = value; // 入力されたメールアドレスを保持
                });
              },
            ),
            // パスワード入力フィールド
            TextFormField(
              decoration: const InputDecoration(
                labelText: "パスワード", // パスワード入力フィールドのラベル
                hintText: "******", // ヒントテキストを設定
              ),
              obscureText: true, // パスワード入力内容を非表示に設定
              onChanged: (value) {
                setState(() {
                  password = value; // 入力されたパスワードを保持
                });
              },
            ),
            // 確認用パスワード入力フィールド
            TextFormField(
              decoration: const InputDecoration(
                labelText: "パスワード（確認）", // 確認用パスワード入力フィールドのラベル
                hintText: "******", // ヒントテキストを設定
              ),
              obscureText: true, // 確認用パスワード入力内容を非表示に設定
              onChanged: (value) {
                setState(() {
                  confirmPassword = value; // 入力された確認用パスワードを保持
                });
              },
            ),
            const SizedBox(height: 20), // ボタンとの間に20ピクセルのスペースを追加
            ElevatedButton(
              onPressed: () async {
                if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) { // フィールドが未入力の場合
                  setState(() {
                    signupMessage = "全てのフィールドを入力してください"; // エラーメッセージを設定
                  });
                  return;
                }
                if (password != confirmPassword) { // パスワードが一致しない場合
                  setState(() {
                    signupMessage = "パスワードが一致しません"; // エラーメッセージを設定
                  });
                  return;
                }
                try {
                  UserCredential userCredential = await _auth.createUserWithEmailAndPassword( // Firebaseでの新規ユーザー登録を試行
                    email: email,
                    password: password,
                  );
                  setState(() {
                    signupMessage = "登録に成功しました"; // 登録成功メッセージを設定
                  });
                  Navigator.pop(context); // 登録後にログイン画面に戻る
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'email-already-in-use') { // 既に使用されているメールアドレスの場合
                    setState(() {
                      signupMessage = "このメールアドレスは既に使用されています"; // エラーメッセージを設定
                    });
                  } else if (e.code == 'weak-password') { // パスワードが弱い場合
                    setState(() {
                      signupMessage = "パスワードは8文字以上にしてください"; // エラーメッセージを設定
                    });
                  } else {
                    setState(() {
                      signupMessage = "エラーが発生しました: ${e.message}"; // その他のエラーメッセージを設定
                    });
                  }
                } catch (e) {
                  setState(() {
                    signupMessage = "エラーが発生しました: ${e.toString()}"; // その他のエラーメッセージを設定
                  });
                }
              },
              child: const Text("新規登録"), // ボタンのテキスト
            ),
            const SizedBox(height: 20), // エラーメッセージとの間に20ピクセルのスペースを追加
            Text(signupMessage), // 新規登録メッセージを表示
          ],
        ),
      ),
    );
  }
}
