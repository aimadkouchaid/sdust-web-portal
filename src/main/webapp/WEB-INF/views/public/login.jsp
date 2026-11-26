<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="${htmlLang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="login.title"/> - <fmt:message key="site.name"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/favicon.png" type="image/x-icon">
</head>
<body>
    <div class="login-container">
        <div class="login-card">
            <div class="login-media">
                <img src="${pageContext.request.contextPath}/assets/campus-aerial.jpg" alt="<fmt:message key="login.media.alt"/>">
                <div class="login-media-overlay">
                    <a href="${pageContext.request.contextPath}/home" class="login-logo">
                        <img src="${pageContext.request.contextPath}/assets/logo-white.webp" alt="SDUST">
                    </a>
                    <div class="login-media-text">
                        <h2><fmt:message key="login.media.title1"/> <span><fmt:message key="login.media.title2"/></span></h2>
                        <p><fmt:message key="login.media.text"/></p>
                    </div>
                </div>
            </div>

            <c:set var="idKey" value="${role == 'student' or empty role ? 'student' : 'staff'}"/>
            <form class="login-form" action="${pageContext.request.contextPath}/login" method="post" novalidate
                  data-label-student="<fmt:message key="login.id.student"/>"
                  data-label-staff="<fmt:message key="login.id.staff"/>"
                  data-placeholder-student="<fmt:message key="login.id.placeholder.student"/>"
                  data-placeholder-staff="<fmt:message key="login.id.placeholder.staff"/>"
                  data-missing-student="<fmt:message key="login.error.missing.student"/>"
                  data-missing-staff="<fmt:message key="login.error.missing.staff"/>"
                  data-id-student="<fmt:message key="login.error.id.student"/>"
                  data-id-staff="<fmt:message key="login.error.id.staff"/>"
                  data-password="<fmt:message key="login.error.password"/>">
                <c:url var="switchUrl" value="/language">
                    <c:param name="to"><fmt:message key="lang.switch.to"/></c:param>
                    <c:param name="back" value="${currentPath}"/>
                </c:url>
                <a href="${switchUrl}" class="login-lang" hreflang="<fmt:message key="lang.switch.to"/>" aria-label="<fmt:message key="lang.switch.aria"/>" title="<fmt:message key="lang.switch.title"/>">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3c2.5 2.7 3.8 5.7 3.8 9s-1.3 6.3-3.8 9c-2.5-2.7-3.8-5.7-3.8-9s1.3-6.3 3.8-9z"/></svg>
                    <span lang="<fmt:message key="lang.switch.to"/>"><fmt:message key="lang.switch.label"/></span>
                </a>
                <span class="login-label"><fmt:message key="login.label"/></span>
                <h1 class="login-title"><fmt:message key="login.heading"/></h1>
                <p class="login-subtitle"><fmt:message key="login.subtitle"/></p>

                <div class="input-group">
                    <label for="userid"><fmt:message key="login.id.${idKey}"/></label>
                    <div class="input-field">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                        <input type="text" name="userid" id="userid" value="${fn:escapeXml(userid)}" placeholder="<fmt:message key="login.id.placeholder.${idKey}"/>" autocomplete="username" aria-describedby="login-alert" required>
                    </div>
                </div>

                <div class="input-group">
                    <label for="password"><fmt:message key="login.password"/></label>
                    <div class="input-field">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                        <input type="password" name="password" id="password" placeholder="<fmt:message key="login.password.placeholder"/>" autocomplete="current-password" aria-describedby="login-alert" required ${not empty error and not empty userid ? 'autofocus' : ''}>
                        <button type="button" class="pass-toggle" aria-controls="password" aria-pressed="false" aria-label="<fmt:message key="login.password.show"/>" data-show="<fmt:message key="login.password.show"/>" data-hide="<fmt:message key="login.password.hide"/>"><svg class="eye-show" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="3"/></svg><svg class="eye-hide" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 3l18 18"/><path d="M10.6 5.1A10.7 10.7 0 0 1 12 5c6.5 0 10 7 10 7a17.6 17.6 0 0 1-3.2 4.2M6.6 6.6C3.8 8.4 2 12 2 12s3.5 7 10 7a9.7 9.7 0 0 0 5.4-1.6"/><path d="M9.9 9.9a3 3 0 0 0 4.2 4.2"/></svg></button>
                    </div>
                    <button type="button" class="login-forgot" aria-expanded="false" aria-controls="forgot-note"><fmt:message key="login.forgot"/></button>
                    <p class="login-forgot-note" id="forgot-note" hidden><svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="M12 11v5M12 7.8v.1"/></svg><span><fmt:message key="login.forgot.note"/></span></p>
                </div>

                <div class="input-group">
                    <label for="loginas"><fmt:message key="login.as"/></label>
                    <div class="input-field">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                        <select name="loginas" id="loginas">
                            <option value="Student" ${role == 'student' ? 'selected' : ''}><fmt:message key="login.role.student"/></option>
                            <option value="Teacher" ${role == 'teacher' ? 'selected' : ''}><fmt:message key="login.role.teacher"/></option>
                            <option value="Counselor" ${role == 'counselor' ? 'selected' : ''}><fmt:message key="login.role.counselor"/></option>
                        </select>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${not empty error}">
                        <c:set var="alertType" value="error"/>
                        <fmt:message var="alertText" key="${error}"/>
                    </c:when>
                    <c:when test="${param.logout == '1'}">
                        <c:set var="alertType" value="info"/>
                        <fmt:message var="alertText" key="login.loggedout"/>
                    </c:when>
                </c:choose>
                <div class="login-alert ${alertType}" id="login-alert" role="alert" ${empty alertText ? 'hidden' : ''}>
                    <svg class="login-alert-error" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="M12 7.5v5M12 16.2v.1"/></svg>
                    <svg class="login-alert-info" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="m8 12.5 2.7 2.7L16 9.8"/></svg>
                    <p class="login-alert-text"><c:out value="${alertText}"/></p>
                </div>

                <button type="submit" class="login-btn"><fmt:message key="login.submit"/><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12h14M13 6l6 6-6 6"/></svg></button>
                
                <a href="${pageContext.request.contextPath}/home" class="login-back"><fmt:message key="login.back"/></a>
            </form>
        </div>
    </div>


    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
