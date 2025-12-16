package com.kumarent.util;

import java.io.File;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.util.ByteArrayDataSource;


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

    // ⚠️ DEV ONLY – use env vars in production
    private static final String SMTP_USER = "satishmis9199@gmail.com";
    private static final String SMTP_PASS = "ebol eekr tynz bypg"; // Gmail App Password

    // =================================================
    // 1️⃣ SIMPLE EMAIL (TEXT ONLY)
    // =================================================
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

    // =================================================
    // 2️⃣ EMAIL WITH FILE PATH ATTACHMENT
    // (When PDF is already saved on server)
    // =================================================
    public static void sendEmailWithAttachment(
            String toEmail,
            String subject,
            String body,
            String attachmentAbsolutePath) throws Exception {

        Session session = createSession();

        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(SMTP_USER));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        msg.setSubject(subject);

        // Mail body
        MimeBodyPart textPart = new MimeBodyPart();
        textPart.setText(body);

        // Attachment
        MimeBodyPart attachmentPart = new MimeBodyPart();
        File file = new File(attachmentAbsolutePath);
        DataSource source = new FileDataSource(file);
        attachmentPart.setDataHandler(new DataHandler(source));
        attachmentPart.setFileName(file.getName());

        Multipart multipart = new MimeMultipart();
        multipart.addBodyPart(textPart);
        multipart.addBodyPart(attachmentPart);

        msg.setContent(multipart);

        Transport.send(msg);
    }

    // =================================================
    // 3️⃣ EMAIL WITH PDF BYTE[] ATTACHMENT (BEST)
    // (Recommended for Invoice PDF)
    // =================================================
    public static void sendEmailWithPdfBytes(
            String toEmail,
            String subject,
            String body,
            byte[] pdfData,
            String fileName) throws Exception {

        Session session = createSession();

        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(SMTP_USER));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        msg.setSubject(subject);

        // Mail body
        MimeBodyPart textPart = new MimeBodyPart();
        textPart.setText(body);

        // PDF attachment from memory
        MimeBodyPart pdfPart = new MimeBodyPart();
        DataSource source = new ByteArrayDataSource(pdfData, "application/pdf");
        pdfPart.setDataHandler(new DataHandler(source));
        pdfPart.setFileName(fileName);

        Multipart multipart = new MimeMultipart();
        multipart.addBodyPart(textPart);
        multipart.addBodyPart(pdfPart);

        msg.setContent(multipart);

        Transport.send(msg);
    }

    // =================================================
    // COMMON SESSION CREATOR
    // =================================================
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
