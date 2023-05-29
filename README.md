# Announcement Organizer and Archive Application

This project is a thesis work for the final year of a Computer Science major. The goal is to develop an application using Flutter and Firebase Cloud services to organize announcements and maintain an archive. The application will incorporate features such as authentication, notification, and categorization of announcements.

## Features

1. **User Authentication**: Users can create an account and securely log in to the application. Firebase Authentication is utilized to handle the authentication process and ensure data privacy.

2. **Announcement Creation**: Authenticated users can create announcements by providing details such as title, content, date, and category. They can also attach files, images, or videos to the announcements.

3. **Announcement Organization**: Announcements are categorized based on different criteria like date, department, event type, or custom categories defined by the organization. Users can browse and search for announcements based on these categories.

4. **Announcement Archive**: Announcements are automatically archived based on predefined criteria, such as expiration date or manual archiving. Archived announcements are accessible for reference but are not displayed in the primary announcement feed.

5. **Notification System**: Users can opt to receive notifications for new announcements, updates, or specific categories of interest. Firebase Cloud Messaging is used to send push notifications to users' devices.

6. **User Roles and Permissions**: The application supports different user roles, including administrators, moderators, and regular users. Each role has specific permissions and access levels within the application.

7. **Real-time Updates**: Whenever a new announcement is published or an existing one is updated, the application provides real-time updates to all users through push notifications or a live update mechanism.


## Technologies Used

- Flutter: A cross-platform framework for developing mobile applications.
- Firebase Cloud Firestore: A NoSQL cloud database for storing and retrieving announcement data.
- Firebase Cloud Messaging: A service for sending push notifications to users' devices.
- Firebase Authentication: A secure authentication service for user registration and login.

## Development

The application is developed using the Flutter framework and follows best practices in software engineering. The codebase is structured and modular to ensure code quality, scalability, and maintainability. Automated testing is conducted to validate the application's functionality and provide a seamless user experience.
