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
