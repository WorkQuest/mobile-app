import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/skill_specialization_selection/skill_specialization_selection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";

class ChangeProfilePage extends StatefulWidget {
  static const String routeName = "/ChangeProfilePage";
  @override
  _ChangeProfilePageState createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends State<ChangeProfilePage> {
  ProfileMeStore? profile;
  SkillSpecializationController? _controller;

  String testText = "";

  @override
  void initState() {
    _controller = SkillSpecializationController();
    profile = context.read<ProfileMeStore>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Change profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(onPressed: () {}, child: const Text("Save")),
        ],
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        children: [
          changeImage(),
          inputBody(
            title: "First name",
            initialValue: profile!.userData!.firstName,
            onChanged: (text) {},
          ),
          inputBody(
            title: "Last name",
            initialValue: profile!.userData!.lastName ?? "",
            onChanged: (text) {},
          ),
          inputBody(
            title: "Address",
            initialValue: profile!.userData!.additionalInfo!.address ?? "",
            onChanged: (text) {},
          ),
          inputBody(
            title: "Phone",
            initialValue: profile!.userData!.phone ?? "",
            onChanged: (text) {},
          ),
          inputBody(
            title: "Email",
            initialValue: profile!.userData!.email ?? "",
            onChanged: (text) {},
          ),
          inputBody(
              title: "Title",
              initialValue:
                  profile!.userData!.additionalInfo!.description ?? "",
              onChanged: (text) {},
              maxLines: null),
          SkillSpecializationSelection(
            controller: _controller,
          ),
          // TextButton(
          //     onPressed: () {
          //       setState(() {
          //         testText =
          //             _controller!.getSkillAndSpecialization().toString();
          //       });
          //     },
          //     child: Text("Get Skill And Specialization")),
          // Text(testText),
          inputBody(
            title: "Twitter",
            initialValue: "link",
            onChanged: (text) {},
          ),
          inputBody(
            title: "Facebook",
            initialValue: "link",
            onChanged: (text) {},
          ),
          inputBody(
            title: "LinkedIn",
            initialValue: "link",
            onChanged: (text) {},
          ),
          inputBody(
            title: "Instagram",
            initialValue: "link",
            onChanged: (text) {},
          ),
          const SizedBox(height: 200),
        ],
      ),
    );
  }

  Widget changeImage() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(65),
            child: Image.network(
              profile!.userData!.avatar!.url,
              height: 130,
              width: 130,
              fit: BoxFit.cover,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget inputBody({
    required String title,
    required String initialValue,
    required void Function(String)? onChanged,
    int? maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 5),
        TextFormField(
          initialValue: initialValue,
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(
                color: Color(0xFFf7f8fa),
                width: 2.0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
