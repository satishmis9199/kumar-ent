package com.kumarent.util;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

public class EmailUtil {

    private static final String API_URL =
            "https://api.brevo.com/v3/smtp/email";

    // 🔐 Read from Railway → Variables
    private static final String API_KEY =
        System.getenv("BREVO_API_KEY");


    private static final String FROM_EMAIL =
            "satishmis9199@gmail.com";

    private static final String FROM_NAME =
            "Kumar Enterprises";

    // ===============================
    // SIMPLE EMAIL
    // ===============================
    public static void sendEmail(
            String toEmail,
            String subject,
            String body) throws Exception {

        String json =
                "{"
              + "\"sender\":{"
              +     "\"name\":\"" + FROM_NAME + "\","
              +     "\"email\":\"" + FROM_EMAIL + "\""
              + "},"
              + "\"to\":[{"
              +     "\"email\":\"" + toEmail + "\""
              + "}],"
              + "\"subject\":\"" + escape(subject) + "\","
              + "\"htmlContent\":\"" + escape(body) + "\""
              + "}";

        send(json);
    }

    // ===============================
    // EMAIL WITH PDF ATTACHMENT
    // ===============================
    public static void sendEmailWithPdfBytes(
            String toEmail,
            String subject,
            String body,
            byte[] pdfData,
            String fileName) throws Exception {

        String pdfBase64 = Base64.getEncoder()
                .encodeToString(pdfData);

        String json =
                "{"
              + "\"sender\":{"
              +     "\"name\":\"" + FROM_NAME + "\","
              +     "\"email\":\"" + FROM_EMAIL + "\""
              + "},"
              + "\"to\":[{"
              +     "\"email\":\"" + toEmail + "\""
              + "}],"
              + "\"subject\":\"" + escape(subject) + "\","
              + "\"htmlContent\":\"" + escape(body) + "\","
              + "\"attachment\":[{"
              +     "\"content\":\"" + pdfBase64 + "\","
              +     "\"name\":\"" + fileName + "\""
              + "}]"
              + "}";

        send(json);
    }

    // ===============================
    // HTTP CALL USING CORE JAVA
    // ===============================
    private static void send(String json) throws Exception {

        if (API_KEY == null || API_KEY.isEmpty()) {
            throw new IllegalStateException("BREVO_API_KEY not set");
        }

        URL url = new URL(API_URL);
        HttpURLConnection conn =
                (HttpURLConnection) url.openConnection();

        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setRequestProperty("api-key", API_KEY);
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("Accept", "application/json");

        byte[] input =
                json.getBytes(StandardCharsets.UTF_8);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(input);
        }

        int responseCode = conn.getResponseCode();

        if (responseCode != 201 && responseCode != 200) {
            throw new RuntimeException(
                    "Email failed. HTTP Code: " + responseCode);
        }

        conn.disconnect();
    }

    // ===============================
    // JSON SAFE ESCAPE
    // ===============================
    private static String escape(String text) {
        return text == null ? "" : text
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "<br/>");
    }
}
