# FreshFarmily

FreshFarmily is a multi platform application designed to seamlessly connect farmers, consumers, and delivery agents. This platform facilitates direct communication, efficient logistics, and secure transactions, empowering local agriculture communities and enhancing consumer access to fresh, farm-produced goods.

## Project Overview

FreshFarmily addresses the gap between local farmers and consumers by providing a direct digital marketplace. Consumers enjoy access to fresh, quality produce, farmers benefit from broader market reach and reduced intermediaries, and delivery agents find streamlined job opportunities.

## Key Features

- User Authentication: Secure sign-up and login for consumers, farmers, and delivery agents using Firebase Authentication.

- Role-Based Interface: Customized functionalities for farmers (listing products), consumers (browsing and purchasing), and delivery agents (order tracking).

- Real-time Database: Manage dynamic data (orders, listings, user details) efficiently with Firestore.

- Order Management: Integrated order placement and tracking system.

- Notifications: Real-time notifications to enhance user engagement and provide timely updates.

## Technologies Used

### Flutter Framework:

- Cross-platform development supporting both Android and iOS platforms.

- Reactive UI components ensuring smooth user experiences.

### Firebase Authentication:

- Robust, secure authentication and user identity management.

- Support for email/password and third-party login (Google, Apple).

### Firestore Database:

- Real-time NoSQL database for scalable data management.

- Secure and flexible data storage tailored to real-time updates.

## Installation & Setup

### Clone the repository:
`git clone https://github.com/jibi21212/freshfarmily.git`

### Navigate into project directory:
`cd freshfarmily`

### Install dependencies:
`flutter pub get`

### Configure Firebase:

- Create a new Firebase project on the Firebase Console.

- Enable Firebase Authentication and Firestore Database.

- Add Android and iOS apps to your Firebase project and follow the provided instructions to download configuration files.

- Place the configuration files (google-services.json for Android, and GoogleService-Info.plist for iOS) into your project as per official Firebase documentation.

### Run the app:

`flutter run`

## Future Improvements

- Advanced Payment Integration: Secure, direct payment gateways.

- Enhanced Logistics System: Advanced route optimization for delivery agents.

- Community Features: Forums and community posts to enhance engagement.

## License

This application is a prototype developed specifically for the Riipen Level UP program. Licensing and further usage rights are subject to conditions set forth by the program guidelines and project organizers.

## Demo Video: 

https://youtu.be/DTGMHdarT9g