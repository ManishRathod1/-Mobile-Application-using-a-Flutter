import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Makeup App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Validation variables
  bool isEmailValid = true;
  bool isPasswordValid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: isEmailValid ? null : 'Please enter a valid email',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: isPasswordValid ? null : 'Please enter a valid password',
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Validate email and password
                setState(() {
                  isEmailValid = _validateEmail(emailController.text);
                  isPasswordValid = passwordController.text.isNotEmpty;
                });

                // Check if both email and password are valid before navigating
                if (isEmailValid && isPasswordValid) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateEmail(String email) {
    // Simple email validation using a regular expression
    // You might want to use a more robust email validation method
    // For example, you can use a package like email_validator: ^2.0.1
    // https://pub.dev/packages/email_validator
    return RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$").hasMatch(email);
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: BrandsList(),
    );
  }
}

class BrandsList extends StatelessWidget {
  final List<String> brands = [
    'almay',
    'alva',
    'anna sui',
    'annabelle',
    'benefit',
    'boosh',
    "burt's bees",
    'butter london',
    "c'est moi",
    'cargo cosmetics',
    'china glaze',
    'clinique',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: brands.length,
      itemBuilder: (context, index) {
        return BrandItem(brands[index]);
      },
    );
  }
}

class BrandItem extends StatelessWidget {
  final String brandName;

  BrandItem(this.brandName);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(brandName),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BrandInfoScreen(brandName)),
        );
      },
    );
  }
}

class BrandInfoScreen extends StatelessWidget {
  final String brandName;

  BrandInfoScreen(this.brandName);

  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(
      Uri.parse('http://makeup-api.herokuapp.com/api/v1/products.json?brand=maybelliner')
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brand Info: $brandName'),
      ),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Display the fetched data in the UI
            // You can customize this part based on the actual API response structure
            // Example: Text('${snapshot.data['brand']} - ${snapshot.data['product']}')
            return Container();
          }
        },
      ),
    );
  }
}
