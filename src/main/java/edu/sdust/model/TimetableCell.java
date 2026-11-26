package edu.sdust.model;

public record TimetableCell(int day, int slot, int span, int color, String courseCode, String courseName,
                            String location, int students, String teacherName, int startWeek, int endWeek, String weeks,
                            boolean singleWeek) {
}
