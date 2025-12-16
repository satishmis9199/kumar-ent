package com.kumarent.util;

import java.io.File;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.util.ByteArrayDataSource;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;

import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

public class EmailUtil {

    // ===============================
    // ✅ BREVO SMTP CONFIG
    // ===============================
    private static final String SMTP_HOST = "smtp-relay.brevo.com";
    private static final String SMTP_PORT = "587";
    private static final String SMTP_USER = "9e325b001@smtp-brevo.com";
    private static final String SMTP_PASS = "xsmtpsib-9adbcfe2b311a0a6e73ab5448a4f3dc07ae653b7b7c749cb65700df05d01cd0f-04bY6YUqLtoQwT2P";
    private static final String FROM_EMAIL = "satishmis9199@gmail.com";

    // =================================================
    // 1️⃣ SIMPLE EMAIL
    // =================================================
    public static void sendEmail(String toEmail, String subject, String body)
            throws Exception {

        Session session = createSession();

        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(FROM_EMAIL, "Kumar Enterprises"));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        msg.setSubject(subject);
        msg.setText(body);

        Transport.send(msg);
    }

    // =================================================
    // 2️⃣ EMAIL WITH FILE ATTACHMENT
    // =================================================
    public static void sendEmailWithAttachment(
            String toEmail,
            String subject,
            String body,
            String attachmentPath) throws Exception {

        Session session = createSession();

        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(FROM_EMAIL, "Kumar Enterprises"));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        msg.setSubject(subject);

        MimeBodyPart textPart = new MimeBodyPart();
        textPart.setText(body);

        MimeBodyPart attachmentPart = new MimeBodyPart();
        File file = new File(attachmentPath);
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
    // 3️⃣ EMAIL WITH PDF BYTE[]
    // =================================================
    public static void sendEmailWithPdfBytes(
            String toEmail,
            String subject,
            String body,
            byte[] pdfData,
            String fileName) throws Exception {

        Session session = createSession();

        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(FROM_EMAIL, "Kumar Enterprises"));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        msg.setSubject(subject);

        MimeBodyPart textPart = new MimeBodyPart();
        textPart.setText(body);

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
    // 🔧 SMTP SESSION
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
