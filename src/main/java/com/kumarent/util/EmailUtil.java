package com.kumarent.util;

import java.util.Base64;

import org.apache.hc.client5.http.classic.methods.HttpPost;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.ContentType;
import org.apache.hc.core5.http.io.entity.StringEntity;

public class EmailUtil {

    private static final String API_URL =
            "https://api.brevo.com/v3/smtp/email";

    private static final String API_KEY =
            "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";

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

        String json = String.format(
                "{"
              + "\"sender\":{"
              +     "\"name\":\"%s\","
              +     "\"email\":\"%s\""
              + "},"
              + "\"to\":[{"
              +     "\"email\":\"%s\""
              + "}],"
              + "\"subject\":\"%s\","
              + "\"htmlContent\":\"%s\""
              + "}",
                FROM_NAME,
                FROM_EMAIL,
                toEmail,
                subject,
                body
        );

        send(json);
    }

    // ===============================
    // EMAIL WITH PDF
    // ===============================
    public static void sendEmailWithPdfBytes(
            String toEmail,
            String subject,
            String body,
            byte[] pdfData,
            String fileName) throws Exception {

        String pdfBase64 = Base64.getEncoder()
                .encodeToString(pdfData);

        String json = String.format(
                "{"
              + "\"sender\":{"
              +     "\"name\":\"%s\","
              +     "\"email\":\"%s\""
              + "},"
              + "\"to\":[{"
              +     "\"email\":\"%s\""
              + "}],"
              + "\"subject\":\"%s\","
              + "\"htmlContent\":\"%s\","
              + "\"attachment\":[{"
              +     "\"content\":\"%s\","
              +     "\"name\":\"%s\""
              + "}]"
              + "}",
                FROM_NAME,
                FROM_EMAIL,
                toEmail,
                subject,
                body,
                pdfBase64,
                fileName
        );

        send(json);
    }

    // ===============================
    // HTTP CALL
    // ===============================
    private static void send(String json) throws Exception {

        HttpPost post = new HttpPost(API_URL);
        post.setHeader("api-key", API_KEY);
        post.setHeader("Content-Type", "application/json");
        post.setEntity(new StringEntity(json, ContentType.APPLICATION_JSON));

        try (CloseableHttpClient client = HttpClients.createDefault()) {
            client.execute(post);
        }
    }
}

