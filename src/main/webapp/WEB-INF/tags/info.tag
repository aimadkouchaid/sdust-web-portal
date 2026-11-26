<%@ tag pageEncoding="UTF-8" %>
<%@ attribute name="field" required="true" %>
<%@ attribute name="labelKey" required="true" %>
<%@ attribute name="value" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:message key="profile.notset" var="notSet"/>
<div class="input-group">
    <label for="${field}"><fmt:message key="${labelKey}"/></label>
    <input type="text" id="${field}" value="${empty value ? notSet : fn:escapeXml(value)}" disabled>
</div>
