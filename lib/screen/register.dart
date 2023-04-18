import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:loginsystem/model/profile.dart';

import 'home.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>(); //ไว้เช็คสถานะว่าเป็น รีเซ็ทฟอร์ม เซฟฟอร์ม 
  Profile profile = Profile(); //จะเก็บค่าลงตัวแปรที่เราสร้างไว้ในไฟล์ profile.dart ก็เลยประกาศออปเจคไว้
  final Future<FirebaseApp> firebase = Firebase.initializeApp(); //เรียกใช้ไฟเบส ต้องติดตังไฟเบสคอลใน .yaml ด้วย

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if(snapshot.hasError){ //เชคว่ามันมีเออเร่อรึป่าว 
            return Scaffold(
                appBar: AppBar(
                  title: Text("Error"),
                  ),
                body: Center(child: Text("${snapshot.error}"),
                ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) { //กรณีัไม่เออเร่อจะแสดงอันนี้
            return Scaffold(
              appBar: AppBar(
                title: Text("สร้างบัญชีผู้ใช้"),
              ),
              body: Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("อีเมล", style: TextStyle(fontSize: 20)),
                          TextFormField(
                            validator: MultiValidator([ //validate ได้หลายเงื่อนไข
                              RequiredValidator(errorText: "กรุณาป้อนอีเมลด้วยครับ"),
                              EmailValidator(errorText: "รูปแบบอีเมลไม่ถูกต้อง")
                            ]),
                            keyboardType: TextInputType.emailAddress, //กรอกรูปแบบอีเมล
                            onSaved: (String email) { //บันทึกข้อมูลลงตัวแปร
                              profile.email = email;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text("รหัสผ่าน", style: TextStyle(fontSize: 20)),
                          TextFormField(
                            validator: RequiredValidator(errorText: "กรุณาป้อนรหัสผ่านด้วยครับ"), //ห้ามว่าง
                              obscureText: true, //ซ่อนรหัสผ่าน ให้มองเป็นจุดๆ
                              onSaved: (String password) {
                              profile.password = password;
                            },
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text("ลงทะเบียน",style: TextStyle(fontSize: 20)),
                              onPressed: () async{ //ใส่เพื่อรอ ตรง await
                                if (formKey.currentState.validate()) { //ถ้า validate ผ่านจะทำงาน
                                  formKey.currentState.save(); // ทำให้มันเรียกใช้งาน onSaved ของ textfield
                                  try{ // try ใส่ที่เราจะทำส่วน catch เอาไวกรณีมีเออเร่อ
                                    await FirebaseAuth.instance.createUserWithEmailAndPassword( //สร้างบัญชีผู้ใช้ await เอามาเพื่อให้มันรอใส่เมลกับรหัสก่อน ใส่ async ด้วย
                                      email: profile.email, //เรียกเอาจากที่เก็บมาใส่
                                      password: profile.password
                                    ).then((value){ // คือต้องทำด้านบนให้ได้ก่อน พวกด้านล่างถึงตามมา 
                                      formKey.currentState.reset(); //ให้ formKey เป็นค่าว่าง 
                                      Fluttertoast.showToast(  //toast ไว้แสดงข้อความเออเร่อ
                                        msg: "สร้างบัญชีผู้ใช้เรียบร้อยแล้ว",
                                        gravity: ToastGravity.TOP //ตำแหน่งที่จะให้แสดง
                                      );
                                      Navigator.pushReplacement(context,  //ให้กลับไปหน้าแรก
                                      MaterialPageRoute(builder: (context){
                                          return HomeScreen();
                                      }));
                                    });
                                  }on FirebaseAuthException catch(e){
                                      print(e.code);
                                      String message;
                                      if(e.code == 'email-already-in-use'){
                                          message = "มีอีเมลนี้ในระบบแล้วครับ โปรดใช้อีเมลอื่นแทน";
                                      }else if(e.code == 'weak-password'){
                                          message = "รหัสผ่านต้องมีความยาว 6 ตัวอักษรขึ้นไป";
                                      }else{
                                          message = e.message;
                                      }
                                      Fluttertoast.showToast(
                                        msg: message,
                                        gravity: ToastGravity.CENTER
                                      );
                                  }
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
