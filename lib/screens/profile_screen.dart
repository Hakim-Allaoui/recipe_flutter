import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constant/app_images.dart';

import '../constant/app_bar.dart';
import '../constant/app_fonts.dart';
import '../constant/custom_text_form_field.dart';
import '../provider/user.dart';
import '../screens/main_auth_screen.dart';
import '../constant/static_string.dart';
import '../widget/app_drawer.dart';
import '../widget/safearea_with_banner.dart';
import '../widget/process_indicator_view.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile-screen';

  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _editingEnabled = false;

  final Map<String, String> _formData = {
    'firstname': '',
    'lastname': '',
    'phone': '',
  };

  UserItem? _user;
  File?imageFile;
  bool _isInit = true;
  bool _isLoading = false;
  bool _isUpdating = false;
  Future<File>? imagePickerFile;

  FocusNode _firstNameFocusNode = FocusNode();
  FocusNode _lastNameFocusNode = FocusNode();
  FocusNode _mobileFocusNode = FocusNode();

  final List<String> userDetailKeyList = [
    StaticString.firstName,
    StaticString.lastName,
    StaticString.mobile,
    StaticString.email,
  ];

  @override
  void initState() {
    if (_isInit) {
      _isLoading = true;
      Provider.of<UserProvider>(context, listen: false)
          .fetchUserInfo()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _mobileFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    _user = Provider.of<UserProvider>(context, listen: false).getUserInfo;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(StaticString.profile),
          actions: <Widget>[
            !_isLoading
                ? _getEditIcon(
                    icon: _editingEnabled ? Icons.done : Icons.edit,
                    color: _editingEnabled
                        ? Colors.green
                        : Theme.of(context).colorScheme.secondary)
                : Container(),
            !_isLoading
                ? _editingEnabled
                    ? _getEditIcon(icon: Icons.close, color: Colors.red)
                    : Container()
                : Container()
          ],
        ),
        drawer: AppDrawer(),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              SafeareaWithBanner(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                        height: screenSize.height,
                        width: screenSize.width,
                        child: SingleChildScrollView(
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                // Stack(
                                //   alignment: Alignment.topCenter,
                                //   children: <Widget>[
                                //     //Todo: show profile pic with update functionality
                                //     _buildProfilePic(),
                                //   ],
                                // ),
                                _buildForm()
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
              _isUpdating ? ProcessIndicatorView() : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getEditIcon({required IconData icon, required Color color}) {
    return Consumer<UserProvider>(
      builder: (ctx, userProvider, child) {
        return GestureDetector(
          child: child,
          onTap: () async {
            if (icon == Icons.done) {
              if (!_formKey.currentState!.validate()) {
                return;
              }

              setState(() {
                _isUpdating = true;
              });

              _formKey.currentState!.save();

              UserItem userInfo = UserItem.fromJson(_formData);

              bool isUpdated = await userProvider.updateUserDetails(
                  context: context, userInfo: userInfo, imageFile: imageFile!);

              setState(() {
                _isUpdating = false;
              });

              // check if is updated successfully show alert
            }

            setState(() {
              _editingEnabled = !_editingEnabled;
            });
          },
        );
      },
      child: Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: CircleAvatar(
          backgroundColor: color,
          radius: 16.0,
          child: Icon(
            icon,
            color: Colors.white,
            size: 16.0,
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePic() {
    return GestureDetector(
      onTap: () {
        if (_editingEnabled) {
          showCupertinoModalPopup(
            context: context,
            builder: (ctx) {
              return Container();
//              return _showActionSheet();
            },
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 30),
        height: 130,
        width: 130,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.grey.withOpacity(0.4), width: 2),
          borderRadius: BorderRadius.circular(65),
        ),
        child: ClipRect(
          child: FutureBuilder<File>(
            future: imagePickerFile,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Image.asset(
                  AppImages.noProfileImg,
                  fit: BoxFit.cover,
                );
              }
              return Image.asset(
                AppImages.noProfileImg,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _buildSectionHeading(StaticString.profileInfo.toUpperCase()),
          _buildFirstNameField(),
          _buildLastName(),
          _buildMobileTextField(),
          _buildEmailTextField(),
          _buildDeleteAccount(),
        ],
      ),
    );
  }

  Widget _buildSectionHeading(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      alignment: Alignment.bottomLeft,
      height: 48,
      child: CustomText(
        txtColor: Color(0xFF5c5760),
        txtFontName: AppFonts.montserrat,
        txtFontStyle: FontWeight.w100,
        txtSize: 14,
        txtTitle: title,
        letterSpacing: 1.25,
      ),
    );
  }

  Widget _buildFirstNameField() {
    return _buildProfileCard(
      leftTitle: userDetailKeyList[0],
      rightChild: CustomTextFormField(
        hideborder: true,
        enabled: _editingEnabled,
        initialText: _user != null
            ? _user!.firstname == null ? 'N/A' : _user!.firstname
            : 'N/A',
        focusNode: _firstNameFocusNode,
        placeHolderText: StaticString.firstName,
        onSaved: (value) {
          _formData['firstname'] = value;
        },
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_lastNameFocusNode);
        },
        textFieldType: TextFieldType.Normal,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget _buildLastName() {
    return _buildProfileCard(
      leftTitle: userDetailKeyList[1],
      rightChild: CustomTextFormField(
        hideborder: true,
        enabled: _editingEnabled,
        initialText: _user == null
            ? 'N/A'
            : _user!.lastname == null ? 'N/A' : _user!.lastname,
        focusNode: _lastNameFocusNode,
        placeHolderText: StaticString.lastName,
        onSaved: (value) {
          _formData['lastname'] = value;
        },
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_mobileFocusNode);
        },
        textFieldType: TextFieldType.Normal,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget _buildMobileTextField() {
    return _buildProfileCard(
      leftTitle: userDetailKeyList[2],
      rightChild: CustomTextFormField(
        hideborder: true,
        enabled: _editingEnabled,
        initialText:
            _user == null ? 'N/A' : _user!.phone == null ? 'N/A' : _user!.phone,
        focusNode: _mobileFocusNode,
        placeHolderText: StaticString.mobile,
        onSaved: (value) {
          _formData['phone'] = value;
        },
        textFieldType: TextFieldType.Normal,
        textInputAction: TextInputAction.done,
      ),
    );
  }

  //Email TextField...
  Widget _buildEmailTextField() {
    return _buildProfileCard(
      leftTitle: userDetailKeyList[3],
      rightChild: TextFormField(
        enabled: false,
        initialValue:
            _user == null ? 'N/A' : _user!.email == null ? 'N/A' : _user!.email,
        maxLines: null,
        decoration: customTxtInputDecoration(
            text: StaticString.email, hideBorder: true),
      ),
    );
  }

  Widget _buildDeleteAccount() {
    return Consumer<UserProvider>(
      builder: (ctx, userProvider, child) {
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: Text('Delete Account'),
                  content: Text('Do you really want to delete this account?'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('No'),
                      onPressed: () async {
                        bool isDeleted =
                            await userProvider.deleteAccount(context: context);
                        if (isDeleted) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    TextButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (ctx) => MainAuthScreen(),
                              fullscreenDialog: true),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            padding: EdgeInsets.only(top: 32),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerLeft,
              color: Colors.white,
              height: 57.0,
              child: CustomText(
                txtColor: Theme.of(context).colorScheme.error,
                txtFontName: AppFonts.montserrat,
                txtFontStyle: FontWeight.normal,
                txtTitle: StaticString.deleteAccount,
                txtSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }

  //Commonly used widgets

  Widget _buildProfileCard({
    required String leftTitle,
    required Widget rightChild,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: CustomText(
                    align: TextAlign.start,
                    txtColor: Colors.black,
                    txtFontName: AppFonts.montserrat,
                    txtFontStyle: FontWeight.w500,
                    txtSize: 14,
                    txtTitle: leftTitle,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: rightChild,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

//  Widget _showActionSheet() {
//    return CupertinoActionSheet(
//      // title: Text(''),
//      actions: <Widget>[
//        CupertinoActionSheetAction(
//          child: Text('Take Photo'),
//          onPressed: () {
//            Navigator.of(context).pop();
//            pickImage(ImageSource.camera);
//          },
//        ),
//        CupertinoActionSheetAction(
//          child: Text('Choose Photo'),
//          onPressed: () {
//            Navigator.of(context).pop();
//            pickImage(ImageSource.gallery);
//          },
//        ),
//      ],
//      cancelButton: CupertinoActionSheetAction(
//        child: Text('Cancel'),
//        onPressed: () {
//          Navigator.of(context).pop();
//        },
//      ),
//    );
//  }
//
//  pickImage(ImageSource source) async {
//    // var image = await ImagePicker.pickImage(source: source);
//    setState(() {
//      imagePickerFile = ImagePicker.pickImage(source: source);
//    });
//  }
}
