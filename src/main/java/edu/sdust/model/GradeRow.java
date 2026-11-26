package edu.sdust.model;

import edu.sdust.i18n.Texts;

import java.math.BigDecimal;

public record GradeRow(String semester, String courseCode, String courseName, String college, BigDecimal credits,
                       Integer hours, String nature, String attribute, String assessment, String examNature,
                       BigDecimal score, String gradeLevel, BigDecimal gradePoint) {

    public boolean graded() {
        return score != null;
    }

    public boolean failed() {
        return graded() && gradePoint != null && gradePoint.signum() == 0;
    }

    public String scoreText(Texts tx) {
        if (!graded()) {
            return "—";
        }
        return gradeLevel != null ? tx.get("gr.level." + gradeLevel) : GradeSummary.number(score);
    }

    public String gradePointText() {
        return GradeSummary.point(gradePoint);
    }

    public String creditsText() {
        return GradeSummary.number(credits);
    }
}
