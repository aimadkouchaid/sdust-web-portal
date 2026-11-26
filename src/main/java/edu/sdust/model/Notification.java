package edu.sdust.model;

import edu.sdust.i18n.Texts;

import java.time.LocalDate;
import java.time.LocalDateTime;

public record Notification(int id, String type, String title, String message, String titleZh, String messageZh,
                           String link, boolean read, LocalDateTime createdAt) {

    public String titleText(Texts tx) {
        return "zh".equals(tx.getLang()) && titleZh != null ? titleZh : title;
    }

    public String messageText(Texts tx) {
        return "zh".equals(tx.getLang()) && messageZh != null ? messageZh : message;
    }

    public String isoTime() {
        return createdAt.withNano(0).toString();
    }

    public String timeText(Texts tx) {
        LocalDate today = LocalDate.now();
        LocalDate day = createdAt.toLocalDate();
        String time = tx.time(createdAt.toLocalTime());
        if (day.equals(today)) {
            return tx.format("ntf.today", time);
        }
        if (day.equals(today.minusDays(1))) {
            return tx.format("ntf.yesterday", time);
        }
        return day.getYear() == today.getYear() ? tx.dayMonth(day) + " " + time : tx.date(day);
    }
}
