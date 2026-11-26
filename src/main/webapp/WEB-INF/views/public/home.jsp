<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="${htmlLang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="home.title"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/favicon.png" type="image/x-icon">
</head>
<body>
    <header class="hero-header">

    <jsp:include page="/WEB-INF/views/public/partials/navbar.jsp">
        <jsp:param name="active" value="home"/>
    </jsp:include>

    <section class="hero" data-animate>
        <div class="hero-content">

            <span class="hero-label">
                <fmt:message key="home.hero.label"/>
            </span>

            <h1>
                <fmt:message key="home.hero.title1"/>
                <span><fmt:message key="home.hero.title2"/></span>
            </h1>

            <p>
                <fmt:message key="home.hero.text"/>
            </p>

            <a href="${pageContext.request.contextPath}/campuslife" class="hero-btn">
                <fmt:message key="home.hero.btn"/> <span>→</span>
            </a>

        </div>
    </section>
    
    <div class="hero-wave">
        <svg viewBox="0 0 1440 160" preserveAspectRatio="none" xmlns="http://www.w3.org/2000/svg"><path d="M0 0 L80 72 L160 5 L245 65 L330 0 L415 76 L500 8 L585 63 L670 0 L755 74 L840 5 L925 65 L1010 0 L1095 73 L1180 7 L1265 62 L1350 0 L1440 70 L1440 160 L0 160 Z" fill="white"/></svg>
    </div>
    <div class="hero-wave wave-2">
        <svg viewBox="0 0 1440 160" preserveAspectRatio="none" xmlns="http://www.w3.org/2000/svg"><path d="M0 0 L80 72 L160 5 L245 65 L330 0 L415 76 L500 8 L585 63 L670 0 L755 74 L840 5 L925 65 L1010 0 L1095 73 L1180 7 L1265 62 L1350 0 L1440 70 L1440 160 L0 160 Z" fill="#004a9f58"/></svg>
    </div>
    <div class="hero-wave wave-3">
        <svg viewBox="0 0 1440 160" preserveAspectRatio="none" xmlns="http://www.w3.org/2000/svg"><path d="M0 0 L80 72 L160 5 L245 65 L330 0 L415 76 L500 8 L585 63 L670 0 L755 74 L840 5 L925 65 L1010 0 L1095 73 L1180 7 L1265 62 L1350 0 L1440 70 L1440 160 L0 160 Z" fill="white"/></svg>
    </div>

