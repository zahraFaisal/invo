import 'package:flutter/material.dart';
import 'package:invo_mobile/models/activation/customer.dart';
import 'package:invo_mobile/models/activation/restaurant.dart';
import 'package:invo_mobile/blocs/activation_form/activation_form_bloc.dart';
import 'package:invo_mobile/views/blocProvider.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';

class ActivationFormLandscape extends StatefulWidget {
  ActivationFormLandscape({Key? key}) : super(key: key);

  @override
  _ActivationFormLandscapeState createState() => _ActivationFormLandscapeState();
}

class _ActivationFormLandscapeState extends State<ActivationFormLandscape> {
  var deviceWidth;
  late ActivationFormBloc activationFormBloc;
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  Restaurant restaurant = Restaurant();

  @override
  void initState() {
    super.initState();
    activationFormBloc = new ActivationFormBloc(BlocProvider.of<NavigatorBloc>(context));
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    // this.restaurant.customer = new Customer();
    return SingleChildScrollView(
      child: Form(
        key: _formStateKey,
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  "Activation Form",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              restaurantNameField(),
              SizedBox(
                height: 20,
              ),
              restaurantPhoneField(),
              SizedBox(
                height: 20,
              ),
              restaurantTypeField(),
              SizedBox(
                height: 20,
              ),
              contactNameField(),
              SizedBox(
                height: 20,
              ),
              contactEmailField(),
              SizedBox(
                height: 20,
              ),
              contactPhoneField(),
              SizedBox(
                height: 20,
              ),
              formButtons(),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void save() async {
    _formStateKey.currentState!.save();
    if (_formStateKey.currentState!.validate()) {
      activationFormBloc.saveActivation(restaurant);
      // Navigator.of(context).pop(null);
    }
  }

  Widget restaurantNameField() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text(
              "Restaurant Name",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(
            width: deviceWidth * 0.7,
            child: TextFormField(
              onChanged: (value) {
                restaurant.restaurant_name = value;
              },
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: InputDecoration(labelText: 'Required', border: OutlineInputBorder()),
            ),
          ),
        ],
      ),
    );
  }

  Widget restaurantPhoneField() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text(
              "Restaurant Phone",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(
            width: deviceWidth * 0.7,
            child: TextFormField(
              onChanged: (value) {
                restaurant.restaurant_phone = value;
              },
              decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
            ),
          ),
        ],
      ),
    );
  }

  Widget restaurantTypeField() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text(
              "Restaurant Type",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget contactNameField() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text(
              "Contact Name",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(
            width: deviceWidth * 0.7,
            child: TextFormField(
              onChanged: (value) {
                restaurant.customer!.contact_name = value;
              },
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: InputDecoration(labelText: 'Required', border: OutlineInputBorder()),
            ),
          ),
        ],
      ),
    );
  }

  Widget contactEmailField() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text(
              "Contact Email",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(
            width: deviceWidth * 0.7,
            child: TextFormField(
              onChanged: (value) {
                restaurant.customer!.contact_email = value;
                print("restaurant.customer.contact_email ${restaurant.customer!.contact_email}");
              },
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: InputDecoration(labelText: 'Required', border: OutlineInputBorder()),
            ),
          ),
        ],
      ),
    );
  }

  Widget contactPhoneField() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text(
              "Contact Phone",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(
            width: deviceWidth * 0.7,
            child: TextFormField(
              onChanged: (value) {
                restaurant.customer!.contact_phone = value;
              },
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: InputDecoration(labelText: 'Required', border: OutlineInputBorder()),
            ),
          ),
        ],
      ),
    );
  }

  Widget formButtons() {
    return Container(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 250.0,
              height: 50.0,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                  elevation: MaterialStateProperty.all<double>(5),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[300],
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 250.0,
              height: 50.0,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                  elevation: MaterialStateProperty.all<double>(5),
                ),
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[300],
                  ),
                ),
                onPressed: () {
                  save();
                },
              ),
            ),
          ],
        ));
  }
}
