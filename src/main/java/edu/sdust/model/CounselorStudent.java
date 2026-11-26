package edu.sdust.model;

import edu.sdust.i18n.Texts;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;

public record CounselorStudent(String id, String name, String gender, String email, String phone, String major,
                               String className, Integer enrollmentYear, String campus, BigDecimal gpa,
                               BigDecimal credits, int pending, LocalDate onLeaveUntil) {

    public String gpaText() {
        return gpa == null ? "—" : gpa.setScale(2, RoundingMode.HALF_UP).toPlainString();
    }

    public String creditsText() {
        return credits == null ? "0" : credits.stripTrailingZeros().toPlainString();
    }

    public String onLeaveText(Texts tx) {
        return onLeaveUntil == null ? "" : tx.format("st.onleave", tx.date(onLeaveUntil));
    }
}
