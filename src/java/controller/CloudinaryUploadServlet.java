package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import controller.DbUtil;

@WebServlet("/upload-cloudinary")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 10 * 1024 * 1024,
        maxRequestSize = 20 * 1024 * 1024
)
public class CloudinaryUploadServlet extends HttpServlet {

    private String cloudName() {
        String v = System.getenv("CLOUDINARY_NAME");
        if (v != null && !v.isEmpty()) return v;
        v = System.getenv("CLOUDINARY_CLOUD_NAME");
        return v != null ? v : "";
    }

    private String apiKey() { return System.getenv("CLOUDINARY_API_KEY"); }
    private String apiSecret() { return System.getenv("CLOUDINARY_API_SECRET"); }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String key = apiKey();
        String secret = apiSecret();
        String cloud = cloudName();
        if (key == null || secret == null || cloud == null || cloud.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"error\":\"Cloudinary API credentials not configured on server.\"}");
            return;
        }

        Part filePart = null;
        try {
            filePart = request.getPart("file");
        } catch (Exception e) {
            // ignore
        }
        if (filePart == null || filePart.getSize() == 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"error\":\"No file provided\"}");
            return;
        }

        String folder = request.getParameter("folder");
        if (folder == null || folder.isEmpty()) folder = System.getenv("CLOUDINARY_UPLOAD_FOLDER");

        long ts = System.currentTimeMillis() / 1000L;
        String timestamp = Long.toString(ts);

        // Build signature string. Only include folder if present.
        StringBuilder sigBase = new StringBuilder();
        if (folder != null && !folder.isEmpty()) {
            sigBase.append("folder=").append(folder).append("&");
        }
        sigBase.append("timestamp=").append(timestamp);
        String signature = sha1Hex(sigBase.toString() + secret);

        String boundary = "----CloudinaryBoundary" + System.currentTimeMillis();
        URL url = new URL("https://api.cloudinary.com/v1_1/" + cloud + "/image/upload");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setDoOutput(true);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);

        try (OutputStream out = conn.getOutputStream()) {
            writeFormField(out, boundary, "api_key", key);
            writeFormField(out, boundary, "timestamp", timestamp);
            writeFormField(out, boundary, "signature", signature);
            if (folder != null && !folder.isEmpty()) writeFormField(out, boundary, "folder", folder);

            // file
            writeFileField(out, boundary, "file", filePart.getSubmittedFileName(), filePart.getContentType(), filePart.getInputStream());

            // end
            out.write(("--" + boundary + "--\r\n").getBytes(StandardCharsets.UTF_8));
            out.flush();
        }

        int rc = conn.getResponseCode();
        InputStream respStream = rc >= 200 && rc < 300 ? conn.getInputStream() : conn.getErrorStream();
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        byte[] buf = new byte[8192];
        int r;
        while ((r = respStream.read(buf)) != -1) baos.write(buf, 0, r);
        String respBody = new String(baos.toByteArray(), StandardCharsets.UTF_8);
        // Basic validation: ensure asset_folder matches expected upload folder (if configured)
        String expectedFolder = System.getenv("CLOUDINARY_UPLOAD_FOLDER");
        String assetFolder = extractJsonField(respBody, "asset_folder");
        if (expectedFolder != null && !expectedFolder.isEmpty()) {
            if (assetFolder == null || !assetFolder.equals(expectedFolder)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"error\":\"Uploaded file not stored in expected Cloudinary folder.\"}");
                return;
            }
        }

        // Optionally save returned secure_url to the cakes table if save_cake_id param provided
        String secureUrl = extractJsonField(respBody, "secure_url");
        String saveCakeIdStr = request.getParameter("save_cake_id");
        if (saveCakeIdStr != null && secureUrl != null && !secureUrl.isEmpty()) {
            try {
                int cakeId = Integer.parseInt(saveCakeIdStr);
                try (Connection c = DbUtil.getConnection();
                     PreparedStatement ps = c.prepareStatement("UPDATE cakes SET image_file = ? WHERE id = ?")) {
                    ps.setString(1, secureUrl);
                    ps.setInt(2, cakeId);
                    ps.executeUpdate();
                }
            } catch (Exception e) {
                // don't fail the upload if DB update fails; log and continue
                e.printStackTrace();
            }
        }

        response.setStatus(rc);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(respBody);
    }

    private static String extractJsonField(String json, String field) {
        if (json == null || field == null) return null;
        String quoted = "\"" + field + "\"\s*:\s*";
        int idx = json.indexOf('"' + field + '"');
        if (idx < 0) return null;
        int colon = json.indexOf(':', idx);
        if (colon < 0) return null;
        int valStart = colon + 1;
        // skip spaces
        while (valStart < json.length() && Character.isWhitespace(json.charAt(valStart))) valStart++;
        if (valStart >= json.length()) return null;
        char c = json.charAt(valStart);
        if (c == '"') {
            int end = valStart + 1;
            StringBuilder sb = new StringBuilder();
            while (end < json.length()) {
                char ch = json.charAt(end);
                if (ch == '\\') {
                    if (end + 1 < json.length()) {
                        sb.append(json.charAt(end + 1));
                        end += 2;
                        continue;
                    } else break;
                }
                if (ch == '"') break;
                sb.append(ch);
                end++;
            }
            return sb.toString();
        } else {
            // non-string value
            int end = valStart;
            while (end < json.length() && json.charAt(end) != ',' && json.charAt(end) != '}' && !Character.isWhitespace(json.charAt(end))) end++;
            return json.substring(valStart, end).replaceAll("[\"\\s]", "");
        }
    }

    private static void writeFormField(OutputStream out, String boundary, String name, String value) throws IOException {
        String part = "--" + boundary + "\r\n" +
                "Content-Disposition: form-data; name=\"" + name + "\"\r\n\r\n" +
                value + "\r\n";
        out.write(part.getBytes(StandardCharsets.UTF_8));
    }

    private static void writeFileField(OutputStream out, String boundary, String fieldName, String filename, String contentType, InputStream data) throws IOException {
        String header = "--" + boundary + "\r\n" +
                "Content-Disposition: form-data; name=\"" + fieldName + "\"; filename=\"" + filename + "\"\r\n" +
                "Content-Type: " + (contentType != null ? contentType : "application/octet-stream") + "\r\n\r\n";
        out.write(header.getBytes(StandardCharsets.UTF_8));
        byte[] buf = new byte[8192];
        int r;
        while ((r = data.read(buf)) != -1) out.write(buf, 0, r);
        out.write("\r\n".getBytes(StandardCharsets.UTF_8));
    }

    private static String sha1Hex(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-1");
            byte[] digest = md.digest(input.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : digest) sb.append(String.format("%02x", b & 0xff));
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
