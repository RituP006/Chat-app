import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../pickers/user_image_picker.dart';

class Authform extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    File userImage,
    bool isLogin,
    BuildContext ctx,
  ) _submitAuthFun;

  final bool isLoading;

  Authform(this._submitAuthFun, this.isLoading);
  @override
  _AuthformState createState() => _AuthformState();
}

class _AuthformState extends State<Authform> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userName = "";
  var _userEmail = "";
  var _userPassword = "";
  File _userImageFile;

  void _pickedImage(PickedFile image) {
    _userImageFile = File(image.path);
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save(); // triggers onSave of every TextFormField
      widget._submitAuthFun(
        _userEmail.trim(),
        _userPassword,
        _userName,
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shadowColor: Colors.pink.shade900,
        elevation: 0,
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (_isLogin)
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage('assets/image/img4.png'),
                          ),
                        ),
                        child: Opacity(
                          opacity: 0,
                          child: Text('hello',
                              style: TextStyle(
                                  fontSize: 100, color: Colors.white)),
                        ),
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    if (!_isLogin) UserImagePicker(_pickedImage),
                    TextFormField(
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return "Please Enter a valid email";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email address',
                      ),
                      onSaved: (value) {
                        _userEmail = value;
                      },
                    ),
                    if (!_isLogin)
                      TextFormField(
                        autocorrect: true,
                        textCapitalization: TextCapitalization.words,
                        key: ValueKey('username'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 4) {
                            return "Please enter atleast 4 characters";
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Username'),
                        onSaved: (value) {
                          _userName = value;
                        },
                      ),
                    TextFormField(
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value.length < 6 || value.isEmpty) {
                          return "Password must be atleast 7 characters long";
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      onSaved: (value) {
                        _userPassword = value;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    if (widget.isLoading) CircularProgressIndicator(),
                    if (!widget.isLoading)
                      ElevatedButton(
                        child: Text(_isLogin ? 'Login' : 'Signup'),
                        onPressed: _trySubmit,
                      ),
                    if (!widget.isLoading)
                      TextButton(
                        onPressed: () {
                          print('working');
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin
                            ? 'Create new account'
                            : "I already have an account"),
                      )
                  ], //so that it takes as much space as needed.
                )),
          ),
        ),
      ),
    );
  }
}



// PRoblem - When we render username field in signup mode, it gets prefilled by the password, this is because we dynamilcaly add and 
// remove a TextForm field and inside of that array flutter is not able to differentiate between them. 

// Solution - Keys are solution here, keys allow flutter to uniquely identify an element when you have similar widgets next to each other. 