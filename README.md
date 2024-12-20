
# TrackRiz

Pitch Desk
https://stdntpartners-my.sharepoint.com/:p:/g/personal/kalyanasundaram_v_studentambassadors_com/ERjnO3LZobZPl6YOnH-8AT8BpAPZTbRRuuPbGK3BdBrQkQ?e=BcJZWm

![Screenshot 2024-11-30 165749](https://github.com/user-attachments/assets/d2dca6e8-bffa-48e4-918b-9ef74b0e0d98)

![Screenshot (1527)](https://github.com/Thirumurugan-12/Trackriz-mlsa/blob/main/assets/Screenshot%20(1527).png)
![Screenshot (1528)](https://github.com/Thirumurugan-12/Trackriz-mlsa/blob/main/assets/Screenshot%20(1528).png)
![Screenshot (1529)](https://github.com/Thirumurugan-12/Trackriz-mlsa/blob/main/assets/Screenshot%20(1529).png)



## Overview

This project integrates advanced AI technologies for financial document management, stock price prediction, and fraud detection. Utilizing Document AI, AutoML, and machine learning models, the system enhances security and efficiency in financial processes, including invoice management, KYC verification, stock market analysis, and transaction monitoring.

## Features

1. **Document Management & KYC Verification**
   - Automated document processing for efficient invoice management.
   - Secure KYC verification to enhance customer onboarding and regulatory compliance.

2. **Stock Price Prediction**
   - Predictive analytics using Yahoo Finance data.
   - Deployed AutoML model specifically trained on Microsoft stock data for forecasting closing prices.

3. **Front-End Interface**
   - Developed using Flutter for a seamless, cross-platform user experience.
   - Interactive UI for accessing document management, stock predictions, and fraud alerts.

## Architecture

The system architecture consists of three primary components:

1. **Document Management System:**
   - *Document AI Module*: Processes  invoices and KYC documents.
   - *Data Storage*: Securely stores processed documents.

2. **Stock Prediction System:**
   - *Data Source*: Yahoo Finance API.
   - *Data Processing*: Cleanses and prepares data.
   - *AutoML Model*: Predicts stock prices.
   - *Prediction Endpoint*: Provides real-time stock predictions.

3. **Front-End Application:**
   - *Flutter Framework*: Powers the user interface for various platforms.
   - *User Interaction*: Allows users to view documents, stock predictions, and fraud alerts.




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