</header>

    <main>
        <section id="uni-data">
            <div class="dataCard">
                <h2><fmt:message key="home.stats.founded"/></h2>
                <h1 class="datanum" data-target="1951">1951</h1>
            </div>
            <div class="dataCard">
                <h2><fmt:message key="home.stats.students"/></h2>
                <h1 class="datanum" data-target="40000">+40,000</h1>
            </div>
            <div class="dataCard">
                <h2><fmt:message key="home.stats.programs"/></h2>
                <h1 class="datanum" data-target="70">+70</h1>
            </div>
            <div class="dataCard">
                <h2><fmt:message key="home.stats.campuses"/></h2>
                <h1 class="datanum" data-target="3">3</h1>
            </div>
            <div class="dataCard">
                <h2><fmt:message key="home.stats.international"/></h2>
                <h1 class="datanum" data-target="1500">1500</h1>
            </div>
        </section>
        <section id="latest-news">

            <div class="news-side news-side-left">
                <div class="news-feed feed-down">
                    <div class="news-track">
                        <a href="${pageContext.request.contextPath}/news-announcements#news-1" class="news-card">
                            <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-library.jpg" alt="<fmt:message key="news.tag.campus"/>">
                            <div class="news-info">
                                <span class="news-tag"><fmt:message key="news.tag.campus"/></span>
                                <h3><fmt:message key="news.1"/></h3>
                                <fmt:parseDate value="2026-11-18" pattern="yyyy-MM-dd" var="d"/><time datetime="2026-11-18"><fmt:formatDate value="${d}" dateStyle="medium"/></time>
                            </div>
                        </a>
                        <a href="${pageContext.request.contextPath}/news-announcements#news-2" class="news-card">
                            <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-red-building.jpg" alt="<fmt:message key="news.tag.research"/>">
                            <div class="news-info">
                                <span class="news-tag"><fmt:message key="news.tag.research"/></span>
                                <h3><fmt:message key="news.2"/></h3>
                                <fmt:parseDate value="2026-11-12" pattern="yyyy-MM-dd" var="d"/><time datetime="2026-11-12"><fmt:formatDate value="${d}" dateStyle="medium"/></time>
                            </div>
                        </a>
                        <a href="${pageContext.request.contextPath}/news-announcements#news-3" class="news-card">
                            <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-students-lawn.jpg" alt="<fmt:message key="news.tag.international"/>">
                            <div class="news-info">
                                <span class="news-tag"><fmt:message key="news.tag.international"/></span>
                                <h3><fmt:message key="news.3"/></h3>
                                <fmt:parseDate value="2026-11-05" pattern="yyyy-MM-dd" var="d"/><time datetime="2026-11-05"><fmt:formatDate value="${d}" dateStyle="medium"/></time>
                            </div>
                        </a>
                    </div>
                </div>
                <div class="news-feed feed-up">
                    <div class="news-track">
                        <a href="${pageContext.request.contextPath}/news-announcements#news-4" class="news-card">
                            <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-canal-building.jpg" alt="<fmt:message key="news.tag.academics"/>">
                            <div class="news-info">
                                <span class="news-tag"><fmt:message key="news.tag.academics"/></span>
                                <h3><fmt:message key="news.4"/></h3>
                                <fmt:parseDate value="2026-10-29" pattern="yyyy-MM-dd" var="d"/><time datetime="2026-10-29"><fmt:formatDate value="${d}" dateStyle="medium"/></time>
                            </div>
                        </a>
                        <a href="${pageContext.request.contextPath}/news-announcements#news-5" class="news-card">
                            <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-canal-sky.jpg" alt="<fmt:message key="news.tag.events"/>">
                            <div class="news-info">
                                <span class="news-tag"><fmt:message key="news.tag.events"/></span>
                                <h3><fmt:message key="news.5"/></h3>
                                <fmt:parseDate value="2026-11-16" pattern="yyyy-MM-dd" var="d"/><time datetime="2026-11-16"><fmt:formatDate value="${d}" dateStyle="medium"/></time>
                            </div>
                        </a>
                        <a href="${pageContext.request.contextPath}/news-announcements#news-6" class="news-card">
                            <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-student-reading.jpg" alt="<fmt:message key="news.tag.student"/>">
                            <div class="news-info">
                                <span class="news-tag"><fmt:message key="news.tag.student"/></span>
                                <h3><fmt:message key="news.6"/></h3>
                                <fmt:parseDate value="2026-11-02" pattern="yyyy-MM-dd" var="d"/><time datetime="2026-11-02"><fmt:formatDate value="${d}" dateStyle="medium"/></time>
                            </div>
                        </a>
                    </div>
                </div>
            </div>

            <div class="news-heading">
                <span class="news-label"><fmt:message key="home.news.label"/></span>
                <h1><fmt:message key="home.news.title1"/> <span><fmt:message key="home.news.title2"/></span></h1>
                <div class="news-divider"></div>
                <p><fmt:message key="home.news.text"/></p>
                <a href="${pageContext.request.contextPath}/news-announcements" class="news-btn"><fmt:message key="home.news.btn"/> <span>→</span></a>
            </div>

            <div class="news-side news-side-right">
                <div class="news-feed feed-down">
                    <div class="news-track">
                        <a href="${pageContext.request.contextPath}/news-announcements#news-7" class="news-card">
                            <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-ginkgo.jpg" alt="<fmt:message key="news.tag.campus"/>">
                            <div class="news-info">
                                <span class="news-tag"><fmt:message key="news.tag.campus"/></span>
                                <h3><fmt:message key="news.7"/></h3>
                                <fmt:parseDate value="2026-11-14" pattern="yyyy-MM-dd" var="d"/><time datetime="2026-11-14"><fmt:formatDate value="${d}" dateStyle="medium"/></time>
                            </div>
                        </a>
                        <a href="${pageContext.request.contextPath}/news-announcements#news-8" class="news-card">
                            <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-waterside.jpg" alt="<fmt:message key="news.tag.academics"/>">
                            <div class="news-info">
                                <span class="news-tag"><fmt:message key="news.tag.academics"/></span>
                                <h3><fmt:message key="news.8"/></h3>
                                <fmt:parseDate value="2026-11-07" pattern="yyyy-MM-dd" var="d"/><time datetime="2026-11-07"><fmt:formatDate value="${d}" dateStyle="medium"/></time>
                            </div>
                        </a>
                        <a href="${pageContext.request.contextPath}/news-announcements#news-9" class="news-card">
                            <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-lake.jpg" alt="<fmt:message key="news.tag.alumni"/>">
                            <div class="news-info">
                                <span class="news-tag"><fmt:message key="news.tag.alumni"/></span>
                                <h3><fmt:message key="news.9"/></h3>
                                <fmt:parseDate value="2026-10-30" pattern="yyyy-MM-dd" var="d"/><time datetime="2026-10-30"><fmt:formatDate value="${d}" dateStyle="medium"/></time>
                            </div>
                        </a>
                    </div>
                </div>
                <div class="news-feed feed-up">
                    <div class="news-track">
                        <a href="${pageContext.request.contextPath}/news-announcements#news-10" class="news-card">
                            <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-reading-group.jpg" alt="<fmt:message key="news.tag.international"/>">
                            <div class="news-info">
                                <span class="news-tag"><fmt:message key="news.tag.international"/></span>
                                <h3><fmt:message key="news.10"/></h3>
                                <fmt:parseDate value="2026-11-11" pattern="yyyy-MM-dd" var="d"/><time datetime="2026-11-11"><fmt:formatDate value="${d}" dateStyle="medium"/></time>
                            </div>
                        </a>
                        <a href="${pageContext.request.contextPath}/news-announcements#news-11" class="news-card">
                            <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-panorama.jpg" alt="<fmt:message key="news.tag.events"/>">
                            <div class="news-info">
                                <span class="news-tag"><fmt:message key="news.tag.events"/></span>
                                <h3><fmt:message key="news.11"/></h3>
                                <fmt:parseDate value="2026-11-03" pattern="yyyy-MM-dd" var="d"/><time datetime="2026-11-03"><fmt:formatDate value="${d}" dateStyle="medium"/></time>
                            </div>
                        </a>
                        <a href="${pageContext.request.contextPath}/news-announcements#news-12" class="news-card">
                            <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-pavilion-lake.jpg" alt="<fmt:message key="news.tag.research"/>">
                            <div class="news-info">
                                <span class="news-tag"><fmt:message key="news.tag.research"/></span>
                                <h3><fmt:message key="news.12"/></h3>
                                <fmt:parseDate value="2026-10-27" pattern="yyyy-MM-dd" var="d"/><time datetime="2026-10-27"><fmt:formatDate value="${d}" dateStyle="medium"/></time>
                            </div>
                        </a>
                    </div>
                </div>
            </div>

        </section>
        <section id="campus-video" aria-label="<fmt:message key="home.video.aria"/>" data-animate>
            <div class="vdcontainer">
                <video class="vd-media" autoplay muted loop playsinline preload="metadata"
                       poster="${pageContext.request.contextPath}/assets/campus-aerial.jpg" aria-hidden="true">
                    <source src="${pageContext.request.contextPath}/assets/campus-video.mp4" type="video/mp4">
                </video>

                <div class="vd-overlay">
                    <span class="vd-label"><fmt:message key="home.video.label"/></span>
                    <h2><fmt:message key="home.video.title1"/> <span><fmt:message key="home.video.title2"/></span></h2>
                    <p><fmt:message key="home.video.text"/></p>
                    <a href="${pageContext.request.contextPath}/campuslife" class="vd-btn"><fmt:message key="home.video.btn"/> <span>→</span></a>
                </div>
            </div>
        </section>
        <section id="about-us" data-animate>
            <div class="album">
                <img src="${pageContext.request.contextPath}/assets/campus-spring-avenue.jpg" alt="<fmt:message key="home.about.alt"/>">
            </div>
            <div class="aboutusinfo">
                <h1><fmt:message key="home.about.title1"/> <strong><fmt:message key="home.about.title2"/></strong></h1>
                <p>
                    <fmt:message key="home.about.text"/>
                </p>
                <a href="${pageContext.request.contextPath}/academics-research" class="academic-btn"><fmt:message key="home.about.btn"/> <span>→</span></a>
            </div>
        </section>
        <section id="cta" data-animate>
            <div class="lefts">
                <h1><fmt:message key="home.cta.title"/></h1>
                <p><fmt:message key="home.cta.text"/></p>
            </div>
            <a href="${pageContext.request.contextPath}/admissions" class="btn-primary"><fmt:message key="cta.apply"/> <span>→</span></a>
        </section>

    </main>

    <jsp:include page="/WEB-INF/views/public/partials/footer.jsp"/>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
