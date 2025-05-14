# EcoSense
EcoSense is a Flutter mobile application designed to provide users with comprehensive insights into their environment through connected sensors. It aims to be a customizable and intelligent platform for monitoring various environmental parameters, receiving alerts, and personalizing the user experience. 1 
# EcoSense - Smart Environment Monitoring Application

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Provider](https://img.shields.io/badge/Provider-%2361DAFB.svg?style=for-the-badge&logo=react&logoColor=black)](https://pub.dev/packages/provider)
[![MQTT](https://img.shields.io/badge/MQTT-gray.svg?style=for-the-badge&logo=eclipse-mosquitto&logoColor=white)](https://mqtt.org/)

## Overview

EcoSense is a Flutter mobile application designed to provide users with comprehensive insights into their environment through connected sensors. It aims to be a customizable and intelligent platform for monitoring various environmental parameters, receiving alerts, and personalizing the user experience.

This application is built to integrate with existing IoT infrastructures, such as the setup described where NodeMCU devices send data via MQTT to AWS IoT Core, with data stored in AWS DynamoDB. EcoSense will act as the user interface to visualize and interact with this data.

## Features

* **Real-time Sensor Data Display:** (Initial Goal) Displays current readings for temperature, humidity, and air quality (if available) from connected sensors.
* **Customizable Sensors:** Allows users to add and name their sensors within the application for a personalized experience.
* **Enhanced Dashboard:**
    * **Weekly Data Visualization:** Presents historical sensor data in an easily understandable weekly format, likely through interactive charts.
    * **Intelligent Weather Teller:** Interprets sensor data (temperature, humidity, etc.) to provide an intelligent assessment of the current weather conditions (e.g., Sunny, Cloudy, Rainy).
    * **Minute-by-Minute Conclusive Report:** Generates a brief summary of the environmental status based on the latest sensor readings every minute.
* **Interactive Sensor Data Graph:**
    * Displays detailed time-value graphs for each sensor.
    * Provides sensor-specific information including connectivity status and all available parameters.
    * Features an interactive graph with a hover effect to display precise values at specific times.
* **Alert Section with WhatsApp Notifications (Optional):**
    * Allows users to set custom thresholds for sensor parameters.
    * Triggers notifications via WhatsApp when these thresholds are crossed (requires optional user mobile number input).
* **Visual Design:**
    * **Background:** Features a visually appealing background image of a garden or smart eco-city with a parallax scrolling effect.
    * **Color Palette:** Utilizes a primary color scheme of antique white and creamy tones, with minimal use of green.
* **User Experience:**
    * **Dark Mode:** Switchable dark mode with a visually engaging sun/moon transition button.
    * **Multilingual Support:** Supports multiple languages (initially English, Hindi, Marathi).
    * **User Authentication:** Secure sign-up and login functionality with a personalized welcome message upon login.

## File Structure
lib/
├── main.dart             # Main application entry point
├── services/
│   ├── api_service.dart  # Handles communication with backend APIs
│   └── mqtt_service.dart # Handles communication using MQTT protocol
├── models/
│   ├── sensor_data.dart  # Defines the structure for sensor readings
│   ├── sensor_model.dart # Defines the structure for sensor information
│   └── alert_model.dart  # Defines the structure for alerts
├── providers/
│   ├── app_state.dart      # Manages global application state
│   ├── settings_provider.dart # Manages user settings (theme, locale)
│   ├── sensor_provider.dart   # Manages sensor data and interactions
│   ├── alert_provider.dart    # Manages alerts and notifications
│   ├── user_provider.dart     # Manages user authentication and data
│   ├── locale_provider.dart   # Manages application locale
│   └── theme_provider.dart    # Manages application theme
├── screens/
│   ├── dashboard_screen.dart   # Main dashboard displaying sensor data
│   ├── sensor_details_modal.dart # Modal for detailed sensor information and graphs
│   └── settings_screen.dart    # Screen for user configuration
└── theme/
└── ecosense_theme.dart   # Defines the application's color scheme and typography

## Technologies Used

* **Flutter:** Google's UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
* **Provider:** A simple to use yet powerful state management solution for Flutter.
* **flutter_localizations:** Provides internationalization (i18n) and localization (l10n) support for Flutter apps.
* **mqtt_client:** A Flutter client library for the MQTT messaging protocol.
* **http:** A powerful HTTP client for making web requests (likely used for API communication).
* **shared_preferences:** Provides persistent storage for simple data (like settings).

## Backend Integration (Conceptual)

The EcoSense Flutter app will interact with the backend infrastructure as follows:

1.  **Data Retrieval:** The app will likely use an API (e.g., built with AWS API Gateway and Lambda as suggested) to fetch sensor data from AWS DynamoDB. The `api_service.dart` will handle these API calls.
2.  **Real-time Updates:** For near real-time data, the app will connect to AWS IoT Core using MQTT over WebSockets via the `mqtt_service.dart`.
3.  **User Authentication:** The sign-up and login functionality will communicate with a backend service (potentially using Node.js or Python with MongoDB) via API calls to manage user accounts.
4.  **WhatsApp Notifications:** When alert thresholds are crossed, the backend API will need to integrate with a WhatsApp Business API provider (e.g., Twilio) to send notifications to the user's registered phone number.

## Getting Started (Conceptual - Backend Setup Required)

1.  **Set up your AWS IoT Core and DynamoDB:** Ensure your sensor data is correctly flowing into DynamoDB.
2.  **Deploy a Backend API:** Create an API (e.g., using AWS API Gateway and Lambda) to securely fetch data from DynamoDB.
3.  **Configure AWS Credentials:** Securely manage AWS credentials for your Flutter app to interact with AWS services (ideally using AWS Cognito for authentication).
4.  **Set up MQTT Broker:** Ensure your MQTT broker (AWS IoT Core) is configured correctly.
5.  **Integrate WhatsApp API (Optional):** If you want to implement WhatsApp notifications, set up an account with a WhatsApp Business API provider.
6.  **Set up MongoDB (for User Authentication):** Deploy a MongoDB database and create backend API endpoints for user registration and login.
7.  **Clone the Flutter Repository:** (Once the Flutter codebase is available)
    ```bash
    git clone <repository_url>
    cd ecosense
    ```
8.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```
9.  **Configure Endpoints:** Update the `api_service.dart` and potentially `mqtt_service.dart` with your AWS IoT Endpoint URL, API Gateway URL, and Cognito Identity Pool ID (likely fetched from user settings).
10. **Run the Application:**
    ```bash
    flutter run
    ```

## Contributing

Contributions to the EcoSense project are welcome. Please follow these steps:

1.  Fork the repository.
2.  Create a new branch for your feature or bug fix.
3.  Make your changes and commit them.
4.  Push your changes to your fork.
5.  Submit a pull request.

## License

[Specify your license here]

## Acknowledgements

* [Mention any libraries, services, or individuals you want to acknowledge]
