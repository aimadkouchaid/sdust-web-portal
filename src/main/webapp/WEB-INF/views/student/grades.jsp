<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<h1 class="pgtitle"><fmt:message key="dash.nav.grades"/></h1>
<c:choose>
    <c:when test="${gradesError}">
        <p class="form-status error" role="status"><fmt:message key="gr.error"/></p>
    </c:when>
    <c:otherwise>
        <section class="gr-card">
            <h2 class="gr-cardtitle"><fmt:message key="gr.check"/></h2>
            <form method="get" action="${pageContext.request.contextPath}/dashboard/grades" class="gr-pick">
                <label for="grsemester"><fmt:message key="gr.pick"/></label>
                <select name="semester" id="grsemester">
                    <c:forEach var="s" items="${semesters}">
                        <option value="${s}"${s == semester ? ' selected' : ''}>${s}</option>
                    </c:forEach>
                </select>
                <noscript><button type="submit" class="gr-go"><fmt:message key="gr.show"/></button></noscript>
            </form>
            <p class="gr-overall"><fmt:message key="gr.overall"><fmt:param value="${overall.gpaText()}"/><fmt:param value="${overall.creditsText()}"/></fmt:message></p>
        </section>

        <c:if test="${not empty semester}">
            <section class="gr-card">
                <h2 class="gr-cardtitle">${semester}</h2>
                <ul class="gr-stats">
                    <li><span class="gr-dot c1"></span><fmt:message key="gr.credits"/>: <strong>${summary.creditsText()}</strong></li>
                    <li><span class="gr-dot c2"></span><fmt:message key="gr.gpa"/>: <strong>${summary.gpaText()}</strong></li>
                </ul>
            </section>
        </c:if>

        <c:choose>
            <c:when test="${empty grades}">
                <article class="gr-course gr-none">
                    <h3><span class="gr-dot c4"></span><fmt:message key="gr.none"><fmt:param value="${semester}"/></fmt:message></h3>
                </article>
            </c:when>
            <c:otherwise>
                <div class="gr-list">
                    <c:forEach var="g" items="${grades}">
                        <article class="gr-course${g.failed() ? ' failed' : ''}">
                            <div class="gr-coursehead">
                                <h3><span class="gr-dot c4"></span><c:out value="${g.courseName()}"/></h3>
                                <span class="gr-score">${g.scoreText(tx)}</span>
                            </div>
                            <dl class="gr-meta">
                                <div><dt><fmt:message key="gr.code"/></dt><dd><c:out value="${g.courseCode()}"/></dd></div>
                                <div><dt><fmt:message key="gr.type"/></dt><dd><c:choose><c:when test="${empty g.nature()}">—</c:when><c:otherwise><fmt:message key="gr.nature.${g.nature()}"/></c:otherwise></c:choose></dd></div>
                                <div><dt><fmt:message key="gr.attribute"/></dt><dd><fmt:message key="gr.attribute.${g.attribute()}"/></dd></div>
                                <div><dt><fmt:message key="gr.assessment"/></dt><dd><fmt:message key="gr.assessment.${g.assessment()}"/></dd></div>
                                <div><dt><fmt:message key="gr.credit"/></dt><dd>${g.creditsText()}</dd></div>
                                <div><dt><fmt:message key="gr.hours"/></dt><dd>${empty g.hours() ? '—' : g.hours()}</dd></div>
                                <div><dt><fmt:message key="gr.score"/></dt><dd>${g.scoreText(tx)}</dd></div>
                                <div><dt><fmt:message key="gr.makeup"/></dt><dd><c:choose><c:when test="${g.examNature() == 'makeup'}"><fmt:message key="gr.yes"/></c:when><c:otherwise>—</c:otherwise></c:choose></dd></div>
                                <div><dt><fmt:message key="gr.retake"/></dt><dd><c:choose><c:when test="${g.examNature() == 'retake'}"><fmt:message key="gr.yes"/></c:when><c:otherwise>—</c:otherwise></c:choose></dd></div>
                                <div><dt><fmt:message key="gr.point"/></dt><dd><strong>${g.gradePointText()}</strong></dd></div>
                            </dl>
                            <p class="gr-college"><c:out value="${g.college()}"/></p>
                        </article>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </c:otherwise>
</c:choose>
