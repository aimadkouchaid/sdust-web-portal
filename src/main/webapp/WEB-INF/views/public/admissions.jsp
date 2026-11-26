<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="${htmlLang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="admissions.title"/> - <fmt:message key="site.name"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/favicon.png" type="image/x-icon">
</head>
<body>
    <header class="hero-header" style="min-height: auto;background-position: top;overflow: visible;">
        <jsp:include page="/WEB-INF/views/public/partials/navbar.jsp">
            <jsp:param name="active" value="admissions"/>
        </jsp:include>
    </header>

    <div class="page-container">
        <h1 class="page-title"><fmt:message key="admissions.title1"/> <Strong><fmt:message key="admissions.title2"/></Strong></h1>
        <section class="cl-section" data-animate>
            <div class="cl-heading">
                <span class="cl-label"><fmt:message key="ad.prog.label"/></span>
                <h2><fmt:message key="ad.prog.title1"/> <span><fmt:message key="ad.prog.title2"/></span></h2>
            </div>
            <div class="cl-grid">
                <article class="cl-card">
                    <div class="cl-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M22 10 12 5 2 10l10 5 10-5zM6 12v5c3 2 9 2 12 0v-5"/></svg></div>
                    <h3><fmt:message key="ad.prog.1.title"/></h3>
                    <p><fmt:message key="ad.prog.1.text"/></p>
                </article>
                <article class="cl-card">
                    <div class="cl-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20V3H6.5A2.5 2.5 0 0 0 4 5.5v14zM4 19.5A2.5 2.5 0 0 0 6.5 22H20v-5"/></svg></div>
                    <h3><fmt:message key="ad.prog.2.title"/></h3>
                    <p><fmt:message key="ad.prog.2.text"/></p>
                </article>
                <article class="cl-card">
                    <div class="cl-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M9 3h6M10 3v6L4.5 19a1.5 1.5 0 0 0 1.3 2h12.4a1.5 1.5 0 0 0 1.3-2L14 9V3"/></svg></div>
                    <h3><fmt:message key="ad.prog.3.title"/></h3>
                    <p><fmt:message key="ad.prog.3.text"/></p>
                </article>
                <article class="cl-card">
                    <div class="cl-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg></div>
                    <h3><fmt:message key="ad.prog.4.title"/></h3>
                    <p><fmt:message key="ad.prog.4.text"/></p>
                </article>
                <article class="cl-card">
                    <div class="cl-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4"/></svg></div>
                    <h3><fmt:message key="ad.prog.5.title"/></h3>
                    <p><fmt:message key="ad.prog.5.text"/></p>
                </article>
                <article class="cl-card">
                    <div class="cl-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M7 7h13l-4-4M17 17H4l4 4"/></svg></div>
                    <h3><fmt:message key="ad.prog.6.title"/></h3>
                    <p><fmt:message key="ad.prog.6.text"/></p>
                </article>
            </div>
        </section>
        <section class="cl-split cl-split-reverse" data-animate>
            <div class="cl-split-media">
                <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-reading-group.jpg" alt="<fmt:message key="ad.cn.alt"/>">
            </div>
            <div class="cl-split-text">
                <span class="cl-label"><fmt:message key="ad.cn.label"/></span>
                <h2><fmt:message key="ad.cn.title1"/> <span><fmt:message key="ad.cn.title2"/></span></h2>
                <p><fmt:message key="ad.cn.text"/></p>
                <ul class="cl-list">
                    <li><fmt:message key="ad.cn.li1"/></li>
                    <li><fmt:message key="ad.cn.li2"/></li>
                    <li><fmt:message key="ad.cn.li3"/></li>
                </ul>
            </div>
        </section>
        <section class="cl-section" id="apply" data-animate>
            <div class="cl-heading">
                <span class="cl-label"><fmt:message key="ad.apply.label"/></span>
                <h2><fmt:message key="ad.apply.title1"/> <span><fmt:message key="ad.apply.title2"/></span></h2>
            </div>
            <ol class="cl-timeline ar-steps">
                <li>
                    <span class="cl-month"><fmt:message key="ad.step1.label"/></span>
                    <h3><fmt:message key="ad.step1.title"/></h3>
                    <p><fmt:message key="ad.step1.text"/></p>
                </li>
                <li>
                    <span class="cl-month"><fmt:message key="ad.step2.label"/></span>
                    <h3><fmt:message key="ad.step2.title"/></h3>
                    <p><fmt:message key="ad.step2.text"/></p>
                </li>
                <li>
                    <span class="cl-month"><fmt:message key="ad.step3.label"/></span>
                    <h3><fmt:message key="ad.step3.title"/></h3>
                    <p><fmt:message key="ad.step3.text"/></p>
                </li>
                <li>
                    <span class="cl-month"><fmt:message key="ad.step4.label"/></span>
                    <h3><fmt:message key="ad.step4.title"/></h3>
                    <p><fmt:message key="ad.step4.text"/></p>
                </li>
            </ol>
            <div class="ar-actions">
                <a href="https://sdust.at0086.cn/student" class="ar-btn" target="_blank" rel="noopener"><fmt:message key="ad.apply.online"/> <span>→</span></a>
                <a href="http://cie.sdust.edu.cn/" class="ar-link" target="_blank" rel="noopener"><fmt:message key="ad.apply.cie"/></a>
            </div>
        </section>
        <section class="cl-split" data-animate>
            <div class="cl-split-media">
                <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-main-gate.jpg" alt="<fmt:message key="ad.cn2.alt"/>">
            </div>
            <div class="cl-split-text">
                <span class="cl-label"><fmt:message key="ad.domestic.label"/></span>
                <h2><fmt:message key="ad.domestic.title1"/> <span><fmt:message key="ad.domestic.title2"/></span></h2>
                <p><fmt:message key="ad.domestic.text"/></p>
            </div>
        </section>
        <section class="cl-section" id="contact-admissions" data-animate>
            <div class="cl-heading">
                <span class="cl-label"><fmt:message key="ad.contact.label"/></span>
                <h2><fmt:message key="ad.contact.title1"/> <span><fmt:message key="ad.contact.title2"/></span></h2>
            </div>
            <div class="ar-contact">
                <div><span><fmt:message key="ad.contact.office"/></span><p><fmt:message key="ad.contact.officev"/></p></div>
                <div><span><fmt:message key="ad.contact.address"/></span><p><fmt:message key="ad.contact.addressv"/></p></div>
                <div><span><fmt:message key="ad.contact.email"/></span><p><a href="mailto:admission@sdust.edu.cn">admission@sdust.edu.cn</a></p></div>
                <div><span><fmt:message key="ad.contact.phone"/></span><p><a href="tel:+8653286057717">+86 532 8605 7717</a></p></div>
                <div><span><fmt:message key="ad.contact.fax"/></span><p>+86 532 8605 7187</p></div>
                <div><span><fmt:message key="ad.contact.web"/></span><p><a href="http://cie.sdust.edu.cn/" target="_blank" rel="noopener">cie.sdust.edu.cn</a></p></div>
            </div>
        </section>

        <section id="cta" data-animate>
            <div class="lefts">
                <h1><fmt:message key="cta.title"/></h1>
                <p><fmt:message key="cta.text"/></p>
            </div>
            <a href="${pageContext.request.contextPath}/admissions#apply" class="btn-primary"><fmt:message key="cta.apply"/> <span>→</span></a>
        </section>
    </div>

    <jsp:include page="/WEB-INF/views/public/partials/footer.jsp"/>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
