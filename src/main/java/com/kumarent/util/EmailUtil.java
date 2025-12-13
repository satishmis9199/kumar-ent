package com.kumarent.util;

import java.io.File;
import java.util.Properties;

import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;

import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;


public class EmailUtil {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";

    // DEV ONLY (OK for now)
    private static final String SMTP_USER = "satishmis9199@gmail.com";
    private static final String SMTP_PASS = "ebol eekr tynz bypg"; // Gmail App Password

    // ===============================
    // 1️⃣ SIMPLE EMAIL (already used)
    // ===============================
    public static void sendEmail(String toEmail, String subject, String body)
            throws MessagingException {

        Session session = createSession();

        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(SMTP_USER));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        msg.setSubject(subject);
        msg.setText(body);

        Transport.send(msg);
    }

    // =========================================
    // 2️⃣ EMAIL WITH ATTACHMENT (INVOICE PDF)
    // =========================================
    public static void sendEmailWithAttachment(
            String toEmail,
            String subject,
            String body,
            String attachmentRelativePath,
            String appRootPath) throws Exception {

        Session session = createSession();

        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(SMTP_USER));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        msg.setSubject(subject);

        // Text body
        MimeBodyPart textPart = new MimeBodyPart();
        textPart.setText(body);

        // Attachment
        MimeBodyPart filePart = new MimeBodyPart();
        File file = new File(appRootPath + attachmentRelativePath);
        filePart.attachFile(file);

        Multipart multipart = new MimeMultipart();
        multipart.addBodyPart(textPart);
        multipart.addBodyPart(filePart);

        msg.setContent(multipart);

        Transport.send(msg);
    }

    // ===============================
    // COMMON SESSION CREATOR
    // ===============================
    private static Session createSession() {

        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        return Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USER, SMTP_PASS);
            }
        });
    }
}
