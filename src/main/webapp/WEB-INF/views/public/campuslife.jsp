<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="${htmlLang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="campus.title"/> - <fmt:message key="site.name"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/favicon.png" type="image/x-icon">
</head>
<body>
    <header class="hero-header" style="min-height: auto;background-position: top;overflow: visible;">
        <jsp:include page="/WEB-INF/views/public/partials/navbar.jsp">
            <jsp:param name="active" value="campus"/>
        </jsp:include>
    </header>

    <div class="page-container">
        <h1 class="page-title"><fmt:message key="campus.title1"/> <Strong><fmt:message key="campus.title2"/></Strong></h1>

        <section class="cl-hero" data-animate>
            <img src="${pageContext.request.contextPath}/assets/campus-pavilion-lake.jpg" alt="<fmt:message key="campus.sea.alt"/>">
            <div class="cl-hero-text">
                <span class="cl-label"><fmt:message key="campus.sea.label"/></span>
                <h2><fmt:message key="campus.sea.title1"/> <span><fmt:message key="campus.sea.title2"/></span></h2>
                <p><fmt:message key="campus.sea.p1"/></p>
            </div>
        </section>

        <section class="cl-stats" data-animate>
            <div class="cl-stat"><strong>3</strong><span><fmt:message key="campus.stat.1"/></span></div>
            <div class="cl-stat"><strong>233</strong><span><fmt:message key="campus.stat.2"/></span></div>
            <div class="cl-stat"><strong>40,000+</strong><span><fmt:message key="campus.stat.3"/></span></div>
            <div class="cl-stat"><strong>1,500</strong><span><fmt:message key="campus.stat.4"/></span></div>
        </section>

        <p class="page-intro cl-intro"><fmt:message key="campus.sea.p2"/></p>

        <section class="cl-section" data-animate>
            <div class="cl-heading">
                <span class="cl-label"><fmt:message key="campus.life.label"/></span>
                <h2><fmt:message key="campus.life.title1"/> <span><fmt:message key="campus.life.title2"/></span></h2>
            </div>
            <div class="cl-life">
                <article class="cl-life-card">
                    <div class="cl-life-media">
                        <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-students-lawn.jpg" alt="">
                        <span class="cl-life-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" aria-hidden="true"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5s-3 1.34-3 3 1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5C15 14.17 10.33 13 8 13zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z" fill="currentColor"/></svg></span>
                    </div>
                    <div class="cl-life-body">
                        <h3><fmt:message key="campus.clubs.title"/></h3>
                        <p><fmt:message key="campus.clubs.text"/></p>
                    </div>
                </article>
                <article class="cl-life-card">
                    <div class="cl-life-media">
                        <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-sports.jpg" alt="">
                        <span class="cl-life-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 2a10 10 0 1 0 0 20 10 10 0 0 0 0-20zm1 3.3 1.35-.95a8.01 8.01 0 0 1 4.38 3.34l-.39 1.34-1.35.46L13 5.3zM9.65 4.35 11 5.3l-4 2.89-1.35-.46-.39-1.34a8.07 8.07 0 0 1 4.39-3.34zM7.08 17.11l-1.14.1A7.94 7.94 0 0 1 4 12c0-.12.01-.23.02-.35l1-.73 1.38.48 1.46 4.34-.78 1.37zm7.42 2.48c-.79.26-1.63.41-2.5.41s-1.71-.15-2.5-.41l-.69-1.49.64-1.1h5.11l.64 1.11-.7 1.48zM14.27 15H9.73l-1.35-4.02L12 8.44l3.63 2.54L14.27 15zm3.79 2.21-1.14-.1-.79-1.37 1.46-4.34 1.39-.47 1 .73c.01.11.02.22.02.34 0 1.99-.73 3.81-1.94 5.21z" fill="currentColor"/></svg></span>
                    </div>
                    <div class="cl-life-body">
                        <h3><fmt:message key="campus.sports.title"/></h3>
                        <p><fmt:message key="campus.sports.text"/></p>
                    </div>
                </article>
                <article class="cl-life-card">
                    <div class="cl-life-media">
                        <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-canal-building.jpg" alt="">
                        <span class="cl-life-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" aria-hidden="true"><path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z" fill="currentColor"/></svg></span>
                    </div>
                    <div class="cl-life-body">
                        <h3><fmt:message key="campus.housing.title"/></h3>
                        <p><fmt:message key="campus.housing.text"/></p>
                    </div>
                </article>
                <article class="cl-life-card">
                    <div class="cl-life-media">
                        <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-waterside.jpg" alt="">
                        <span class="cl-life-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" aria-hidden="true"><path d="M11 9H9V2H7v7H5V2H3v7c0 2.12 1.66 3.84 3.75 3.97V22h2.5v-9.03C11.34 12.84 13 11.12 13 9V2h-2v7zm5-3v8h2.5v8H21V2c-2.76 0-5 2.24-5 4z" fill="currentColor"/></svg></span>
                    </div>
                    <div class="cl-life-body">
                        <h3><fmt:message key="campus.dining.title"/></h3>
                        <p><fmt:message key="campus.dining.text"/></p>
                    </div>
                </article>
                <article class="cl-life-card">
                    <div class="cl-life-media">
                        <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-library.jpg" alt="">
                        <span class="cl-life-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" aria-hidden="true"><path d="M21 5c-1.11-.35-2.33-.5-3.5-.5-1.95 0-4.05.4-5.5 1.5-1.45-1.1-3.55-1.5-5.5-1.5S2.45 4.9 1 6v14.65c0 .25.25.5.5.5.1 0 .15-.05.25-.05C3.1 20.45 5.05 20 6.5 20c1.95 0 4.05.4 5.5 1.5 1.35-.85 3.8-1.5 5.5-1.5 1.65 0 3.35.3 4.75 1.05.1.05.15.05.25.05.25 0 .5-.25.5-.5V6c-.6-.45-1.25-.75-2-1zm0 13.5c-1.1-.35-2.3-.5-3.5-.5-1.7 0-4.15.65-5.5 1.5V8c1.35-.85 3.8-1.5 5.5-1.5 1.2 0 2.4.15 3.5.5v11.5z" fill="currentColor"/></svg></span>
                    </div>
                    <div class="cl-life-body">
                        <h3><fmt:message key="campus.library.title"/></h3>
                        <p><fmt:message key="campus.library.text"/></p>
                    </div>
                </article>
                <article class="cl-life-card">
                    <div class="cl-life-media">
                        <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-willow-path.jpg" alt="">
                        <span class="cl-life-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z" fill="currentColor"/></svg></span>
                    </div>
                    <div class="cl-life-body">
                        <h3><fmt:message key="campus.health.title"/></h3>
                        <p><fmt:message key="campus.health.text"/></p>
                    </div>
                </article>
            </div>
        </section>

        <section class="cl-section" data-animate>
            <div class="cl-heading">
                <span class="cl-label"><fmt:message key="campus.pictures.label"/></span>
                <h2><fmt:message key="campus.pictures.title1"/> <span><fmt:message key="campus.pictures.title2"/></span></h2>
            </div>
            <div class="cl-gallery">
                <figure class="cl-photo cl-photo-large">
                    <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-trees.jpg" alt="<fmt:message key="campus.photo1.alt"/>">
                    <figcaption><fmt:message key="campus.photo1.caption"/></figcaption>
                </figure>
                <figure class="cl-photo">
                    <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-red-building.jpg" alt="<fmt:message key="campus.photo2.alt"/>">
                    <figcaption><fmt:message key="campus.photo2.caption"/></figcaption>
                </figure>
                <figure class="cl-photo">
                    <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-spring-avenue.jpg" alt="<fmt:message key="campus.photo3.alt"/>">
                    <figcaption><fmt:message key="campus.photo3.caption"/></figcaption>
                </figure>
                <figure class="cl-photo cl-photo-wide">
                    <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-panorama.jpg" alt="<fmt:message key="campus.photo4.alt"/>">
                    <figcaption><fmt:message key="campus.photo4.caption"/></figcaption>
                </figure>
            </div>
        </section>

        <section class="cl-split cl-split-reverse" data-animate>
            <div class="cl-split-media">
                <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-reading-group.jpg" alt="<fmt:message key="campus.intl.alt"/>">
            </div>
            <div class="cl-split-text">
                <span class="cl-label"><fmt:message key="campus.intl.label"/></span>
                <h2><fmt:message key="campus.intl.title1"/> <span><fmt:message key="campus.intl.title2"/></span></h2>
                <p><fmt:message key="campus.intl.text"/></p>
                <ul class="cl-list">
                    <li><fmt:message key="campus.intl.li1"/></li>
                    <li><fmt:message key="campus.intl.li2"/></li>
                    <li><fmt:message key="campus.intl.li3"/></li>
                    <li><fmt:message key="campus.intl.li4"/></li>
                </ul>
            </div>
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
