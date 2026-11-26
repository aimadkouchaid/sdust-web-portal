package edu.sdust.web;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.Map;

final class FormSupport {

    private FormSupport() {
    }

    static boolean tokenMatches(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        Object expected = session == null ? null : session.getAttribute(AuthFilter.SESSION_CSRF);
        String given = req.getParameter("csrf");
        return given != null && expected instanceof String
                && MessageDigest.isEqual(given.getBytes(StandardCharsets.UTF_8), ((String) expected).getBytes(StandardCharsets.UTF_8));
    }

    static String value(String s) {
        return s == null ? "" : s;
    }

    static void reply(HttpServletResponse resp, int status, String field, String message) throws IOException {
        reply(resp, status, field, message, Map.of());
    }

    static void reply(HttpServletResponse resp, int status, String field, String message, Map<String, String> data) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-store");
        StringBuilder json = new StringBuilder("{\"ok\":").append(status == 200)
                .append(",\"field\":").append(field == null ? "null" : quote(field))
                .append(",\"message\":").append(quote(message));
        for (Map.Entry<String, String> entry : data.entrySet()) {
            json.append(',').append(quote(entry.getKey())).append(':').append(quote(entry.getValue()));
        }
        resp.getWriter().write(json.append('}').toString());
    }

    private static String quote(String s) {
        StringBuilder out = new StringBuilder("\"");
        for (char c : s.toCharArray()) {
            switch (c) {
                case '"' -> out.append("\\\"");
                case '\\' -> out.append("\\\\");
                case '<' -> out.append("\\u003c");
                default -> {
                    if (c < 0x20) {
                        out.append(String.format("\\u%04x", (int) c));
                    } else {
                        out.append(c);
                    }
                }
            }
        }
        return out.append('"').toString();
    }
}
