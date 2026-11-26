<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<footer class="footer">
    <div class="footer-image"></div>

    <div class="footer-content">
        <div class="footer-layout">

            <div class="footer-about">
                <img src="${pageContext.request.contextPath}/assets/logo-white.webp" alt="sdust" class="footer-logo">

                <p class="footer-description">
                    <fmt:message key="footer.description"/>
                </p>
            </div>

            <div class="footer-contact">
                <h1><fmt:message key="footer.contact"/></h1>

                <a href="https://ditu.amap.com/search?query=山东科技大学青岛校区"
                target="_blank" rel="noopener">
                    <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" class="contact-icon"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5A2.5 2.5 0 1 1 12 6.5a2.5 2.5 0 0 1 0 5z" fill="white"/></svg>
                    <span><fmt:message key="footer.address"/></span>
                </a>

                <a href="mailto:admission@sdust.edu.cn">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" class="contact-icon"><path d="M20 4H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4-8 5-8-5V6l8 5 8-5v2z" fill="white"/></svg>
                    <span>admission@sdust.edu.cn</span>
                </a>

                <a href="tel:+8653286057907">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" class="contact-icon"><path d="M6.62 10.79c1.44 2.83 3.76 5.14 6.59 6.59l2.2-2.2c.27-.27.67-.36 1.02-.24 1.12.37 2.33.57 3.57.57.55 0 1 .45 1 1V20c0 .55-.45 1-1 1-9.39 0-17-7.61-17-17 0-.55.45-1 1-1h3.5c.55 0 1 .45 1 1 0 1.25.2 2.45.57 3.57.11.35.03.74-.25 1.02l-2.2 2.2z" fill="white"/></svg>
                    <span>+86 532 86057907</span>
                </a>

                <a href="tel:+8653286057187">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" class="contact-icon"><path d="M19 9h-1V4H6v5H5c-1.1 0-2 .9-2 2v7h3v3h12v-3h3v-7c0-1.1-.9-2-2-2zM8 6h8v3H8V6zm8 14H8v-5h8v5zm2-7c-.55 0-1-.45-1-1s.45-1 1-1 1 .45 1 1-.45 1-1 1z" fill="white"/></svg>
                    <span>+86 532 86057187</span>
                </a>
            </div>
        </div>

        <div class="footer-bottom">
            <hr>
            <p><fmt:message key="footer.copyright"/></p>
        </div>
    </div>
</footer>

<div class="float-actions">
    <button type="button" class="back-to-top" aria-label="<fmt:message key="footer.top"/>">
        <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 19V5M5 12l7-7 7 7"/></svg>
    </button>
    <c:url var="switchUrl" value="/language">
        <c:param name="to"><fmt:message key="lang.switch.to"/></c:param>
        <c:param name="back" value="${currentPath}"/>
    </c:url>
    <a href="${switchUrl}" class="language-btn" hreflang="<fmt:message key="lang.switch.to"/>" aria-label="<fmt:message key="lang.switch.aria"/>" title="<fmt:message key="lang.switch.title"/>">
        <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3c2.5 2.7 3.8 5.7 3.8 9s-1.3 6.3-3.8 9c-2.5-2.7-3.8-5.7-3.8-9s1.3-6.3 3.8-9z"/></svg>
        <span lang="<fmt:message key="lang.switch.to"/>"><fmt:message key="lang.switch.label"/></span>
    </a>
</div>
