package edu.sdust.model;

import java.math.BigDecimal;
import java.math.RoundingMode;

public record GradeClass(int id, String courseName, String courseCode, String semester, String assessment,
                         int students, int ungraded, BigDecimal avgScore, BigDecimal avgPoint) {

    public int graded() {
        return students - ungraded;
    }

    public String avgScoreText() {
        return avgScore == null ? "—" : avgScore.setScale(1, RoundingMode.HALF_UP).toPlainString();
    }

    public String avgPointText() {
        return avgPoint == null ? "—" : avgPoint.setScale(2, RoundingMode.HALF_UP).toPlainString();
    }
}
