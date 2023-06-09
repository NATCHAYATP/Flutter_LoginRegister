import 'package:flutter/material.dart';
import 'package:loginsystem/screen/login.dart';
import 'package:loginsystem/screen/register.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register/Login",
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 0), //กำหนดขอบซ้ายขวาบนล่าง
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/images/logo.png"),
              SizedBox( //ใช้ทำปุ่ม
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label:
                      Text("สร้างบัญชีผู้ใช้", style: TextStyle(fontSize: 20)),
                      onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute( //กดแล้วพาไปหน้าอื่น ถ้าเป็น push เฉยๆมันจะซ้ำหน้าเดิม
                        builder: (context){
                          return RegisterScreen(); //หน้าที่จะให้พาไปเมื่อกด
                      })
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.login),
                  label: Text("เข้าสู่ระบบ", style: TextStyle(fontSize: 20)),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context){
                          return LoginScreen();
                      })
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
