<%@ tag pageEncoding="UTF-8" %>
<%@ attribute name="item" required="true" type="edu.sdust.model.Announcement" %>
<%@ attribute name="owner" type="java.lang.Boolean" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<article class="an-item" data-id="${item.id()}" data-category="${item.category()}" data-date="${item.isoDate()}">
    <div class="an-top">
        <span class="an-cat ${item.category()}">${item.categoryText(tx)}</span>
        <c:if test="${owner}">
            <span class="an-to"><fmt:message key="an.to"><fmt:param value="${item.audienceText(tx)}"/></fmt:message></span>
        </c:if>
        <time class="an-date" datetime="${item.isoDate()}">${item.dateText(tx)}</time>
    </div>
    <h2 class="an-title"><c:out value="${item.title()}"/></h2>
    <p class="an-from"><c:out value="${item.fromText()}"/></p>
    <p class="an-excerpt"><c:out value="${item.summary()}"/></p>
    <div class="an-body">
        <p class="an-text"><c:out value="${item.body()}"/></p>
    </div>
    <div class="an-actions">
        <button type="button" class="an-toggle" aria-expanded="false"><span><fmt:message key="js.an.more"/></span><svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="m6 9 6 6 6-6"/></svg></button>
        <c:if test="${owner}">
            <button type="button" class="an-delete"><fmt:message key="js.an.delete"/></button>
        </c:if>
    </div>
</article>
