import 'package:booster/booster.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:patient_module/Configurations/app_config.dart';
import 'package:patient_module/Configurations/backEdnConfigs.dart';
import 'package:patient_module/Presentations/elements/loading_widget.dart';
import 'package:patient_module/Presentations/views/categories.dart';
import 'package:patient_module/Presentations/views/chats/recent_chat_list.dart';
import 'package:patient_module/Presentations/views/sign_in.dart';
import 'package:patient_module/application/auth_state.dart';
import 'package:patient_module/infrastructure/models/patient_profile_model.dart';

class AppDrawer extends StatelessWidget {
  final LocalStorage storage = new LocalStorage(BackEndConfigs.loginLocalDB);
  bool initialized = false;
  PatientProfileModel userModel = PatientProfileModel();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: storage.ready,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!initialized) {
            var items = storage.getItem(BackEndConfigs.userDetailsLocalStorage);

            if (items != null) {
              userModel = PatientProfileModel(
                patientName: items['patientName'],
                patientEmail: items['patientEmail'],
                patientPic: items['patientPic'],
                patientAge: items['patientAge'],
              );
            }

            initialized = true;
          }
          return snapshot.data == null
              ? CircularProgressIndicator()
              : _getUI(context);
        });
  }

  Widget _getUI(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          Booster.verticalSpace(10),
          _createDrawerItem(
              icon: Icons.dashboard,
              text: 'Appointments',
              onTap: () {
                Navigator.pop(context);
              }),
          Divider(),
          _createDrawerItem(
              icon: Icons.more,
              text: 'Doctors',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CategoriesView()));
              }),
          Divider(),
          _createDrawerItem(
              icon: Icons.chat,
              text: 'Chats',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RecentChatList()));
              }),
          Divider(),
          _createDrawerItem(
              icon: Icons.exit_to_app_outlined,
              text: 'SignOut',
              onTap: () async {
                await storage.ready;
                storage.clear();
                UserLoginStateHandler.saveUserLoggedInSharedPreference(false);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SignIn()),
                    (route) => false);
              }),
          Divider(),
          ListTile(
            title: Text('1.0.0'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return Container(
      height: 240,
      child: DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(color: AppConfigurations.color),
        child: Column(
          children: [
            Booster.verticalSpace(20),
            Container(
              height: 115,
              width: 115,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl: userModel.patientPic.toString(),
                  placeholder: (context, url) => LoadingWidget(),
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 2, color: Colors.white)),
            ),
            Booster.verticalSpace(10),
            _getHeaderText(
              userModel.patientName.toString(),
            ),
            Booster.verticalSpace(5),
            _getHeaderText(
              userModel.patientEmail.toString(),
            ),
          ],
        ),
      ),
    );
  }

  _getHeaderText(String text) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
    );
  }

  Widget _createDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            icon,
            color: Colors.black,
            size: 16,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
