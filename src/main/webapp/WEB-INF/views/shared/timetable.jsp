<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:message key="tt.notthisweek" var="offText"/>
<div class="tt-head">
    <h1 class="pgtitle"><fmt:message key="dash.nav.timetable"/></h1>
    <a href="${pageContext.request.contextPath}/dashboard/timetable/download" class="tt-download"><svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 4v11M7 10l5 5 5-5M5 20h14"/></svg><fmt:message key="tt.download"/></a>
</div>
<c:choose>
    <c:when test="${timetableError}">
        <p class="form-status error" role="status"><fmt:message key="tt.error"/></p>
    </c:when>
    <c:when test="${empty cells}">
        <p class="ex-empty"><fmt:message key="${sessionScope.user.role == 'teacher' ? 'tt.none.teacher' : 'tt.none.student'}"><fmt:param value="${timetable.semester()}"/></fmt:message></p>
    </c:when>
    <c:otherwise>
        <c:if test="${not empty timetable.startDate()}">
            <div class="tt-toolbar" data-semester-start="${timetable.startDate()}" data-weeks="${timetable.weeks()}">
                <div class="tt-weeknav">
                    <button type="button" class="tt-prev" aria-label="<fmt:message key="tt.prev"/>"><svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="m15 18-6-6 6-6"/></svg></button>
                    <div class="tt-weekinfo" aria-live="polite">
                        <strong class="tt-weeklabel"></strong>
                        <span class="tt-range"></span>
                    </div>
                    <button type="button" class="tt-next" aria-label="<fmt:message key="tt.next"/>"><svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="m9 18 6-6-6-6"/></svg></button>
                </div>
                <div class="tt-toolinfo">
                    <span class="tt-semester"><fmt:message key="tt.semester"><fmt:param value="${timetable.semester()}"/></fmt:message></span>
                    <span class="tt-count"></span>
                </div>
                <button type="button" class="tt-thisweek"><fmt:message key="tt.thisweek"/></button>
            </div>
        </c:if>
        <div class="tt-wrap">
            <div class="tt-grid">
                <div class="tt-corner"><fmt:message key="tt.time"/></div>
                <c:forEach var="d" begin="1" end="7">
                    <div class="tt-dayhead tt-day-${d}" data-day="${d}"><span class="tt-dayname"><fmt:message key="tt.day.${d}"/></span><span class="tt-date"></span></div>
                </c:forEach>
                <div class="tt-time tt-slot-1"><strong>08:00</strong><span>09:40</span><small><fmt:message key="tt.periods"><fmt:param value="1–2"/></fmt:message></small></div>
                <div class="tt-time tt-slot-2"><strong>10:10</strong><span>11:50</span><small><fmt:message key="tt.periods"><fmt:param value="3–4"/></fmt:message></small></div>
                <div class="tt-time tt-slot-3"><strong>14:00</strong><span>15:40</span><small><fmt:message key="tt.periods"><fmt:param value="5–6"/></fmt:message></small></div>
                <div class="tt-time tt-slot-4"><strong>16:00</strong><span>17:40</span><small><fmt:message key="tt.periods"><fmt:param value="7–8"/></fmt:message></small></div>
                <div class="tt-time tt-slot-5"><strong>19:00</strong><span>20:40</span><small><fmt:message key="tt.periods"><fmt:param value="9–10"/></fmt:message></small></div>
                <c:forEach var="sl" begin="1" end="5">
                    <c:forEach var="d" begin="1" end="7">
                        <div class="tt-cell tt-day-${d} tt-slot-${sl}"></div>
                    </c:forEach>
                </c:forEach>
                <c:forEach var="t" items="${cells}">
                    <div class="tt-session tt-c${t.color()} tt-day-${t.day()} tt-slot-${t.slot()}${t.span() > 1 ? ' tt-span-2' : ''}" data-start-week="${t.startWeek()}" data-end-week="${t.endWeek()}">
                        <span class="tt-code"><c:out value="${t.courseCode()}"/></span>
                        <span class="tt-course" lang="en"><c:out value="${t.courseName()}"/></span>
                        <span class="tt-meta"><svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 21s-7-6.2-7-11a7 7 0 0 1 14 0c0 4.8-7 11-7 11z"/><circle cx="12" cy="10" r="2.5"/></svg><c:out value="${t.location()}"/></span>
                        <c:choose>
                            <c:when test="${sessionScope.user.role == 'teacher'}">
                                <span class="tt-meta"><svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2M9 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8z"/></svg>${tx.format(t.students() == 1 ? 'js.exam.students.one' : 'js.exam.students.many', t.students())}</span>
                            </c:when>
                            <c:otherwise>
                                <span class="tt-meta"><svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 3a4 4 0 1 0 0 8 4 4 0 0 0 0-8zM5 21v-1a6 6 0 0 1 6-6h2a6 6 0 0 1 6 6v1"/></svg><c:out value="${t.teacherName()}"/></span>
                            </c:otherwise>
                        </c:choose>
                        <span class="tt-weeks" data-off="${offText}"><fmt:message key="${t.singleWeek() ? 'tt.week1' : 'tt.weeks'}"><fmt:param value="${t.weeks()}"/></fmt:message></span>
                    </div>
                </c:forEach>
            </div>
        </div>
        <p class="tt-empty" hidden><fmt:message key="tt.noclasses"/></p>
    </c:otherwise>
</c:choose>
