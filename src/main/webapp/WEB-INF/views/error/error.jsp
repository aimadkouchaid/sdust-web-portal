<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="code" value="${empty requestScope['jakarta.servlet.error.status_code'] ? 500 : requestScope['jakarta.servlet.error.status_code']}"/>
<c:set var="textKey" value="error.${code == 404 ? 404 : 'other'}"/>
<!DOCTYPE html>
<html lang="${htmlLang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="error.heading"/> ${code} - <fmt:message key="site.name"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/error.css">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/favicon.png" type="image/x-icon">
</head>
<body>
    <div class="error-container" data-code="${code}">
        <div class="error-content">
            <h1><fmt:message key="error.heading"/> ${code}</h1>
            <p><fmt:message key="${textKey}"/></p>
            <a href="${pageContext.request.contextPath}/home" class="academic-btn"><fmt:message key="error.back"/> <span>→</span></a>
        </div>
    </div>
</body>
</html>
