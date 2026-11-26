package edu.sdust.model;

import edu.sdust.i18n.Texts;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.Locale;

public record Exam(int id, int classId, String courseName, String courseCode, String semester, String teacherName,
                   String examType, LocalDate examDate, LocalTime startTime, LocalTime endTime, String location,
                   String notes, int studentCount) {

    private static final DateTimeFormatter TIME = DateTimeFormatter.ofPattern("HH:mm", Locale.ENGLISH);

    public String timeText() {
        return TIME.format(startTime) + "–" + TIME.format(endTime);
    }

    public String dayText() {
        return String.valueOf(examDate.getDayOfMonth());
    }

    public String sortKey() {
        return examDate + "T" + TIME.format(startTime);
    }

    public boolean past() {
        return LocalDateTime.of(examDate, endTime).isBefore(LocalDateTime.now());
    }

    public String summary(Texts tx) {
        return tx.format("ntf.exam.summary", courseName, typeText(tx).toLowerCase(tx.getLocale()), dateText(tx), timeText(), location);
    }

    public String typeText(Texts tx) {
        return tx.get("exam.type." + examType);
    }

    public String dateText(Texts tx) {
        return tx.weekdayDate(examDate);
    }

    public String monthText(Texts tx) {
        return tx.month(examDate);
    }

    public String weekdayText(Texts tx) {
        return tx.weekday(examDate);
    }

    public String whenText(Texts tx) {
        if (past()) {
            return tx.get("exam.when.finished");
        }
        long days = ChronoUnit.DAYS.between(LocalDate.now(), examDate);
        if (days <= 0) {
            return tx.get("exam.when.today");
        }
        return days == 1 ? tx.get("exam.when.tomorrow") : tx.format("exam.when.days", days);
    }
}
