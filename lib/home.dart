import 'package:flutter/material.dart';
import 'package:calling_zegocloud/call_services.dart';
import 'package:calling_zegocloud/login.dart';
import 'package:calling_zegocloud/main.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  final CallServices callServices = CallServices();

  @override
  void initState() {
    super.initState();
    final userId = sharedPreferences.getString("id");
    final userName = sharedPreferences.getString("username");

    if (userId != null && userName != null) {
      callServices.onUserLogin(userId, userName);
    }
  }

  void sendCall({required bool isVideoCall}) {
    final userName = userNameController.text.trim();
    final userId = idController.text.trim();

    if (userName.isEmpty || userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid username and ID")),
      );
      return;
    }

    ZegoUIKitPrebuiltCallInvitationService().send(
      resourceID: "FaisalZegoApp",
      invitees: [ZegoCallUser(userId, userName)],
      isVideoCall: isVideoCall,
    );
  }

  void logout() {
    callServices.onUserLogout();
    sharedPreferences.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextFormField(
              controller: userNameController,
              decoration: const InputDecoration(
                hintText: "UserName",
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: idController,
              decoration: const InputDecoration(
                hintText: "ID",
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () => sendCall(isVideoCall: false),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("voice Call", style: TextStyle(color: Colors.white)),
            ),


            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => sendCall(isVideoCall: true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Video Call", style: TextStyle(color: Colors.white)),
            ),

            
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: logout,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("LogOut", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
