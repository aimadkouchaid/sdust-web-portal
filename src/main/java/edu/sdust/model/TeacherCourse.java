package edu.sdust.model;

import edu.sdust.i18n.Texts;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public record TeacherCourse(int id, String courseName, String courseCode, String semester, boolean current,
                            BigDecimal credits, Integer hours, String nature, String assessment, int students,
                            int graded, BigDecimal avgScore, BigDecimal avgPoint, List<Meeting> meetings,
                            List<CourseExam> exams, List<GradeEntryRow> roster) {

    public record Meeting(int day, int startPeriod, int endPeriod, String location, String weeks, boolean singleWeek) {

        public String periodsText() {
            return startPeriod + "–" + endPeriod;
        }
    }

    public record CourseExam(String examType, LocalDate date, LocalTime start, LocalTime end, String location) {

        public String whenText(Texts tx) {
            return tx.weekdayDate(date) + ", " + tx.time(start) + "–" + tx.time(end);
        }

        public boolean past() {
            return date.isBefore(LocalDate.now());
        }
    }

    public String creditsText() {
        return GradeSummary.number(credits);
    }

    public String avgScoreText() {
        return avgScore == null ? "—" : avgScore.setScale(1, RoundingMode.HALF_UP).toPlainString();
    }

    public String avgPointText() {
        return avgPoint == null ? "—" : avgPoint.setScale(2, RoundingMode.HALF_UP).toPlainString();
    }
}
