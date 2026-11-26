<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<h1 class="pgtitle"><fmt:message key="dash.nav.gradeentry"/></h1>
<c:choose>
    <c:when test="${entryError}">
        <p class="form-status error" role="status"><fmt:message key="ge.error"/></p>
    </c:when>
    <c:when test="${empty classes}">
        <p class="ge-empty"><fmt:message key="ge.noclasses"/></p>
    </c:when>
    <c:otherwise>
        <section class="gr-card">
            <h2 class="gr-cardtitle"><fmt:message key="ge.choose"/></h2>
            <form method="get" action="${pageContext.request.contextPath}/dashboard/teacher/grades" class="gr-pick">
                <label for="geclass"><fmt:message key="ge.class"/></label>
                <select name="class" id="geclass">
                    <c:forEach var="k" items="${classes}">
                        <option value="${k.id()}"${k.id() == chosen.id() ? ' selected' : ''}><c:out value="${k.courseName()} (${k.courseCode()}) · ${k.semester()} · ${tx.format('ge.progress', k.graded(), k.students())}"/></option>
                    </c:forEach>
                </select>
                <noscript><button type="submit" class="gr-go"><fmt:message key="gr.show"/></button></noscript>
            </form>
        </section>

        <section class="gr-card">
            <h2 class="gr-cardtitle"><c:out value="${chosen.courseName()}"/></h2>
            <ul class="gr-stats">
                <li><span class="gr-dot c1"></span><fmt:message key="ge.semester"/>: <strong>${chosen.semester()}</strong></li>
                <li><span class="gr-dot c2"></span><fmt:message key="gr.assessment"/>: <strong><fmt:message key="gr.assessment.${chosen.assessment()}"/></strong></li>
                <li><span class="gr-dot c4"></span><fmt:message key="ge.graded"/>: <strong class="ge-graded">${chosen.graded()} / ${chosen.students()}</strong></li>
                <li><span class="gr-dot c1"></span><fmt:message key="ge.avgscore"/>: <strong class="ge-avgscore">${chosen.avgScoreText()}</strong></li>
                <li><span class="gr-dot c2"></span><fmt:message key="ge.avgpoint"/>: <strong class="ge-avgpoint">${chosen.avgPointText()}</strong></li>
            </ul>
        </section>

        <c:choose>
            <c:when test="${empty rows}">
                <p class="ge-empty"><fmt:message key="ge.nostudents"/></p>
            </c:when>
            <c:otherwise>
                <c:if test="${chosen.ungraded() > 0}">
                    <p class="ge-notice"><svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 9v4M12 17h.01M10.3 3.9 1.8 18a2 2 0 0 0 1.7 3h17a2 2 0 0 0 1.7-3L13.7 3.9a2 2 0 0 0-3.4 0z"/></svg><fmt:message key="ge.final"/></p>
                </c:if>
                <form class="ge-form" action="${pageContext.request.contextPath}/dashboard/teacher/grades/save" method="post" novalidate>
                    <input type="hidden" name="csrf" value="${sessionScope.csrf}">
                    <input type="hidden" name="class" value="${chosen.id()}">
                    <div class="lr-tablewrap">
                        <table class="ge-table">
                            <thead>
                                <tr>
                                    <th><fmt:message key="st.th.student"/></th>
                                    <th><fmt:message key="st.th.class"/></th>
                                    <th><fmt:message key="gr.score"/></th>
                                    <th class="ge-num"><fmt:message key="gr.point"/></th>
                                    <th><fmt:message key="ge.status"/></th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="r" items="${rows}">
                                    <tr class="ge-row${r.graded() ? ' done' : ''}" data-id="${r.enrollmentId()}">
                                        <td><span class="st-name"><c:out value="${r.studentName()}"/></span><span class="st-sub"><c:out value="${r.studentId()}"/></span></td>
                                        <td data-label="<fmt:message key='st.th.class'/>"><c:out value="${r.className()}"/></td>
                                        <td class="ge-cell" data-label="<fmt:message key='gr.score'/>">
                                            <c:choose>
                                                <c:when test="${r.graded()}"><strong class="ge-final">${r.scoreText(tx)}</strong></c:when>
                                                <c:otherwise>
                                                    <div class="ge-inputs">
                                                        <input type="text" inputmode="decimal" name="score-${r.enrollmentId()}" id="score-${r.enrollmentId()}" class="ge-score" maxlength="5" placeholder="0–100" aria-label="<fmt:message key="ge.scorefor"><fmt:param value="${r.studentName()}"/></fmt:message>" aria-describedby="score-${r.enrollmentId()}-error">
                                                        <c:if test="${chosen.assessment() == 'assessment'}">
                                                            <select name="level-${r.enrollmentId()}" class="ge-level" aria-label="<fmt:message key="ge.levelfor"><fmt:param value="${r.studentName()}"/></fmt:message>">
                                                                <option value=""><fmt:message key="ge.orlevel"/></option>
                                                                <c:forEach var="lv" items="excellent,good,medium,pass,fail">
                                                                    <option value="${lv}"><fmt:message key="gr.level.${lv}"/></option>
                                                                </c:forEach>
                                                            </select>
                                                        </c:if>
                                                    </div>
                                                    <p class="field-error" id="score-${r.enrollmentId()}-error" aria-live="polite"></p>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="ge-num" data-label="<fmt:message key='gr.point'/>"><strong class="ge-point">${r.graded() ? r.gradePointText() : '—'}</strong></td>
                                        <td data-label="<fmt:message key='ge.status'/>"><span class="ge-badge${r.graded() ? ' done' : ''}"><fmt:message key="${r.graded() ? 'ge.status.final' : 'ge.status.waiting'}"/></span></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <c:if test="${chosen.ungraded() > 0}">
                        <div class="ge-actions">
                            <p class="form-status" role="status"></p>
                            <button type="submit" class="ge-save"><fmt:message key="js.ge.save"/></button>
                        </div>
                    </c:if>
                </form>
            </c:otherwise>
        </c:choose>
    </c:otherwise>
</c:choose>
