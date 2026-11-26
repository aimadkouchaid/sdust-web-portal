<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="${htmlLang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="news.title"/> - <fmt:message key="site.name"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/favicon.png" type="image/x-icon">
</head>
<body>
    <header class="hero-header" style="min-height: auto;background-position: top;overflow: visible;">
        <jsp:include page="/WEB-INF/views/public/partials/navbar.jsp">
            <jsp:param name="active" value="news"/>
        </jsp:include>
    </header>

    <div class="page-container">
        <h1 class="page-title"><fmt:message key="news.title1"/> <Strong><fmt:message key="news.title2"/></Strong></h1>

        <section class="na-section" id="announcements" data-animate>
            <div class="cl-heading">
                <span class="cl-label"><fmt:message key="news.ann.label"/></span>
                <h2><fmt:message key="news.ann.title1"/> <span><fmt:message key="news.ann.title2"/></span></h2>
                <p class="nw-sub"><fmt:message key="news.ann.intro"/></p>
            </div>
            <c:choose>
                <c:when test="${announcementsError}">
                    <p class="na-empty"><fmt:message key="news.ann.error"/></p>
                </c:when>
                <c:when test="${empty announcements}">
                    <p class="na-empty"><fmt:message key="news.ann.empty"/></p>
                </c:when>
                <c:otherwise>
                    <p class="na-count"><fmt:message key="news.ann.count"><fmt:param value="${fn:length(announcements)}"/></fmt:message></p>
                    <div class="na-list">
                        <c:forEach var="a" items="${announcements}">
                            <article class="na-item">
                                <div class="na-top">
                                    <span class="na-cat ${a.category()}"><fmt:message key="news.ann.cat.${a.category()}"/></span>
                                    <fmt:parseDate value="${a.isoDate()}" pattern="yyyy-MM-dd" var="d"/><time class="na-date" datetime="${a.isoDate()}"><fmt:formatDate value="${d}" dateStyle="medium"/></time>
                                </div>
                                <h2 class="na-title"><c:out value="${a.title()}"/></h2>
                                <p class="na-from"><c:out value="${a.fromText()}"/></p>
                                <p class="na-summary"><c:out value="${a.summary()}"/></p>
                                <details class="na-more">
                                    <summary><fmt:message key="news.ann.more"/></summary>
                                    <p><c:out value="${a.body()}"/></p>
                                </details>
                            </article>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <section class="cl-section nw-section" id="news" data-animate>
            <div class="cl-heading">
                <span class="cl-label"><fmt:message key="news.list.label"/></span>
                <h2><fmt:message key="news.list.title1"/> <span><fmt:message key="news.list.title2"/></span></h2>
            </div>
            <div class="nw-grid">
                <article class="nw-card" id="news-1">
                    <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-library.jpg" alt="">
                    <div class="nw-body">
                        <div class="nw-top">
                            <span class="na-cat"><fmt:message key="news.tag.campus"/></span>
                            <fmt:parseDate value="2026-11-18" pattern="yyyy-MM-dd" var="d"/><time class="na-date" datetime="2026-11-18"><fmt:formatDate value="${d}" dateStyle="medium"/></time>
                        </div>
                        <h3><fmt:message key="news.1"/></h3>
                        <p><fmt:message key="news.1.text"/></p>
                    </div>
                </article>
                <article class="nw-card" id="news-5">
                    <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-canal-sky.jpg" alt="">
                    <div class="nw-body">
                        <div class="nw-top">
                            <span class="na-cat"><fmt:message key="news.tag.events"/></span>
                            <fmt:parseDate value="2026-11-16" pattern="yyyy-MM-dd" var="d"/><time class="na-date" datetime="2026-11-16"><fmt:formatDate value="${d}" dateStyle="medium"/></time>
                        </div>
                        <h3><fmt:message key="news.5"/></h3>
                        <p><fmt:message key="news.5.text"/></p>
                    </div>
                </article>
                <article class="nw-card" id="news-7">
                    <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-ginkgo.jpg" alt="">
                    <div class="nw-body">
                        <div class="nw-top">
                            <span class="na-cat"><fmt:message key="news.tag.campus"/></span>
                            <fmt:parseDate value="2026-11-14" pattern="yyyy-MM-dd" var="d"/><time class="na-date" datetime="2026-11-14"><fmt:formatDate value="${d}" dateStyle="medium"/></time>
                        </div>
                        <h3><fmt:message key="news.7"/></h3>
                        <p><fmt:message key="news.7.text"/></p>
                    </div>
                </article>
                <article class="nw-card" id="news-2">
                    <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-red-building.jpg" alt="">
                    <div class="nw-body">
                        <div class="nw-top">
                            <span class="na-cat"><fmt:message key="news.tag.research"/></span>
                            <fmt:parseDate value="2026-11-12" pattern="yyyy-MM-dd" var="d"/><time class="na-date" datetime="2026-11-12"><fmt:formatDate value="${d}" dateStyle="medium"/></time>
                        </div>
                        <h3><fmt:message key="news.2"/></h3>
                        <p><fmt:message key="news.2.text"/></p>
                    </div>
                </article>
                <article class="nw-card" id="news-10">
                    <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-reading-group.jpg" alt="">
                    <div class="nw-body">
                        <div class="nw-top">
                            <span class="na-cat"><fmt:message key="news.tag.international"/></span>
                            <fmt:parseDate value="2026-11-11" pattern="yyyy-MM-dd" var="d"/><time class="na-date" datetime="2026-11-11"><fmt:formatDate value="${d}" dateStyle="medium"/></time>
                        </div>
                        <h3><fmt:message key="news.10"/></h3>
                        <p><fmt:message key="news.10.text"/></p>
                    </div>
                </article>
                <article class="nw-card" id="news-8">
                    <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-waterside.jpg" alt="">
                    <div class="nw-body">
                        <div class="nw-top">
                            <span class="na-cat"><fmt:message key="news.tag.academics"/></span>
                            <fmt:parseDate value="2026-11-07" pattern="yyyy-MM-dd" var="d"/><time class="na-date" datetime="2026-11-07"><fmt:formatDate value="${d}" dateStyle="medium"/></time>
                        </div>
                        <h3><fmt:message key="news.8"/></h3>
                        <p><fmt:message key="news.8.text"/></p>
                    </div>
                </article>
                <article class="nw-card" id="news-3">
                    <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-students-lawn.jpg" alt="">
                    <div class="nw-body">
                        <div class="nw-top">
                            <span class="na-cat"><fmt:message key="news.tag.international"/></span>
                            <fmt:parseDate value="2026-11-05" pattern="yyyy-MM-dd" var="d"/><time class="na-date" datetime="2026-11-05"><fmt:formatDate value="${d}" dateStyle="medium"/></time>
                        </div>
                        <h3><fmt:message key="news.3"/></h3>
                        <p><fmt:message key="news.3.text"/></p>
                    </div>
                </article>
                <article class="nw-card" id="news-11">
                    <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-panorama.jpg" alt="">
                    <div class="nw-body">
                        <div class="nw-top">
                            <span class="na-cat"><fmt:message key="news.tag.events"/></span>
                            <fmt:parseDate value="2026-11-03" pattern="yyyy-MM-dd" var="d"/><time class="na-date" datetime="2026-11-03"><fmt:formatDate value="${d}" dateStyle="medium"/></time>
                        </div>
                        <h3><fmt:message key="news.11"/></h3>
                        <p><fmt:message key="news.11.text"/></p>
                    </div>
                </article>
                <article class="nw-card" id="news-6">
                    <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-student-reading.jpg" alt="">
                    <div class="nw-body">
                        <div class="nw-top">
                            <span class="na-cat"><fmt:message key="news.tag.student"/></span>
                            <fmt:parseDate value="2026-11-02" pattern="yyyy-MM-dd" var="d"/><time class="na-date" datetime="2026-11-02"><fmt:formatDate value="${d}" dateStyle="medium"/></time>
                        </div>
                        <h3><fmt:message key="news.6"/></h3>
                        <p><fmt:message key="news.6.text"/></p>
                    </div>
                </article>
                <article class="nw-card" id="news-9">
                    <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-lake.jpg" alt="">
                    <div class="nw-body">
                        <div class="nw-top">
                            <span class="na-cat"><fmt:message key="news.tag.alumni"/></span>
                            <fmt:parseDate value="2026-10-30" pattern="yyyy-MM-dd" var="d"/><time class="na-date" datetime="2026-10-30"><fmt:formatDate value="${d}" dateStyle="medium"/></time>
                        </div>
                        <h3><fmt:message key="news.9"/></h3>
                        <p><fmt:message key="news.9.text"/></p>
                    </div>
                </article>
                <article class="nw-card" id="news-4">
                    <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-canal-building.jpg" alt="">
                    <div class="nw-body">
                        <div class="nw-top">
                            <span class="na-cat"><fmt:message key="news.tag.academics"/></span>
                            <fmt:parseDate value="2026-10-29" pattern="yyyy-MM-dd" var="d"/><time class="na-date" datetime="2026-10-29"><fmt:formatDate value="${d}" dateStyle="medium"/></time>
                        </div>
                        <h3><fmt:message key="news.4"/></h3>
                        <p><fmt:message key="news.4.text"/></p>
                    </div>
                </article>
                <article class="nw-card" id="news-12">
                    <img loading="lazy" decoding="async" src="${pageContext.request.contextPath}/assets/campus-pavilion-lake.jpg" alt="">
                    <div class="nw-body">
                        <div class="nw-top">
                            <span class="na-cat"><fmt:message key="news.tag.research"/></span>
                            <fmt:parseDate value="2026-10-27" pattern="yyyy-MM-dd" var="d"/><time class="na-date" datetime="2026-10-27"><fmt:formatDate value="${d}" dateStyle="medium"/></time>
                        </div>
                        <h3><fmt:message key="news.12"/></h3>
                        <p><fmt:message key="news.12.text"/></p>
                    </div>
                </article>
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
