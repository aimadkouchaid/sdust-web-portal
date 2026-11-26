package edu.sdust.model;

import edu.sdust.i18n.Texts;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

public record LeaveRequest(int id, String requestNo, String studentId, String studentName, String className,
                           String leaveType, LocalDate startDate, LocalDate endDate, String destination,
                           String contactNumber, String reason, String attachmentName, String status,
                           LocalDateTime submittedAt, String reviewerName, String reviewComment,
                           LocalDateTime reviewedAt) {

    public String submittedIso() {
        return submittedAt.toLocalDate().toString();
    }

    public String typeText(Texts tx) {
        return tx.get("leave.type." + leaveType);
    }

    public String statusText(Texts tx) {
        return tx.get("leave.status." + status);
    }

    public String durationText(Texts tx) {
        return tx.format("leave.days", ChronoUnit.DAYS.between(startDate, endDate) + 1);
    }

    public String dateRangeText(Texts tx) {
        return tx.dateRange(startDate, endDate);
    }

    public String startText(Texts tx) {
        return tx.date(startDate);
    }

    public String endText(Texts tx) {
        return tx.date(endDate);
    }

    public String submittedText(Texts tx) {
        return tx.date(submittedAt);
    }

    public String reviewedText(Texts tx) {
        return tx.date(reviewedAt);
    }
}
