<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<h1 class="pgtitle"><fmt:message key="dash.nav.students"/></h1>
<c:choose>
    <c:when test="${studentsError}">
        <p class="form-status error" role="status"><fmt:message key="st.error"/></p>
    </c:when>
    <c:otherwise>
        <c:set var="pendingTotal" value="0"/>
        <c:set var="onLeave" value="0"/>
        <c:forEach var="s" items="${students}">
            <c:set var="pendingTotal" value="${pendingTotal + s.pending()}"/>
            <c:if test="${not empty s.onLeaveUntil()}"><c:set var="onLeave" value="${onLeave + 1}"/></c:if>
        </c:forEach>
        <div class="st-stats">
            <div class="st-stat"><strong>${fn:length(students)}</strong><span><fmt:message key="st.stat.students"/></span></div>
            <div class="st-stat"><strong>${onLeave}</strong><span><fmt:message key="st.stat.onleave"/></span></div>
            <a class="st-stat" href="${pageContext.request.contextPath}/dashboard/counselor/leave"><strong>${pendingTotal}</strong><span><fmt:message key="st.stat.pending"/></span></a>
        </div>
        <div class="st-toolbar">
            <label class="an-search"><svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/></svg><input type="search" id="stsearch" placeholder="<fmt:message key="st.search.ph"/>" aria-label="<fmt:message key="st.search"/>"></label>
            <p class="st-count" aria-live="polite" data-one="<fmt:message key="st.count.one"/>" data-many="<fmt:message key="st.count.many"/>"></p>
        </div>
        <div class="lr-tablewrap">
            <table class="st-table">
                <thead>
                    <tr>
                        <th><fmt:message key="st.th.student"/></th>
                        <th><fmt:message key="st.th.class"/></th>
                        <th class="st-col-hide"><fmt:message key="st.th.year"/></th>
                        <th><fmt:message key="st.th.contact"/></th>
                        <th class="st-num"><fmt:message key="st.th.gpa"/></th>
                        <th class="st-num st-col-hide"><fmt:message key="st.th.credits"/></th>
                        <th><fmt:message key="st.th.leave"/></th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="s" items="${students}">
                        <tr class="st-row">
                            <td>
                                <span class="st-name"><c:out value="${s.name()}"/></span>
                                <span class="st-sub"><c:out value="${s.id()}"/><c:if test="${not empty s.gender()}"> · <fmt:message key="gender.${s.gender()}"/></c:if></span>
                            </td>
                            <td data-label="<fmt:message key='st.th.class'/>">
                                <span class="st-name"><c:out value="${empty s.className() ? tx.get('profile.notset') : s.className()}"/></span>
                                <span class="st-sub"><c:out value="${s.major()}"/><c:if test="${not empty s.campus()}"> · <c:out value="${s.campus()}"/></c:if></span>
                            </td>
                            <td class="st-col-hide" data-label="<fmt:message key='st.th.year'/>">${empty s.enrollmentYear() ? '—' : s.enrollmentYear()}</td>
                            <td data-label="<fmt:message key='st.th.contact'/>">
                                <c:choose>
                                    <c:when test="${empty s.phone() and empty s.email()}"><span class="st-sub"><fmt:message key="profile.notset"/></span></c:when>
                                    <c:otherwise>
                                        <c:if test="${not empty s.phone()}"><a class="st-link" href="tel:${fn:escapeXml(s.phone())}"><c:out value="${s.phone()}"/></a></c:if>
                                        <c:if test="${not empty s.email()}"><a class="st-link st-sub" href="mailto:${fn:escapeXml(s.email())}"><c:out value="${s.email()}"/></a></c:if>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="st-num" data-label="<fmt:message key='st.th.gpa'/>"><strong>${s.gpaText()}</strong></td>
                            <td class="st-num st-col-hide" data-label="<fmt:message key='st.th.credits'/>">${s.creditsText()}</td>
                            <td data-label="<fmt:message key='st.th.leave'/>">
                                <c:choose>
                                    <c:when test="${not empty s.onLeaveUntil()}"><span class="st-badge away">${s.onLeaveText(tx)}</span></c:when>
                                    <c:when test="${s.pending() > 0}"><a class="st-badge pending" href="${pageContext.request.contextPath}/dashboard/counselor/leave">${tx.format(s.pending() == 1 ? 'st.pending.one' : 'st.pending.many', s.pending())}</a></c:when>
                                    <c:otherwise><span class="st-badge"><fmt:message key="st.oncampus"/></span></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        <p class="st-empty"${empty students ? '' : ' hidden'}><fmt:message key="${empty students ? 'st.none' : 'st.nomatch'}"/></p>
    </c:otherwise>
</c:choose>
