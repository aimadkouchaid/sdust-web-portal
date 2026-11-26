<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="${htmlLang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="academics.title"/> - <fmt:message key="site.name"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/favicon.png" type="image/x-icon">
</head>
<body>
    <header class="hero-header" style="min-height: auto;background-position: top;overflow: visible;">
        <jsp:include page="/WEB-INF/views/public/partials/navbar.jsp">
            <jsp:param name="active" value="academics"/>
        </jsp:include>
    </header>

    <div class="page-container">
        <h1 class="page-title"><fmt:message key="academics.title1"/> <Strong><fmt:message key="academics.title2"/></Strong></h1>

        <section class="cl-section" data-animate>
            <div class="ar-stats">
                <div class="ar-stat"><strong>73</strong><span><fmt:message key="ar.num.1"/></span></div>
                <div class="ar-stat"><strong>11</strong><span><fmt:message key="ar.num.2"/></span></div>
                <div class="ar-stat"><strong>33</strong><span><fmt:message key="ar.num.3"/></span></div>
                <div class="ar-stat"><strong>23</strong><span><fmt:message key="ar.num.4"/></span></div>
                <div class="ar-stat"><strong>10</strong><span><fmt:message key="ar.num.5"/></span></div>
                <div class="ar-stat"><strong>8</strong><span><fmt:message key="ar.num.6"/></span></div>
            </div>
        </section>
        <section class="cl-section" data-animate>
            <div class="cl-heading">
                <span class="cl-label"><fmt:message key="ar.col.label"/></span>
                <h2><fmt:message key="ar.col.title1"/> <span><fmt:message key="ar.col.title2"/></span></h2>
            </div>
            <p class="ar-lead"><fmt:message key="ar.col.text"/></p>
            <ul class="ar-colleges">
                <li><fmt:message key="ar.col.1"/></li>
                <li><fmt:message key="ar.col.2"/></li>
                <li><fmt:message key="ar.col.3"/></li>
                <li><fmt:message key="ar.col.4"/></li>
                <li><fmt:message key="ar.col.5"/></li>
                <li><fmt:message key="ar.col.6"/></li>
                <li><fmt:message key="ar.col.7"/></li>
                <li><fmt:message key="ar.col.8"/></li>
                <li><fmt:message key="ar.col.9"/></li>
                <li><fmt:message key="ar.col.10"/></li>
                <li><fmt:message key="ar.col.11"/></li>
                <li><fmt:message key="ar.col.12"/></li>
                <li><fmt:message key="ar.col.13"/></li>
                <li><fmt:message key="ar.col.14"/></li>
                <li><fmt:message key="ar.col.15"/></li>
                <li><fmt:message key="ar.col.16"/></li>
                <li><fmt:message key="ar.col.17"/></li>
                <li><fmt:message key="ar.col.18"/></li>
                <li><fmt:message key="ar.col.19"/></li>
                <li><fmt:message key="ar.col.20"/></li>
                <li><fmt:message key="ar.col.21"/></li>
            </ul>
        </section>
        <section class="cl-split" data-animate>
            <div class="cl-split-media">
                <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-willow-path.jpg" alt="<fmt:message key="ar.teach.alt"/>">
            </div>
            <div class="cl-split-text">
                <span class="cl-label"><fmt:message key="ar.teach.label"/></span>
                <h2><fmt:message key="ar.teach.title1"/> <span><fmt:message key="ar.teach.title2"/></span></h2>
                <p><fmt:message key="ar.teach.text"/></p>
                <ul class="cl-list">
                    <li><fmt:message key="ar.teach.li1"/></li>
                    <li><fmt:message key="ar.teach.li2"/></li>
                    <li><fmt:message key="ar.teach.li3"/></li>
                    <li><fmt:message key="ar.teach.li4"/></li>
                </ul>
            </div>
        </section>
        <section class="cl-section" data-animate>
            <div class="cl-heading">
                <span class="cl-label"><fmt:message key="ar.fac.label"/></span>
                <h2><fmt:message key="ar.fac.title1"/> <span><fmt:message key="ar.fac.title2"/></span></h2>
            </div>
            <div class="ar-stats">
                <div class="ar-stat"><strong>3,300+</strong><span><fmt:message key="ar.fac.num.1"/></span></div>
                <div class="ar-stat"><strong>618</strong><span><fmt:message key="ar.fac.num.2"/></span></div>
                <div class="ar-stat"><strong>3</strong><span><fmt:message key="ar.fac.num.3"/></span></div>
                <div class="ar-stat"><strong>57</strong><span><fmt:message key="ar.fac.num.4"/></span></div>
                <div class="ar-stat"><strong>92</strong><span><fmt:message key="ar.fac.num.5"/></span></div>
                <div class="ar-stat"><strong>44</strong><span><fmt:message key="ar.fac.num.6"/></span></div>
            </div>
        </section>
        <section class="cl-section" data-animate>
            <div class="cl-heading">
                <span class="cl-label"><fmt:message key="ar.res.label"/></span>
                <h2><fmt:message key="ar.res.title1"/> <span><fmt:message key="ar.res.title2"/></span></h2>
            </div>
            <p class="ar-lead"><fmt:message key="ar.res.text"/></p>
            <div class="cl-grid">
                <article class="cl-card">
                    <div class="cl-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M14 4c3 0 6 1.5 7 4-3-1-6-1-9 1M14 4 3 21M10 9l5 5"/></svg></div>
                    <h3><fmt:message key="ar.lab.1.title"/></h3>
                    <p><fmt:message key="ar.lab.1.text"/></p>
                </article>
                <article class="cl-card">
                    <div class="cl-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="5" y="8" width="14" height="11" rx="2"/><path d="M12 4v4M9 13h.01M15 13h.01M9 16h6"/></svg></div>
                    <h3><fmt:message key="ar.lab.2.title"/></h3>
                    <p><fmt:message key="ar.lab.2.text"/></p>
                </article>
                <article class="cl-card">
                    <div class="cl-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M9 3h6M10 3v6L4.5 19a1.5 1.5 0 0 0 1.3 2h12.4a1.5 1.5 0 0 0 1.3-2L14 9V3"/></svg></div>
                    <h3><fmt:message key="ar.lab.3.title"/></h3>
                    <p><fmt:message key="ar.lab.3.text"/></p>
                </article>
                <article class="cl-card">
                    <div class="cl-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M9 4 3 6v14l6-2 6 2 6-2V4l-6 2-6-2zM9 4v14M15 6v14"/></svg></div>
                    <h3><fmt:message key="ar.lab.4.title"/></h3>
                    <p><fmt:message key="ar.lab.4.text"/></p>
                </article>
                <article class="cl-card">
                    <div class="cl-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.7 1.7 0 0 0 .3 1.8l.1.1a2 2 0 1 1-2.8 2.8l-.1-.1a1.7 1.7 0 0 0-1.8-.3 1.7 1.7 0 0 0-1 1.5V21a2 2 0 1 1-4 0v-.1a1.7 1.7 0 0 0-1.1-1.5 1.7 1.7 0 0 0-1.8.3l-.1.1a2 2 0 1 1-2.8-2.8l.1-.1a1.7 1.7 0 0 0 .3-1.8 1.7 1.7 0 0 0-1.5-1H3a2 2 0 1 1 0-4h.1a1.7 1.7 0 0 0 1.5-1.1 1.7 1.7 0 0 0-.3-1.8l-.1-.1a2 2 0 1 1 2.8-2.8l.1.1a1.7 1.7 0 0 0 1.8.3H9a1.7 1.7 0 0 0 1-1.5V3a2 2 0 1 1 4 0v.1a1.7 1.7 0 0 0 1 1.5 1.7 1.7 0 0 0 1.8-.3l.1-.1a2 2 0 1 1 2.8 2.8l-.1.1a1.7 1.7 0 0 0-.3 1.8V9a1.7 1.7 0 0 0 1.5 1H21a2 2 0 1 1 0 4h-.1a1.7 1.7 0 0 0-1.5 1z"/></svg></div>
                    <h3><fmt:message key="ar.lab.5.title"/></h3>
                    <p><fmt:message key="ar.lab.5.text"/></p>
                </article>
                <article class="cl-card">
                    <div class="cl-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3c2.5 2.7 3.8 5.7 3.8 9s-1.3 6.3-3.8 9c-2.5-2.7-3.8-5.7-3.8-9s1.3-6.3 3.8-9z"/></svg></div>
                    <h3><fmt:message key="ar.lab.6.title"/></h3>
                    <p><fmt:message key="ar.lab.6.text"/></p>
                </article>
            </div>
        </section>
        <section class="cl-section" data-animate>
            <div class="cl-heading">
                <span class="cl-label"><fmt:message key="ar.out.label"/></span>
                <h2><fmt:message key="ar.out.title1"/> <span><fmt:message key="ar.out.title2"/></span></h2>
            </div>
            <div class="ar-stats">
                <div class="ar-stat"><strong>717</strong><span><fmt:message key="ar.out.num.1"/></span></div>
                <div class="ar-stat"><strong>1,188</strong><span><fmt:message key="ar.out.num.2"/></span></div>
                <div class="ar-stat"><strong>236</strong><span><fmt:message key="ar.out.num.3"/></span></div>
                <div class="ar-stat"><strong>6</strong><span><fmt:message key="ar.out.num.4"/></span></div>
                <div class="ar-stat"><strong>3,490</strong><span><fmt:message key="ar.out.num.5"/></span></div>
            </div>
            <p class="ar-note"><fmt:message key="ar.out.note"/></p>
        </section>

        <section id="cta" data-animate>
            <div class="lefts">
                <h1><fmt:message key="cta.title"/></h1>
                <p><fmt:message key="cta.text"/></p>
            </div>
            <a href="${pageContext.request.contextPath}/admissions" class="btn-primary"><fmt:message key="cta.apply"/> <span>→</span></a>
        </section>
    </div>

    <jsp:include page="/WEB-INF/views/public/partials/footer.jsp"/>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
