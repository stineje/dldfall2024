import socket
import smtplib
from email.mime.text import MIMEText

# Configuration
HOST = '0.0.0.0'  # Listen on all interfaces
PORT = 1234       # Port to listen on
TO_PHONE_NUMBER = '1234567890'  # Replace with the recipient's phone number
CARRIER_GATEWAY = 'carrier_gateway.com'  # Replace with the carrier's email-to-text gateway

# Email configuration
SMTP_SERVER = 'smtp.your_email_provider.com'
SMTP_PORT = 587
SMTP_USER = 'your_email@example.com'
SMTP_PASSWORD = 'your_password'

def send_sms_via_email(body):
    msg = MIMEText(body)
    msg['From'] = SMTP_USER
    msg['To'] = f"{TO_PHONE_NUMBER}@{CARRIER_GATEWAY}"
    msg['Subject'] = "New Message"

    with smtplib.SMTP(SMTP_SERVER, SMTP_PORT) as server:
        server.starttls()
        server.login(SMTP_USER, SMTP_PASSWORD)
        server.sendmail(SMTP_USER, [f"{TO_PHONE_NUMBER}@{CARRIER_GATEWAY}"], msg.as_string())

def main():
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind((HOST, PORT))
        s.listen()
        print(f"Listening on port {PORT}...")

        conn, addr = s.accept()
        with conn:
            print(f"Connected by {addr}")
            while True:
                data = conn.recv(1024)
                if not data:
                    break
                message = data.decode('utf-8')
                print(f"Received message: {message}")
                send_sms_via_email(message)

if __name__ == "__main__":
    main()
