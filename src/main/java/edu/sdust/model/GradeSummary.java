package edu.sdust.model;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

public record GradeSummary(int courses, BigDecimal credits, BigDecimal gpa) {

    public static GradeSummary of(List<GradeRow> rows) {
        BigDecimal weight = BigDecimal.ZERO;
        BigDecimal points = BigDecimal.ZERO;
        BigDecimal earned = BigDecimal.ZERO;
        int courses = 0;
        for (GradeRow row : rows) {
            if (!row.graded()) {
                continue;
            }
            courses++;
            weight = weight.add(row.credits());
            points = points.add(row.credits().multiply(row.gradePoint()));
            if (row.gradePoint().signum() > 0) {
                earned = earned.add(row.credits());
            }
        }
        if (weight.signum() == 0) {
            return new GradeSummary(0, BigDecimal.ZERO, BigDecimal.ZERO);
        }
        return new GradeSummary(courses, earned, points.divide(weight, 2, RoundingMode.HALF_UP));
    }

    public static String point(BigDecimal value) {
        return value == null ? "—" : value.setScale(1, RoundingMode.HALF_UP).toPlainString();
    }

    public static String number(BigDecimal value) {
        return value.signum() == 0 ? "0" : value.stripTrailingZeros().toPlainString();
    }

    public String creditsText() {
        return number(credits);
    }

    public String gpaText() {
        return gpa.setScale(2, RoundingMode.HALF_UP).toPlainString();
    }
}
