<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/home" class="nav-logo">
        <img src="${pageContext.request.contextPath}/assets/logo-white.webp" alt="SDUST">
    </a>

    <div class="menu">
        <a href="${pageContext.request.contextPath}/home" class="${param.active == 'home' ? 'active' : ''}"><fmt:message key="nav.home"/></a>
        <a href="${pageContext.request.contextPath}/home#about-us"><fmt:message key="nav.about"/></a>
        <a href="${pageContext.request.contextPath}/academics-research" class="${param.active == 'academics' ? 'active' : ''}"><fmt:message key="nav.academics"/></a>
        <a href="${pageContext.request.contextPath}/news-announcements" class="${param.active == 'news' ? 'active' : ''}"><fmt:message key="nav.news"/></a>
        <a href="${pageContext.request.contextPath}/admissions" class="${param.active == 'admissions' ? 'active' : ''}"><fmt:message key="nav.admissions"/></a>
        <a href="${pageContext.request.contextPath}/campuslife" class="${param.active == 'campus' ? 'active' : ''}"><fmt:message key="nav.campus"/></a>
    </div>

    <div class="hamlogin">
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <div class="login">
                    <a href="${pageContext.request.contextPath}/dashboard" class="login-main-btn">
                        <fmt:message key="nav.dashboard"/>
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="login">
                    <button class="login-main-btn">
                        <fmt:message key="nav.login"/>
                        <svg xmlns="http://www.w3.org/2000/svg"
                            width="16" height="16"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            class="login-chevron">
                            <path d="m6 9 6 6 6-6"/>
                        </svg>
                    </button>

                    <div class="login-dropdown">
                        <a href="${pageContext.request.contextPath}/login?role=student"><fmt:message key="nav.role.student"/></a>
                        <a href="${pageContext.request.contextPath}/login?role=teacher"><fmt:message key="nav.role.teacher"/></a>
                        <a href="${pageContext.request.contextPath}/login?role=counselor"><fmt:message key="nav.role.counselor"/></a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
        <button class="hamburger-menu" id="hamburger" aria-label="<fmt:message key="nav.open"/>">
            <span></span>
            <span></span>
            <span></span>
        </button>
    </div>
</nav>
