import 'package:flutter/material.dart'; // FlutterのUIライブラリをインポート
import 'package:firebase_auth/firebase_auth.dart'; // Firebaseの認証機能を使用するためのパッケージをインポート
import 'main.dart'; // Firebaseのオプション設定をインポート


// ホーム画面のウィジェット
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム画面'), // ホーム画面のタイトル
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 中央に配置
          children: [
            const Text('HelloWorld!'), // HelloWorld!を中央に表示
            const SizedBox(height: 20), // 20ピクセルのスペースを追加
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut(); // サインアウト処理
                print("サインアウト完了"); // デバッグ用のログ
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()), // ログイン画面に戻る
                );
              },
              child: const Text("ログアウト"), // ログアウトボタンのテキスト
            ),
          ],
        ),
      ),
    );
  }
}