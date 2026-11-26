package edu.sdust.model;

import edu.sdust.i18n.Texts;

import java.math.BigDecimal;

public record GradeEntryRow(int enrollmentId, String studentId, String studentName, String className,
                            BigDecimal score, String gradeLevel, BigDecimal gradePoint) {

    public boolean graded() {
        return score != null;
    }

    public String scoreText(Texts tx) {
        if (!graded()) {
            return "";
        }
        return gradeLevel != null ? tx.get("gr.level." + gradeLevel) : GradeSummary.number(score);
    }

    public String gradePointText() {
        return GradeSummary.point(gradePoint);
    }
}
