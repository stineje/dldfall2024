import smtplib

# Create an SMTP object and establish a connection to the SMTP server
smtpObj = smtplib.SMTP('smtp.example.com', 25)

# Identify yourself to an ESMTP server using EHLO
smtpObj.ehlo()

# Secure the SMTP connection
smtpObj.starttls()

# Login to the server (if required)
smtpObj.login('username', 'password')

# Send an email
from_address = 'your_email@example.com'
to_address = 'recipient@example.com'
message = """\
Subject: Test Email

This is a test email message.
"""

smtpObj.sendmail(from_address, to_address, message)

# Quit the SMTP session
smtpObj.quit()
