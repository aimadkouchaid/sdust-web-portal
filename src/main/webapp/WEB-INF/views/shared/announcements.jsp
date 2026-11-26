<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:choose>
    <c:when test="${announcementsError}">
        <h1 class="pgtitle"><fmt:message key="dash.nav.announcements"/></h1>
        <p class="form-status error" role="status"><fmt:message key="an.error"/></p>
    </c:when>
    <c:otherwise>
        <c:if test="${sessionScope.user.role != 'student'}">
            <h1 class="pgtitle"><fmt:message key="an.post.title"/></h1>
            <form action="${pageContext.request.contextPath}/dashboard/announcements/post" method="post" class="an-form" novalidate>
                <input type="hidden" name="csrf" value="${sessionScope.csrf}">
                <div class="input-line">
                    <div class="input-group">
                        <label for="ancategory"><fmt:message key="an.f.category"/></label>
                        <select name="ancategory" id="ancategory" aria-describedby="ancategory-error">
                            <option value="academic"><fmt:message key="an.cat.academic"/></option>
                            <option value="exams"><fmt:message key="an.cat.exams"/></option>
                            <option value="international"><fmt:message key="an.cat.international"/></option>
                            <option value="student"${sessionScope.user.role == 'counselor' ? ' selected' : ''}><fmt:message key="an.cat.student"/></option>
                            <option value="campus"><fmt:message key="an.cat.campus"/></option>
                        </select>
                        <p class="field-error" id="ancategory-error" aria-live="polite"></p>
                    </div>
                    <div class="input-group">
                        <label for="anaudience"><fmt:message key="an.f.audience"/></label>
                        <select name="anaudience" id="anaudience" aria-describedby="anaudience-error">
                            <c:choose>
                                <c:when test="${sessionScope.user.role == 'teacher'}">
                                    <c:choose>
                                        <c:when test="${empty classes}">
                                            <option value=""><fmt:message key="an.noclasses"/></option>
                                        </c:when>
                                        <c:otherwise>
                                            <option value="mine"><fmt:message key="an.aud.allmine"/></option>
                                            <c:forEach var="o" items="${classes}">
                                                <option value="${o.id()}"><c:out value="${o.courseName()} (${o.courseCode()}), ${tx.format(o.students() == 1 ? 'js.exam.students.one' : 'js.exam.students.many', o.students())}"/></option>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <option value="student"><fmt:message key="an.to.mystudents"/></option>
                                    <option value="teacher"><fmt:message key="an.aud.teachers"/></option>
                                    <option value="all"><fmt:message key="an.aud.public"/></option>
                                </c:otherwise>
                            </c:choose>
                        </select>
                        <p class="field-error" id="anaudience-error" aria-live="polite"></p>
                    </div>
                </div>
                <div class="input-group">
                    <label for="antitle"><fmt:message key="an.f.title"/></label>
                    <input type="text" name="antitle" id="antitle" maxlength="200" placeholder="<fmt:message key="an.f.title.ph"/>" aria-describedby="antitle-error" required>
                    <p class="field-error" id="antitle-error" aria-live="polite"></p>
                </div>
                <div class="input-group">
                    <label for="ansummary"><fmt:message key="an.f.summary"/> <span class="lr-upload-optional"><fmt:message key="an.f.summary.hint"/></span></label>
                    <textarea name="ansummary" id="ansummary" rows="2" maxlength="500" placeholder="<fmt:message key="an.f.summary.ph"/>" aria-describedby="ansummary-error"></textarea>
                    <p class="field-error" id="ansummary-error" aria-live="polite"></p>
                </div>
                <div class="input-group">
                    <label for="anbody"><fmt:message key="an.f.body"/> <span class="lr-upload-optional"><fmt:message key="an.f.body.hint"/></span></label>
                    <textarea name="anbody" id="anbody" rows="6" maxlength="5000" placeholder="<fmt:message key="an.f.body.ph"/>" aria-describedby="anbody-error"></textarea>
                    <p class="field-error" id="anbody-error" aria-live="polite"></p>
                </div>
                <p class="form-status" role="status"></p>
                <button type="submit" class="an-submit"><fmt:message key="an.publish"/></button>
            </form>

            <h1 class="pgtitle"><fmt:message key="an.mine"/></h1>
            <p class="form-status an-status" role="status"></p>
            <div class="an-mine" data-delete-url="${pageContext.request.contextPath}/dashboard/announcements/delete" data-csrf="${sessionScope.csrf}" data-role="${sessionScope.user.role}">
                <c:forEach var="a" items="${mine}">
                    <t:announcement item="${a}" owner="${true}"/>
                </c:forEach>
            </div>
            <p class="an-none"${empty mine ? '' : ' hidden'}><fmt:message key="an.none.mine"/></p>

            <template id="an-template">
                <article class="an-item">
                    <div class="an-top">
                        <span class="an-cat" data-f="categoryText"></span>
                        <span class="an-to" data-f="audienceText"></span>
                        <time class="an-date" data-f="date"></time>
                    </div>
                    <h2 class="an-title" data-f="title"></h2>
                    <p class="an-from" data-f="from"></p>
                    <p class="an-excerpt" data-f="summary"></p>
                    <div class="an-body">
                        <p class="an-text" data-f="body"></p>
                    </div>
                    <div class="an-actions">
                        <button type="button" class="an-toggle" aria-expanded="false"><span><fmt:message key="js.an.more"/></span><svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="m6 9 6 6 6-6"/></svg></button>
                        <button type="button" class="an-delete"><fmt:message key="js.an.delete"/></button>
                    </div>
                </article>
            </template>
        </c:if>

        <h1 class="pgtitle"><fmt:message key="dash.nav.announcements"/></h1>
        <div class="an-toolbar">
            <label class="an-search"><svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/></svg><input type="search" id="ansearch" placeholder="<fmt:message key="an.search.ph"/>" aria-label="<fmt:message key="an.search"/>"></label>
            <div class="an-filters" role="group" aria-label="<fmt:message key="an.filter.aria"/>">
                <button type="button" class="an-chip active" data-filter="all" aria-pressed="true"><fmt:message key="leave.filter.all"/></button>
                <button type="button" class="an-chip" data-filter="academic" aria-pressed="false"><fmt:message key="an.cat.academic"/></button>
                <button type="button" class="an-chip" data-filter="exams" aria-pressed="false"><fmt:message key="an.cat.exams"/></button>
                <button type="button" class="an-chip" data-filter="international" aria-pressed="false"><fmt:message key="an.cat.international"/></button>
                <button type="button" class="an-chip" data-filter="student" aria-pressed="false"><fmt:message key="an.cat.student"/></button>
                <button type="button" class="an-chip" data-filter="campus" aria-pressed="false"><fmt:message key="an.cat.campus"/></button>
            </div>
        </div>
        <p class="an-count" aria-live="polite">${tx.format(fn:length(announcements) == 1 ? 'js.an.count.one' : 'js.an.count.many', fn:length(announcements))}</p>
        <div class="an-list">
            <c:forEach var="a" items="${announcements}">
                <t:announcement item="${a}"/>
            </c:forEach>
        </div>
        <p class="an-empty"><fmt:message key="an.nomatch"/></p>
    </c:otherwise>
</c:choose>
