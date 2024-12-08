
# 📹 Zoom Clone Application

A **video conferencing application** built with the Flutter framework, designed for seamless and feature-rich online meetings. Powered by **Firebase** and utilizing the `zego_uikit_prebuilt_video_conference` package, this app ensures robust functionality and an intuitive user experience.

---

## 🌟 Features

### 🔑 Authentication
- Supports **4 providers** for secure login:
  - **Email & Password**
  - **Google**
  - **Facebook**
  - **Twitter**
- User activity such as meeting creation and participation is logged in **Firestore**, including:
  - Meeting creation time.
  - Join/leave times.
  - Meeting durations.

### 🎥 Video Conferencing
- **Create and share meetings**:
  - Generate a unique meeting ID for others to join.
  - Share your **Personal Meeting ID** for recurring meetings or create random IDs for new sessions.
- **Screen sharing**:
  - Share important content such as PPTs, Word files, or any other materials during a video conference.

### 🔗 App Links Integration
- **Join with a single click**:
  - Share a meeting link. When clicked, it redirects the user directly to the **Video Conference page** and joins the meeting automatically.

### 🛡️ User Meeting History
- All meetings are logged in **Firestore**, including:
  - **Created meetings**.
  - **Joined meetings**.
  - **Meeting durations** for better tracking and history management.

---

## 🚀 Getting Started

### Prerequisites
1. Install Flutter ([Flutter Installation Guide](https://flutter.dev/docs/get-started/install)).
2. Set up Firebase for your project ([Firebase Setup Guide](https://firebase.google.com/docs/flutter/setup)).

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/kamesh7773/zoom_clone
   ```
2. Navigate to the project directory:
   ```bash
   cd zoom_clone
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Configure Firebase in the `firebase_options.dart` file.

### Running the App
1. Connect a physical device or start an emulator.
2. Run the application:
   ```bash
   flutter run
   ```

---

## 🛠️ Technologies Used

- **Flutter**: Frontend framework.
- **Firebase**: Backend for authentication and Firestore database.
- **zego_uikit_prebuilt_video_conference**: Prebuilt package for video conferencing.

---

## 📸 Screenshots

| Welcome Page | Home page | Join Meeting Page |
|-----------------|-----------|-----------|
| ![Welcome Page](https://github.com/kamesh7773/zoom_clone/blob/main/readme%20assets/welcome_page.png?raw=true) | ![Home Page](https://github.com/kamesh7773/zoom_clone/blob/main/readme%20assets/home_page.png?raw=true) | ![Settings Page](https://github.com/kamesh7773/zoom_clone/blob/main/readme%20assets/settings_page.png?raw=true) |

| Sign up | Create Meeting Demo | Join Meeting Demo |
|-----------------|-----------|-----------|
| ![Sign Up Page](https://github.com/kamesh7773/zoom_clone/blob/main/readme%20assets/SignUp.gif?raw=true) | ![Create Meeting Demo](https://github.com/kamesh7773/zoom_clone/blob/main/readme%20assets/CreateMeeting.gif?raw=true) | ![Join Meeting Demo](https://github.com/kamesh7773/zoom_clone/blob/main/readme%20assets/JoinMeeting.gif?raw=true) |



---

## 📚 Usage

- **Create Meeting**:
  1. Log in with your preferred authentication method.
  2. Generate a meeting ID or use your personal meeting ID.
  3. Share the meeting ID or link with others.


- **Join Meeting**:
  1. Open the shared meeting link or enter the meeting ID manually.
  2. Start or join the session seamlessly.

---

## 🎉 Contributing

We welcome contributions to make this app even better! Follow these steps:
1. Fork the repository.
2. Create a new branch:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Added some feature"
   ```
4. Push the branch:
   ```bash
   git push origin feature-name
   ```
5. Create a pull request.

---

## 🤝 Acknowledgements

Special thanks to:
- The **Flutter** and **Firebase** communities for their amazing support.
- The **zego_uikit_prebuilt_video_conference** package for simplifying video conferencing integration.

---

## 📝 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## 🌐 Connect

For queries or collaboration, feel free to reach out:
- **Email**: [kameshsinghaaa64@gamil.com](mailto:your-kameshsinghaaa64@gamil.com)
- **GitHub**: [kamesh7773](https://github.com/kamesh7773)
