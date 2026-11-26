<%@ tag pageEncoding="UTF-8" %>
<%@ attribute name="exam" required="true" type="edu.sdust.model.Exam" %>
<%@ attribute name="teacher" type="java.lang.Boolean" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<article class="ex-item${exam.past() ? ' past' : ''}" data-id="${exam.id()}" data-sort="${exam.sortKey()}">
    <div class="ex-date" aria-hidden="true">
        <span class="ex-month">${exam.monthText(tx)}</span>
        <span class="ex-day">${exam.dayText()}</span>
        <span class="ex-weekday">${exam.weekdayText(tx)}</span>
    </div>
    <div class="ex-body">
        <div class="ex-top">
            <span class="ex-type ${exam.examType()}">${exam.typeText(tx)}</span>
            <span class="ex-when">${exam.whenText(tx)}</span>
        </div>
        <h3><c:out value="${exam.courseName()}"/> <span class="ex-code"><c:out value="${exam.courseCode()}"/></span></h3>
        <ul class="ex-meta">
            <li><svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/></svg><span>${exam.dateText(tx)}, ${exam.timeText()}</span></li>
            <li><svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 21s-7-6.2-7-11a7 7 0 0 1 14 0c0 4.8-7 11-7 11z"/><circle cx="12" cy="10" r="2.5"/></svg><span><c:out value="${exam.location()}"/></span></li>
            <li><svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg><span><c:choose><c:when test="${teacher}">${tx.format(exam.studentCount() == 1 ? 'js.exam.students.one' : 'js.exam.students.many', exam.studentCount())}</c:when><c:otherwise><c:out value="${exam.teacherName()}"/></c:otherwise></c:choose></span></li>
        </ul>
        <c:if test="${not empty exam.notes()}">
            <p class="ex-notes"><c:out value="${exam.notes()}"/></p>
        </c:if>
    </div>
    <c:if test="${teacher and not exam.past()}">
        <button type="button" class="ex-remove"><fmt:message key="js.exam.remove"/></button>
    </c:if>
</article>
