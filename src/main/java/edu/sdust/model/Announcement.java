package edu.sdust.model;

import edu.sdust.i18n.Texts;

import java.time.LocalDateTime;
import java.util.Map;

public record Announcement(int id, String authorId, String authorName, String authorRole, String department, String category,
                           String title, String summary, String body, String audience, String classNames,
                           LocalDateTime publishedAt) {

    private static final Map<String, String> CATEGORIES = Map.of(
            "academic", "Academic",
            "exams", "Exams",
            "international", "International",
            "student", "Student affairs",
            "campus", "Campus");

    public static boolean isCategory(String value) {
        return value != null && CATEGORIES.containsKey(value);
    }

    public String fromText() {
        return authorName == null || authorName.isEmpty() ? department : authorName + ", " + department;
    }

    public String isoDate() {
        return publishedAt.toLocalDate().toString();
    }

    public String categoryText(Texts tx) {
        return tx.get("an.cat." + category);
    }

    public String audienceText(Texts tx) {
        if (classNames != null && !classNames.isEmpty()) {
            return tx.format("an.to.classes", classNames);
        }
        if ("student".equals(audience) && "counselor".equals(authorRole)) {
            return tx.get("an.to.mystudents");
        }
        return tx.get("an.to." + audience);
    }

    public String dateText(Texts tx) {
        return tx.date(publishedAt);
    }
}
