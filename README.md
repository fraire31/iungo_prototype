# IUNGO


## About

IUNGO is a automotive RFQ flutter app that handles two user types, where one user requests for a quote on automotive services or products,
and another response to this request with a quote.

User Types: users, providers

1. Users are user types that can request a quote on automotive services or automotive products, with the ability to add provider location preferences.  

2. Provider user types are users that provide automotive services and/or automotive products, and have the option to reply to a Users quotation request. 

   
The User's request will be sent to the providers that are in range of the postal code set by the user. (Providers must provide the services/products requested)
Providers will receive the request and have the option to send the User a quote. 

The provider will only have 10 mins to response to the request before the request status is closed.


## Installation

Make sure you are using Android studio 2.0 +

Flutter pub get 

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)

## Future Implementations
The app is a work in progress.

Currently a user can register as a User or a Provider via email, google-sign-in or facebook-login.

The User can request an automotive product and a provider will receive it.

Authorization for different users are yet to be implemented. 

## Widgets
FutureBuilder
Consumer 
GridView
SingleChildScrollView
GestureDetector
InkWell
Drawer
SnackBar
Dialog
Form
CircularProgressIndicator
GoogleMap
Slider

Extracted Widgets/Custom Widgets


## Packages
provider
uuid
intl
http
font_awesome_flutter
geocoding
cloud_firestore
firebase_core
firebase_auth
google_sign_in
flutter_facebook_auth
google_maps_flutter

## Backend 
FireStore Database -  get, add, Rules
Firebase Authentication - create , delete
Cloud Firestore - cloud functions, adding meta-data to payload
Firebase Storage - images

# iungo_prototype
