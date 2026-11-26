<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<h1 class="pgtitle"><fmt:message key="dash.nav.courses"/></h1>
<c:choose>
    <c:when test="${coursesError}">
        <p class="form-status error" role="status"><fmt:message key="co.error"/></p>
    </c:when>
    <c:when test="${empty courses}">
        <p class="ge-empty"><fmt:message key="co.none"/></p>
    </c:when>
    <c:otherwise>
        <div class="st-stats">
            <div class="st-stat"><strong>${currentClasses}</strong><span><fmt:message key="co.stat.classes"/></span></div>
            <div class="st-stat"><strong>${currentStudents}</strong><span><fmt:message key="co.stat.students"/></span></div>
            <a class="st-stat" href="${pageContext.request.contextPath}/dashboard/teacher/grades"><strong>${ungraded}</strong><span><fmt:message key="co.stat.ungraded"/></span></a>
        </div>
        <c:set var="lastSemester" value=""/>
        <c:forEach var="k" items="${courses}">
            <c:if test="${k.semester() != lastSemester}">
                <h2 class="ex-heading">${k.semester()}<c:if test="${k.current()}"> <span class="ex-count"><fmt:message key="co.current"/></span></c:if></h2>
                <c:set var="lastSemester" value="${k.semester()}"/>
            </c:if>
            <article class="co-card${k.current() ? '' : ' past'}">
                <div class="co-head">
                    <div class="co-title">
                        <span class="co-code"><c:out value="${k.courseCode()}"/></span>
                        <h3><c:out value="${k.courseName()}"/></h3>
                    </div>
                    <div class="co-links">
                        <a class="co-link" href="${pageContext.request.contextPath}/dashboard/teacher/grades?class=${k.id()}"><fmt:message key="dash.nav.gradeentry"/></a>
                        <c:if test="${k.current()}">
                            <a class="co-link" href="${pageContext.request.contextPath}/dashboard/teacher/exams"><fmt:message key="dash.nav.exams"/></a>
                        </c:if>
                    </div>
                </div>
                <dl class="gr-meta">
                    <div><dt><fmt:message key="gr.credit"/></dt><dd>${k.creditsText()}</dd></div>
                    <div><dt><fmt:message key="gr.hours"/></dt><dd>${empty k.hours() ? '—' : k.hours()}</dd></div>
                    <div><dt><fmt:message key="gr.type"/></dt><dd><c:choose><c:when test="${empty k.nature()}">—</c:when><c:otherwise><fmt:message key="gr.nature.${k.nature()}"/></c:otherwise></c:choose></dd></div>
                    <div><dt><fmt:message key="gr.assessment"/></dt><dd><fmt:message key="gr.assessment.${k.assessment()}"/></dd></div>
                    <div><dt><fmt:message key="co.students"/></dt><dd>${k.students()}</dd></div>
                    <div><dt><fmt:message key="ge.graded"/></dt><dd>${k.graded()} / ${k.students()}</dd></div>
                    <div><dt><fmt:message key="ge.avgscore"/></dt><dd>${k.avgScoreText()}</dd></div>
                    <div><dt><fmt:message key="ge.avgpoint"/></dt><dd><strong>${k.avgPointText()}</strong></dd></div>
                </dl>
                <div class="co-columns">
                    <div>
                        <h4><fmt:message key="co.schedule"/></h4>
                        <c:choose>
                            <c:when test="${empty k.meetings()}"><p class="co-muted"><fmt:message key="co.noschedule"/></p></c:when>
                            <c:otherwise>
                                <ul class="co-list">
                                    <c:forEach var="m" items="${k.meetings()}">
                                        <li><strong><fmt:message key="tt.day.${m.day()}"/></strong> · <fmt:message key="tt.periods"><fmt:param value="${m.periodsText()}"/></fmt:message> · <c:out value="${m.location()}"/> · <fmt:message key="${m.singleWeek() ? 'tt.week1' : 'tt.weeks'}"><fmt:param value="${m.weeks()}"/></fmt:message></li>
                                    </c:forEach>
                                </ul>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div>
                        <h4><fmt:message key="dash.nav.exams"/></h4>
                        <c:choose>
                            <c:when test="${empty k.exams()}"><p class="co-muted"><fmt:message key="co.noexams"/></p></c:when>
                            <c:otherwise>
                                <ul class="co-list">
                                    <c:forEach var="x" items="${k.exams()}">
                                        <li class="${x.past() ? 'co-past' : ''}"><strong><fmt:message key="exam.type.${x.examType()}"/></strong> · ${x.whenText(tx)} · <c:out value="${x.location()}"/></li>
                                    </c:forEach>
                                </ul>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <details class="co-roster">
                    <summary><fmt:message key="co.roster"><fmt:param value="${k.students()}"/></fmt:message></summary>
                    <c:choose>
                        <c:when test="${empty k.roster()}"><p class="co-muted"><fmt:message key="ge.nostudents"/></p></c:when>
                        <c:otherwise>
                            <div class="lr-tablewrap">
                                <table class="ge-table">
                                    <thead>
                                        <tr>
                                            <th><fmt:message key="st.th.student"/></th>
                                            <th><fmt:message key="st.th.class"/></th>
                                            <th><fmt:message key="gr.score"/></th>
                                            <th class="ge-num"><fmt:message key="gr.point"/></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="r" items="${k.roster()}">
                                            <tr>
                                                <td><span class="st-name"><c:out value="${r.studentName()}"/></span><span class="st-sub"><c:out value="${r.studentId()}"/></span></td>
                                                <td data-label="<fmt:message key='st.th.class'/>"><c:out value="${r.className()}"/></td>
                                                <td data-label="<fmt:message key='gr.score'/>"><c:choose><c:when test="${r.graded()}">${r.scoreText(tx)}</c:when><c:otherwise><span class="ge-badge"><fmt:message key="ge.status.waiting"/></span></c:otherwise></c:choose></td>
                                                <td class="ge-num" data-label="<fmt:message key='gr.point'/>">${r.gradePointText()}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </details>
            </article>
        </c:forEach>
    </c:otherwise>
</c:choose>
