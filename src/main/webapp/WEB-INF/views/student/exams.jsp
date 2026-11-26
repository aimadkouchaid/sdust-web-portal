<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<h1 class="pgtitle"><fmt:message key="dash.nav.exams"/></h1>
<c:choose>
    <c:when test="${examsError}">
        <p class="form-status error" role="status"><fmt:message key="exam.error"/></p>
    </c:when>
    <c:otherwise>
        <c:set var="upcoming" value="0"/>
        <c:set var="finished" value="0"/>
        <c:forEach var="e" items="${exams}">
            <c:choose>
                <c:when test="${e.past()}"><c:set var="finished" value="${finished + 1}"/></c:when>
                <c:otherwise><c:set var="upcoming" value="${upcoming + 1}"/></c:otherwise>
            </c:choose>
        </c:forEach>

        <h2 class="ex-heading"><fmt:message key="exam.upcoming"/> <span class="ex-count">${upcoming}</span></h2>
        <div class="ex-list">
            <c:forEach var="e" items="${exams}">
                <c:if test="${not e.past()}"><t:exam exam="${e}"/></c:if>
            </c:forEach>
        </div>
        <c:if test="${upcoming == 0}">
            <p class="ex-empty"><fmt:message key="exam.none.student"/></p>
        </c:if>

        <c:if test="${finished > 0}">
            <h2 class="ex-heading"><fmt:message key="exam.past"/> <span class="ex-count">${finished}</span></h2>
            <div class="ex-list ex-past-list">
                <c:forEach var="e" items="${exams}">
                    <c:if test="${e.past()}"><t:exam exam="${e}"/></c:if>
                </c:forEach>
            </div>
        </c:if>
    </c:otherwise>
</c:choose>
