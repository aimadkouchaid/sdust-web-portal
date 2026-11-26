<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<h1 class="pgtitle"><fmt:message key="dash.nav.profile"/></h1>
<c:choose>
    <c:when test="${profileError}">
        <p class="form-status error" role="status"><fmt:message key="profile.error"/></p>
    </c:when>
    <c:otherwise>
        <c:if test="${not empty profile.gender}"><fmt:message key="gender.${fn:toLowerCase(profile.gender)}" var="genderText"/></c:if>
        <div class="basicinfo">
            <t:info field="pi-name" labelKey="profile.name" value="${profile.name}"/>
            <t:info field="pi-gender" labelKey="profile.gender" value="${genderText}"/>
            <c:choose>
                <c:when test="${sessionScope.user.role == 'student'}">
                    <t:info field="pi-id" labelKey="profile.studentid" value="${sessionScope.user.id}"/>
                    <t:info field="pi-college" labelKey="profile.college" value="${profile.college}"/>
                    <t:info field="pi-major" labelKey="profile.major" value="${profile.major}"/>
                    <t:info field="pi-class" labelKey="profile.class" value="${profile.className}"/>
                    <t:info field="pi-year" labelKey="profile.year" value="${profile.enrollmentYear}"/>
                    <t:info field="pi-campus" labelKey="profile.campus" value="${profile.campus}"/>
                    <t:info field="pi-counselor" labelKey="profile.counselor" value="${profile.counselor}"/>
                </c:when>
                <c:otherwise>
                    <t:info field="pi-id" labelKey="profile.staffid" value="${sessionScope.user.id}"/>
                    <t:info field="pi-role" labelKey="profile.role" value="${tx.get('dash.role.'.concat(sessionScope.user.role))}"/>
                    <t:info field="pi-college" labelKey="profile.college" value="${profile.college}"/>
                    <t:info field="pi-title" labelKey="profile.title" value="${profile.title}"/>
                    <t:info field="pi-office" labelKey="profile.office" value="${profile.office}"/>
                </c:otherwise>
            </c:choose>
        </div>
    </c:otherwise>
</c:choose>
<h1 class="pgtitle"><fmt:message key="profile.contact"/></h1>
<form action="${pageContext.request.contextPath}/dashboard/profile/contact" method="post" class="contactinfo" novalidate>
    <input type="hidden" name="csrf" value="${sessionScope.csrf}">
    <div class="input-group">
        <label for="email"><fmt:message key="profile.email"/></label>
        <input type="email" name="email" id="email" value="${fn:escapeXml(contact.email)}" placeholder="<fmt:message key="profile.email.ph"/>" autocomplete="email" aria-describedby="email-error" required>
        <p class="field-error" id="email-error" aria-live="polite"></p>
    </div>
    <div class="input-group">
        <label for="phonenumber"><fmt:message key="profile.phone"/></label>
        <input type="tel" name="phonenumber" id="phonenumber" inputmode="tel" value="${fn:escapeXml(contact.phone)}" placeholder="<fmt:message key="profile.phone.ph"/>" autocomplete="tel" maxlength="16" aria-describedby="phonenumber-error" required>
        <p class="field-error" id="phonenumber-error" aria-live="polite"></p>
    </div>
    <p class="form-status${contactError ? ' error' : ''}" role="status"><c:if test="${contactError}"><fmt:message key="profile.contact.error"/></c:if></p>
    <button type="submit"><fmt:message key="profile.save"/></button>
