<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<h1 class="pgtitle"><fmt:message key="exam.schedule.title"/></h1>
<c:choose>
    <c:when test="${examsError}">
        <p class="form-status error" role="status"><fmt:message key="exam.error"/></p>
    </c:when>
    <c:otherwise>
        <c:choose>
            <c:when test="${empty classes}">
                <p class="ex-empty"><fmt:message key="exam.noclasses"/></p>
            </c:when>
            <c:otherwise>
                <form action="${pageContext.request.contextPath}/dashboard/teacher/exams/save" method="post" class="ex-form" novalidate>
                    <input type="hidden" name="csrf" value="${sessionScope.csrf}">
                    <div class="input-line">
                        <div class="input-group">
                            <label for="exclass"><fmt:message key="exam.f.class"/></label>
                            <select name="exclass" id="exclass" aria-describedby="exclass-error">
                                <option value=""><fmt:message key="exam.f.class.ph"/></option>
                                <c:forEach var="o" items="${classes}">
                                    <option value="${o.id()}"><c:out value="${o.courseName()} (${o.courseCode()}), ${tx.format(o.students() == 1 ? 'js.exam.students.one' : 'js.exam.students.many', o.students())}"/></option>
                                </c:forEach>
                            </select>
                            <p class="field-error" id="exclass-error" aria-live="polite"></p>
                        </div>
                        <div class="input-group">
                            <label for="extype"><fmt:message key="exam.f.type"/></label>
                            <select name="extype" id="extype" aria-describedby="extype-error">
                                <option value="final"><fmt:message key="exam.type.final"/></option>
                                <option value="midterm"><fmt:message key="exam.type.midterm"/></option>
                                <option value="makeup"><fmt:message key="exam.type.makeup"/></option>
                            </select>
                            <p class="field-error" id="extype-error" aria-live="polite"></p>
                        </div>
                    </div>
                    <div class="ex-line3">
                        <div class="input-group">
                            <label for="exdate"><fmt:message key="exam.f.date"/></label>
                            <input type="date" name="exdate" id="exdate" aria-describedby="exdate-error" required>
                            <p class="field-error" id="exdate-error" aria-live="polite"></p>
                        </div>
                        <div class="input-group">
                            <label for="exstart"><fmt:message key="exam.f.start"/></label>
                            <input type="time" name="exstart" id="exstart" min="07:00" max="22:00" step="300" aria-describedby="exstart-error" required>
                            <p class="field-error" id="exstart-error" aria-live="polite"></p>
                        </div>
                        <div class="input-group">
                            <label for="exend"><fmt:message key="exam.f.end"/></label>
                            <input type="time" name="exend" id="exend" min="07:00" max="22:00" step="300" aria-describedby="exend-error" required>
                            <p class="field-error" id="exend-error" aria-live="polite"></p>
                        </div>
                    </div>
                    <div class="input-group">
                        <label for="exlocation"><fmt:message key="exam.f.room"/></label>
                        <input type="text" name="exlocation" id="exlocation" placeholder="<fmt:message key="exam.f.room.ph"/>" maxlength="100" aria-describedby="exlocation-error" required>
                        <p class="field-error" id="exlocation-error" aria-live="polite"></p>
                    </div>
                    <div class="input-group">
                        <label for="exnotes"><fmt:message key="exam.f.notes"/> <span class="lr-upload-optional"><fmt:message key="exam.optional"/></span></label>
                        <textarea name="exnotes" id="exnotes" rows="3" maxlength="500" placeholder="<fmt:message key="exam.f.notes.ph"/>" aria-describedby="exnotes-error"></textarea>
                        <p class="field-error" id="exnotes-error" aria-live="polite"></p>
                    </div>
                    <p class="form-status" role="status"></p>
                    <button type="submit" class="ex-submit"><fmt:message key="exam.submit"/></button>
                </form>
            </c:otherwise>
        </c:choose>

        <h1 class="pgtitle"><fmt:message key="exam.mine"/></h1>
        <p class="form-status ex-status" role="status"></p>
        <div class="ex-list" data-remove-url="${pageContext.request.contextPath}/dashboard/teacher/exams/remove" data-csrf="${sessionScope.csrf}">
            <c:forEach var="e" items="${exams}">
                <t:exam exam="${e}" teacher="${true}"/>
            </c:forEach>
        </div>
        <p class="ex-empty"${empty exams ? '' : ' hidden'}><fmt:message key="exam.none.teacher"/></p>

        <template id="ex-template">
            <article class="ex-item">
                <div class="ex-date" aria-hidden="true">
                    <span class="ex-month" data-f="month"></span>
                    <span class="ex-day" data-f="day"></span>
                    <span class="ex-weekday" data-f="weekday"></span>
                </div>
                <div class="ex-body">
                    <div class="ex-top">
                        <span class="ex-type" data-f="typeText"></span>
                        <span class="ex-when" data-f="when"></span>
                    </div>
                    <h3><span data-f="course"></span> <span class="ex-code" data-f="code"></span></h3>
                    <ul class="ex-meta">
                        <li><svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/></svg><span data-f="datetime"></span></li>
                        <li><svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 21s-7-6.2-7-11a7 7 0 0 1 14 0c0 4.8-7 11-7 11z"/><circle cx="12" cy="10" r="2.5"/></svg><span data-f="location"></span></li>
                        <li><svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg><span data-f="studentsText"></span></li>
                    </ul>
                    <p class="ex-notes" data-f="notes"></p>
                </div>
                <button type="button" class="ex-remove"><fmt:message key="js.exam.remove"/></button>
            </article>
        </template>
    </c:otherwise>
</c:choose>
