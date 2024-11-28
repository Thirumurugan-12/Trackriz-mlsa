
# TrackRiz
   
![Screenshot 2024-08-01 192459](https://github.com/user-attachments/assets/cf753252-1e3c-4811-93b7-93ad3c926355)
![Screenshot (1527)](https://github.com/user-attachments/assets/000948e7-305c-46ad-a26b-3781a2383b09)
![Screenshot (1528)](https://github.com/user-attachments/assets/df496798-585a-4b48-9449-7520b0dfa75d)
![Screenshot (1529)](https://github.com/user-attachments/assets/364420d9-e065-4127-ae47-b94ac843e4c2)
![Screenshot (1530)](https://github.com/user-attachments/assets/720f7fab-083b-405e-98e8-7d068cde4ce2)
![Screenshot (1532)](https://github.com/user-attachments/assets/7286051c-72cc-4640-952d-ca14fa811559)
![Screenshot (1527)](https://github.com/user-attachments/assets/13fa3a05-341c-4e43-bd6d-e9d9d3cbfcd8)


## Overview

This project integrates advanced AI technologies for financial document management, stock price prediction, and fraud detection. Utilizing Document AI, AutoML, and machine learning models, the system enhances security and efficiency in financial processes, including invoice management, KYC verification, stock market analysis, and transaction monitoring.

## Features

1. **Document Management & KYC Verification**
   - Automated document processing for efficient invoice management.
   - Secure KYC verification to enhance customer onboarding and regulatory compliance.

2. **Stock Price Prediction**
   - Predictive analytics using Yahoo Finance data.
   - Deployed AutoML model specifically trained on Bank of Baroda stock data for forecasting closing prices.

3. **Fraud Detection**
   - Real-time fraud detection using transaction data from a financial payout simulator.
   - Machine learning models to identify anomalies and potential fraudulent activities.

4. **Front-End Interface**
   - Developed using Flutter for a seamless, cross-platform user experience.
   - Interactive UI for accessing document management, stock predictions, and fraud alerts.

## Architecture

The system architecture consists of three primary components:

1. **Document Management System:**
   - *Document AI Module*: Processes invoices and KYC documents.
   - *Data Storage*: Securely stores processed documents.

2. **Stock Prediction System:**
   - *Data Source*: Yahoo Finance API.
   - *Data Processing*: Cleanses and prepares data.
   - *AutoML Model*: Predicts stock prices.
   - *Prediction Endpoint*: Provides real-time stock predictions.

3. **Fraud Detection System:**
   - *Transaction Data Source*: Financial payout simulator.
   - *Data Processing*: Prepares data for anomaly detection.
   - *Anomaly Detection Model*: Identifies unusual transactions.
   - *Fraud Detection Endpoint*: Alerts on potential fraud.

4. **Front-End Application:**
   - *Flutter Framework*: Powers the user interface for various platforms.
   - *User Interaction*: Allows users to view documents, stock predictions, and fraud alerts.

![Blank diagram (2)](https://github.com/user-attachments/assets/5e39b1f2-16a5-48bc-8287-f8b4207897d2)


## Getting Started

### Prerequisites
- Python 3.x
- Libraries: `tensorflow`, `pandas`, `numpy`, `scikit-learn`, etc.
- Access to Yahoo Finance API and financial payout simulator data
- Flutter SDK for front-end development

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your_username/financial-document-ai.git
   ```
2. Install the required libraries:
   ```bash
   pip install -r requirements.txt
   ```
3. Set up API keys and data sources:
   - Configure access to Yahoo Finance API.
   - Ensure data availability from the financial payout simulator.

### Running the Application
1. **Document Processing & KYC Verification:**
   - Run the Document AI module for document processing.

2. **Stock Price Prediction:**
   - Use the provided scripts to fetch and preprocess stock data.
   - Train and deploy the AutoML model for predictions.

3. **Fraud Detection:**
   - Process transaction data.
   - Deploy the anomaly detection model to monitor real-time transactions.

4. **Front-End Application:**
   - Navigate to the Flutter project directory.
   - Run `flutter pub get` to install dependencies.
   - Use `flutter run` to launch the application on your preferred device or emulator.

### Deployment
- The application can be deployed on cloud platforms like AWS, Azure, or Google Cloud.
- Use Docker or Kubernetes for containerization and orchestration.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by advancements in financial AI technologies.
- Special thanks to the open-source community for providing valuable resources and tools.

---