</form>
<h1 class="pgtitle"><fmt:message key="profile.changepass"/></h1>
<form action="${pageContext.request.contextPath}/dashboard/profile/password" method="post" class="changepass" novalidate>
    <input type="hidden" name="csrf" value="${sessionScope.csrf}">
    <div class="input-group">
        <label for="currentpass"><fmt:message key="profile.current"/></label>
        <div class="pass-field">
            <input type="password" name="currentpass" id="currentpass" placeholder="<fmt:message key="profile.current.ph"/>" autocomplete="current-password" aria-describedby="currentpass-error" required>
            <button type="button" class="pass-toggle" aria-controls="currentpass" aria-pressed="false" aria-label="<fmt:message key="profile.showpass"/>" data-show="<fmt:message key="profile.showpass"/>" data-hide="<fmt:message key="profile.hidepass"/>"><svg class="eye-show" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="3"/></svg><svg class="eye-hide" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 3l18 18"/><path d="M10.6 5.1A10.7 10.7 0 0 1 12 5c6.5 0 10 7 10 7a17.6 17.6 0 0 1-3.2 4.2M6.6 6.6C3.8 8.4 2 12 2 12s3.5 7 10 7a9.7 9.7 0 0 0 5.4-1.6"/><path d="M9.9 9.9a3 3 0 0 0 4.2 4.2"/></svg></button>
        </div>
        <p class="field-error" id="currentpass-error" aria-live="polite"></p>
    </div>
    <div class="input-group">
        <label for="newpass"><fmt:message key="profile.new"/></label>
        <div class="pass-field">
            <input type="password" name="newpass" id="newpass" placeholder="<fmt:message key="profile.new.ph"/>" autocomplete="new-password" aria-describedby="newpass-rules newpass-error" required>
            <button type="button" class="pass-toggle" aria-controls="newpass" aria-pressed="false" aria-label="<fmt:message key="profile.showpass"/>" data-show="<fmt:message key="profile.showpass"/>" data-hide="<fmt:message key="profile.hidepass"/>"><svg class="eye-show" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="3"/></svg><svg class="eye-hide" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 3l18 18"/><path d="M10.6 5.1A10.7 10.7 0 0 1 12 5c6.5 0 10 7 10 7a17.6 17.6 0 0 1-3.2 4.2M6.6 6.6C3.8 8.4 2 12 2 12s3.5 7 10 7a9.7 9.7 0 0 0 5.4-1.6"/><path d="M9.9 9.9a3 3 0 0 0 4.2 4.2"/></svg></button>
        </div>
        <ul class="pass-rules" id="newpass-rules">
            <li data-rule="length"><fmt:message key="profile.rule.length"/></li>
            <li data-rule="letter"><fmt:message key="profile.rule.letter"/></li>
            <li data-rule="number"><fmt:message key="profile.rule.number"/></li>
            <li data-rule="different"><fmt:message key="profile.rule.different"/></li>
        </ul>
        <p class="field-error" id="newpass-error" aria-live="polite"></p>
    </div>
    <div class="input-group">
        <label for="confirmpass"><fmt:message key="profile.confirm"/></label>
        <div class="pass-field">
            <input type="password" name="confirmpass" id="confirmpass" placeholder="<fmt:message key="profile.confirm.ph"/>" autocomplete="new-password" aria-describedby="confirmpass-error" required>
            <button type="button" class="pass-toggle" aria-controls="confirmpass" aria-pressed="false" aria-label="<fmt:message key="profile.showpass"/>" data-show="<fmt:message key="profile.showpass"/>" data-hide="<fmt:message key="profile.hidepass"/>"><svg class="eye-show" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="3"/></svg><svg class="eye-hide" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 3l18 18"/><path d="M10.6 5.1A10.7 10.7 0 0 1 12 5c6.5 0 10 7 10 7a17.6 17.6 0 0 1-3.2 4.2M6.6 6.6C3.8 8.4 2 12 2 12s3.5 7 10 7a9.7 9.7 0 0 0 5.4-1.6"/><path d="M9.9 9.9a3 3 0 0 0 4.2 4.2"/></svg></button>
        </div>
        <p class="field-error" id="confirmpass-error" aria-live="polite"></p>
    </div>
    <p class="form-status" role="status"></p>
    <button type="submit"><fmt:message key="profile.changepass.btn"/></button>
</form>


