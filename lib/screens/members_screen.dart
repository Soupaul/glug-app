import 'package:flutter/material.dart';
import 'package:glug_app/blocs/profiles_bloc.dart';
import 'package:glug_app/models/profile_model.dart';
import 'package:glug_app/models/profile_response.dart';
import 'package:glug_app/widgets/drawer_items.dart';
import 'package:glug_app/widgets/error_widget.dart';
import 'package:glug_app/widgets/profile_tile.dart';

class MembersScreen extends StatefulWidget {
  static final id = 'membersscreen';

  @override
  _MembersScreenState createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  List<ProfileTile> _finalYears = [];
  List<ProfileTile> _thirdYears = [];
  List<ProfileTile> _secondYears = [];

  @override
  void initState() {
    profilesBloc.fetchAllProfiles();
    super.initState();
  }

  @override
  void dispose() {
    profilesBloc.dispose();
    super.dispose();
  }

  void _group(List<Profile> profiles) {
    profiles.forEach((profile) {
      if (profile.yearName == 4)
        _finalYears.add(ProfileTile(profile: profile));
      else if (profile.yearName == 3)
        _thirdYears.add(ProfileTile(profile: profile));
      else if (profile.yearName == 2)
        _secondYears.add(ProfileTile(profile: profile));
    });
  }

  List<Profile> _sort(List<Profile> p) {
    p.sort((a, b) => a.yearName < b.yearName ? 1 : -1);
    return p;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: DrawerItems(),
      ),
      appBar: AppBar(
        title: Text("Our Team"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: profilesBloc.allProfiles,
              builder: (context, AsyncSnapshot<ProfileResponse> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.error != null &&
                      snapshot.data.error.length > 0) {
                    return errorWidget(snapshot.data.error);
                  }
                  List<Profile> prof = _sort(snapshot.data.profiles);
                  return ListView.builder(
                    itemCount: prof.length,
                    itemBuilder: (context, index) {
                      return ProfileTile(profile: prof[index]);
                    },
                  );
                  // _group(snapshot.data.profiles);
                  // return Column(
                  //   // crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     SizedBox(height: 20.0),
                  //     Padding(
                  //       padding: const EdgeInsets.only(left: 10.0),
                  //       child: Text(
                  //         "Final Years",
                  //         style: TextStyle(
                  //           fontSize: 20.0,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: ListView(
                  //         children: _finalYears,
                  //       ),
                  //     ),
                  //     Padding(
                  //       padding: const EdgeInsets.only(left: 10.0),
                  //       child: Text(
                  //         "Third Years",
                  //         style: TextStyle(
                  //           fontSize: 20.0,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: ListView(
                  //         children: _thirdYears,
                  //       ),
                  //     ),
                  //     Padding(
                  //       padding: const EdgeInsets.only(left: 10.0),
                  //       child: Text(
                  //         "Second Years",
                  //         style: TextStyle(
                  //           fontSize: 20.0,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: ListView(
                  //         children: _secondYears,
                  //       ),
                  //     ),
                  //   ],
                  // );
                } else if (snapshot.hasError) {
                  return errorWidget(snapshot.error);
                } else
                  return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
