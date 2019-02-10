import 'package:flutter/material.dart';
import '../services/authentication.dart';

enum FormMode { LOGIN, SIGNUP }

class LoginPage extends StatefulWidget {

  LoginPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<LoginPage> createState() =>  LoginPageState();

}

class LoginPageState extends State<LoginPage> {
  String _email;
  String _password;
  String _displayName;
  FormMode _formMode = FormMode.LOGIN;
  String _errorMessage = '';
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context){
    //bool _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue,
              Colors.red,
            ],
          )
        ),
        child: Stack(
          children: <Widget>[
            _showBody(),
            _showCircularProgress(),
          ]
        ),
      ),
    );
  }

  Widget _showBody(){
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            // _showLogo(),
            // _showFacebookLogin(),
            _showGoogleLogin(),
            _showEmailInput(),
            _showPasswordInput(),
            _showDisplayNameInput(),
            _showPrimaryButton(),
            _showSecondaryButton(),
            _showErrorMessage(),
          ],
        )
      )
    );
  }

  Widget _showCircularProgress(){
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(height: 0.0, width: 0.0);
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 60.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/logo_icon.png'),
        ),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
          hintText: 'Email',
          icon: Icon(Icons.email, color: Colors.white),
        ),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty': null,
        onSaved: (value) => _email = value,
      ),
    );
  }


  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Password',
          icon: Icon(Icons.lock, color: Colors.white),
        ),
        validator: (value) => value.isEmpty ? 'Passord can\'t be empty' : null,
        onSaved: (value) => _password = value,
      )
    );
  }

  Widget _showDisplayNameInput() {
    if (_formMode == FormMode.LOGIN) {
      return Container();
    }
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Display Name',
            icon: Icon(Icons.person, color: Colors.white),
          ),
          validator: (value) => value.isEmpty ? 'You need a display name' : null,
          onSaved: (value) => _displayName = value,
        )
    );
  }


  Widget _showPrimaryButton() {
    return Padding (
      padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
      child: MaterialButton(
        elevation: 5.0,
        minWidth: 200.0,
        height: 42.0,
        color: Colors.red,
        child: Text( _formMode == FormMode.LOGIN ? 'Login' : 'Create account',
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        onPressed: _authEmailPassword,
      ),
    );
  }

  void _authEmailPassword() async {
    print('Authenticating with username and password.');
    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });
    if (_validateEmailPasswordForm()){
      String userId = '';
      try {
        if (_formMode == FormMode.LOGIN){
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          print('Creating new user');
          userId = await widget.auth.signUp(_email, _password, _displayName);
          print('Signed up: $userId');
        }
        if (userId.length > 0 && userId != null) { //TODO: Check if this lazy evaluation is the right way around
          widget.onSignedIn();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
           _errorMessage = e?.message != null ? e.message : e.details; //TODO: cross compatibility fail here maybe
        });
      }
    }
  }

  bool _validateEmailPasswordForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
  
  Widget _showSecondaryButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: FlatButton(
          child: Text(_formMode == FormMode.LOGIN
              ? 'Create account'
              : 'Have an account? Sign in',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
          ),
          onPressed: _formMode == FormMode.LOGIN
              ? _changeFormToSignUp
              : _changeFormToLogin,
        )
    );
  }

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() => _formMode = FormMode.SIGNUP);
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() => _formMode = FormMode.LOGIN);
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Text(
        _errorMessage,
        style: TextStyle(
          fontSize: 13.0,
          color: Colors.black54,
          height: 1.0,
          fontWeight: FontWeight.w300
        ),
      );
    } else {
      return Container(
        height: 0.0,
      );
    }
  }

  Widget _showGoogleLogin() {
    return RaisedButton(
      color: Colors.red,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset('assets/google-logo.png',
              height: 20.0,
              width: 20.0,
            ),
            Text('Sign up with Google'),
            Container(),
          ]
      ),
      onPressed: _authGoogle,

    );
  }


  void _authGoogle() async {
    print('Authenticating with google.');
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    String userId = '';
    userId = await widget.auth.signInGoogle();
    if (userId.length > 0 && userId != null) { //TODO: Check if this lazy evaluation is the right way around
      widget.onSignedIn();
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to sign on with google';
      });
    }
  }

  Widget _showFacebookLogin() {
    return RaisedButton(
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset('assets/facebook-logo.png',
            height: 20.0,
            width: 20.0,
          ),
          Text('Sign up with Facebook'),
          Container(),
        ]
      ),
      onPressed: _authFacebook,
    );
  }

  void _authFacebook() {
    print('Valdiating facebook');
  }

}