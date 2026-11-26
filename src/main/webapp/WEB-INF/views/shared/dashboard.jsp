<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="active" value="${pageContext.servletConfig.getInitParameter('active')}"/>
<!DOCTYPE html>
<html lang="${htmlLang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="${pageContext.servletConfig.getInitParameter('title')}"/> - <fmt:message key="dash.sitetitle"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/leaverequest.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profile.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/timetable.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/grades.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/announcements.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/exams.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/students.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/gradeentry.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/courses.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dash.css">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/favicon.png" type="image/x-icon">
</head>
<body>
    <div class="sidebar expanded">
        <div class="sdlogo">
            <img src="${pageContext.request.contextPath}/assets/logo-white.webp" alt="SDUST">
        </div>
        <hr>
        <div class="sidelinks">
            <c:choose>
                <c:when test="${sessionScope.user.role == 'teacher'}">
                    <a href="${pageContext.request.contextPath}/dashboard/teacher/timetable" class="sidelink${active == 'teacher-timetable' ? ' active' : ''}">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M4 7a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2zM16 3v4M8 3v4M4 11h16"/></svg>
                        <span><fmt:message key="dash.nav.timetable"/></span>
                    </a>
                    <a href="${pageContext.request.contextPath}/dashboard/teacher/courses" class="sidelink${active == 'teacher-courses' ? ' active' : ''}">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M4 5a2 2 0 0 1 2-2h13v16H6a2 2 0 0 0-2 2zM4 19V5M8 7h7"/></svg>
                        <span><fmt:message key="dash.nav.courses"/></span>
                    </a>
                    <a href="${pageContext.request.contextPath}/dashboard/teacher/grades" class="sidelink${active == 'teacher-grades' ? ' active' : ''}">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M4 20h16M7 20v-8M12 20V5M17 20v-11"/></svg>
                        <span><fmt:message key="dash.nav.gradeentry"/></span>
                    </a>
                    <a href="${pageContext.request.contextPath}/dashboard/teacher/exams" class="sidelink${active == 'teacher-exams' ? ' active' : ''}">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M9 4h6a1 1 0 0 1 1 1v1H8V5a1 1 0 0 1 1-1zM8 5H6a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2M9 13l2 2 4-4"/></svg>
                        <span><fmt:message key="dash.nav.exams"/></span>
                    </a>
                    <a href="${pageContext.request.contextPath}/dashboard/teacher/announcements" class="sidelink${active == 'teacher-announcements' ? ' active' : ''}">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 11v2a1 1 0 0 0 1 1h3l5 4V6L7 10H4a1 1 0 0 0-1 1zM16 9a4 4 0 0 1 0 6M19 6a8 8 0 0 1 0 12"/></svg>
                        <span><fmt:message key="dash.nav.announcements"/></span>
                    </a>
                </c:when>
                <c:when test="${sessionScope.user.role == 'counselor'}">
                    <a href="${pageContext.request.contextPath}/dashboard/counselor/leave" class="sidelink${active == 'counselor-leave' ? ' active' : ''}">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M9 11l3 3 8-8M20 12v7a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h9"/></svg>
                        <span><fmt:message key="dash.nav.leaverequests"/></span>
                    </a>
                    <a href="${pageContext.request.contextPath}/dashboard/counselor/students" class="sidelink${active == 'counselor-students' ? ' active' : ''}">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2M9 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                        <span><fmt:message key="dash.nav.students"/></span>
                    </a>
                    <a href="${pageContext.request.contextPath}/dashboard/counselor/announcements" class="sidelink${active == 'counselor-announcements' ? ' active' : ''}">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 11v2a1 1 0 0 0 1 1h3l5 4V6L7 10H4a1 1 0 0 0-1 1zM16 9a4 4 0 0 1 0 6M19 6a8 8 0 0 1 0 12"/></svg>
                        <span><fmt:message key="dash.nav.announcements"/></span>
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/dashboard/timetable" class="sidelink${active == 'timetable' ? ' active' : ''}">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M4 7a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2zM16 3v4M8 3v4M4 11h16"/></svg>
                        <span><fmt:message key="dash.nav.timetable"/></span>
                    </a>
                    <a href="${pageContext.request.contextPath}/dashboard/grades" class="sidelink${active == 'grades' ? ' active' : ''}">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M4 20h16M7 20v-8M12 20V5M17 20v-11"/></svg>
                        <span><fmt:message key="dash.nav.grades"/></span>
                    </a>
                    <a href="${pageContext.request.contextPath}/dashboard/exams" class="sidelink${active == 'exams' ? ' active' : ''}">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M9 4h6a1 1 0 0 1 1 1v1H8V5a1 1 0 0 1 1-1zM8 5H6a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2M9 13l2 2 4-4"/></svg>
                        <span><fmt:message key="dash.nav.exams"/></span>
                    </a>
                    <a href="${pageContext.request.contextPath}/dashboard/leave" class="sidelink${active == 'leave' ? ' active' : ''}">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M14 3H7a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V8zM14 3v5h5M9 13h6M9 17h6"/></svg>
                        <span><fmt:message key="dash.nav.leave"/></span>
                    </a>
                    <a href="${pageContext.request.contextPath}/dashboard/announcements" class="sidelink${active == 'announcements' ? ' active' : ''}">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 11v2a1 1 0 0 0 1 1h3l5 4V6L7 10H4a1 1 0 0 0-1 1zM16 9a4 4 0 0 1 0 6M19 6a8 8 0 0 1 0 12"/></svg>
                        <span><fmt:message key="dash.nav.announcements"/></span>
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
        <hr>
        <div class="bottomlinks">
            <a href="${pageContext.request.contextPath}/dashboard/profile" class="btmprofile sidelink${active == 'profile' ? ' active' : ''}">
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 3a4 4 0 1 0 0 8 4 4 0 0 0 0-8zM5 21v-1a6 6 0 0 1 6-6h2a6 6 0 0 1 6 6v1"/></svg>
                <span><fmt:message key="dash.nav.profile"/></span>
            </a>
            <div class="logout sidelink">
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M14 8V6a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h7a2 2 0 0 0 2-2v-2M9 12h12M18 9l3 3-3 3"/></svg>
                <span><fmt:message key="dash.nav.logout"/></span>
            </div>
        </div>

    </div>
    <div class="sdbackdrop"></div>
    <div class="container">
        <div class="dashnav">
            <button class="sideaction" aria-label="<fmt:message key="dash.togglesidebar"/>" aria-expanded="true">
                <svg class="shrinksd" viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M4 6a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2zM9 4v16M16 10l-2 2 2 2"/></svg>
                <svg class="expandsd" viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M4 6a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2zM9 4v16M14 10l2 2-2 2"/></svg>
            </button>
            <h3><fmt:message key="dash.heading.${sessionScope.user.role}"/></h3>
            <div class="navactions">
                <c:url var="switchUrl" value="/language">
                    <c:param name="to"><fmt:message key="lang.switch.to"/></c:param>
                    <c:param name="back" value="${currentPath}"/>
                </c:url>
                <a href="${switchUrl}" class="dash-lang" hreflang="<fmt:message key="lang.switch.to"/>" aria-label="<fmt:message key="lang.switch.aria"/>" title="<fmt:message key="lang.switch.title"/>">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3c2.5 2.7 3.8 5.7 3.8 9s-1.3 6.3-3.8 9c-2.5-2.7-3.8-5.7-3.8-9s1.3-6.3 3.8-9z"/></svg>
                    <span lang="<fmt:message key="lang.switch.to"/>"><fmt:message key="lang.switch.label"/></span>
                </a>
                <c:if test="${not empty sessionScope.user}">
                    <div class="ntf" data-read-url="${pageContext.request.contextPath}/dashboard/notifications/read" data-clear-url="${pageContext.request.contextPath}/dashboard/notifications/clear" data-csrf="${sessionScope.csrf}">
                        <button type="button" class="notifications" aria-label="<fmt:message key="dash.ntf.title"/>" aria-haspopup="true" aria-expanded="false" aria-controls="ntf-panel">
                            <p class="nbadge">0</p>
                            <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M10 5a2 2 0 1 1 4 0 7 7 0 0 1 4 6v3a4 4 0 0 0 2 3H4a4 4 0 0 0 2-3v-3a7 7 0 0 1 4-6M9 17v1a3 3 0 0 0 6 0v-1"/></svg>
                        </button>
                        <div class="ntf-panel" id="ntf-panel" role="region" aria-label="<fmt:message key="dash.ntf.title"/>">
                            <div class="ntf-head">
                                <h4><fmt:message key="dash.ntf.title"/></h4>
                                <div class="ntf-actions">
                                    <button type="button" class="ntf-readall"><fmt:message key="dash.ntf.readall"/></button>
                                    <button type="button" class="ntf-clear"><fmt:message key="dash.ntf.clear"/></button>
                                </div>
                            </div>
                            <ul class="ntf-list">
                                <c:if test="${notificationsError}">
                                    <li class="ntf-empty"><fmt:message key="dash.ntf.error"/></li>
                                </c:if>
                                <c:if test="${not notificationsError and empty notifications}">
                                    <li class="ntf-empty"><fmt:message key="dash.ntf.empty"/></li>
                                </c:if>
                                <c:forEach var="n" items="${notifications}">
                                    <li class="ntf-item${n.read ? '' : ' unread'}" data-id="${n.id}">
                                        <a href="${pageContext.request.contextPath}${empty n.link ? '/dashboard' : n.link}" class="ntf-link">
                                            <span class="ntf-icon ${n.type}"><svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><c:choose>
                                                <c:when test="${n.type == 'leave'}"><path d="M14 3H7a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V8zM14 3v5h5M9 13h6M9 17h6"/></c:when>
                                                <c:when test="${n.type == 'grade'}"><path d="M4 20h16M7 20v-8M12 20V5M17 20v-11"/></c:when>
                                                <c:when test="${n.type == 'exam'}"><path d="M9 4h6a1 1 0 0 1 1 1v1H8V5a1 1 0 0 1 1-1zM8 5H6a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2M9 13l2 2 4-4"/></c:when>
                                                <c:when test="${n.type == 'timetable'}"><path d="M4 7a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2zM16 3v4M8 3v4M4 11h16"/></c:when>
                                                <c:otherwise><path d="M3 11v2a1 1 0 0 0 1 1h3l5 4V6L7 10H4a1 1 0 0 0-1 1zM16 9a4 4 0 0 1 0 6M19 6a8 8 0 0 1 0 12"/></c:otherwise>
                                            </c:choose></svg></span>
                                            <span class="ntf-text">
                                                <strong><c:out value="${n.titleText(tx)}"/></strong>
                                                <span><c:out value="${n.messageText(tx)}"/></span>
                                                <time datetime="${n.isoTime()}">${n.timeText(tx)}</time>
                                            </span>
                                        </a>
                                    </li>
                                </c:forEach>
                            </ul>
                            <a href="${pageContext.request.contextPath}/dashboard${sessionScope.user.role == 'student' ? '' : '/'.concat(sessionScope.user.role)}/announcements" class="ntf-all"><fmt:message key="dash.ntf.all"/></a>
                        </div>
                    </div>
                </c:if>
                <a href="${pageContext.request.contextPath}/dashboard/profile" class="dashprofile">
                    <span class="profileic">
                        <h1><c:out value="${sessionScope.user.initial}"/></h1>
                    </span>
                    <h2><c:out value="${fn:toUpperCase(sessionScope.user.name)}"/></h2>
                    <p><fmt:message key="dash.role.${sessionScope.user.role}"/></p>
                </a>
            </div>
        </div>
        <div class="page-container">
            <jsp:include page="${pageContext.servletConfig.getInitParameter('content')}"/>
        </div>
    </div>

    <div class="logoutcontainer">
        <div class="logoutbox">
            <button class="closelg" aria-label="<fmt:message key="dash.close"/>">
                <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M6 6l12 12M18 6L6 18"/></svg>
            </button>
            <h1><fmt:message key="dash.nav.logout"/></h1>
            <p><fmt:message key="dash.logout.confirm"/></p>
            <div class="logoutboxac">
                <button class="cancellg"><fmt:message key="dash.cancel"/></button>
                <a href="${pageContext.request.contextPath}/logout" class="lg"><fmt:message key="dash.nav.logout"/></a>
            </div>
        </div>
    </div>

    <div class="lr-modal">
        <div class="lr-modalbox" role="dialog" aria-modal="true" aria-labelledby="lr-modal-title">
            <button type="button" class="lr-modal-close" aria-label="<fmt:message key="dash.close"/>">
                <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M6 6l12 12M18 6L6 18"/></svg>
            </button>
            <h1 id="lr-modal-title"><fmt:message key="leave.cancel.title"/></h1>
            <p><fmt:message key="leave.cancel.confirm"><fmt:param><strong class="lr-modal-info"></strong></fmt:param></fmt:message></p>
            <div class="lr-modalac">
                <button type="button" class="lr-keep"><fmt:message key="leave.cancel.keep"/></button>
                <button type="button" class="lr-confirm"><fmt:message key="leave.cancel.title"/></button>
            </div>
        </div>
    </div>

    <script type="application/json" id="dash-i18n">${tx.json('js.')}</script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/dash.js"></script>
</body>
</html>