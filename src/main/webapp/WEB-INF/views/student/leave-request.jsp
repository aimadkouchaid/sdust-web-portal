<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<h1 class="pgtitle"><fmt:message key="leave.title.request"/></h1>
<form action="${pageContext.request.contextPath}/dashboard/leave/submit" method="post" enctype="multipart/form-data" class="requestaleave" novalidate>
    <input type="hidden" name="csrf" value="${sessionScope.csrf}">
    <div class="input-group">
        <label for="leavetype"><fmt:message key="leave.f.type"/></label>
        <select name="leavetype" id="leavetype" aria-describedby="leavetype-error">
            <option value="sick"><fmt:message key="leave.type.sick"/></option>
            <option value="personal"><fmt:message key="leave.type.personal"/></option>
            <option value="emergency"><fmt:message key="leave.type.emergency"/></option>
            <option value="officialactivity"><fmt:message key="leave.type.officialactivity"/></option>
        </select>
        <p class="field-error" id="leavetype-error" aria-live="polite"></p>
    </div>
    <div class="input-line">
        <div class="input-group">
            <label for="startdate"><fmt:message key="leave.f.start"/></label>
            <input type="date" name="startdate" id="startdate" aria-describedby="startdate-error" required>
            <p class="field-error" id="startdate-error" aria-live="polite"></p>
        </div>
        <div class="input-group">
            <label for="enddate"><fmt:message key="leave.f.end"/></label>
            <input type="date" name="enddate" id="enddate" aria-describedby="enddate-error" required>
            <p class="field-error" id="enddate-error" aria-live="polite"></p>
        </div>
    </div>
    <h3 class="duraction" aria-live="polite"><fmt:message key="js.leave.duration.none"/></h3>
    <div class="input-line">
        <div class="input-group">
            <label for="dest"><fmt:message key="leave.f.dest"/></label>
            <input type="text" name="dest" id="dest" placeholder="<fmt:message key="leave.ph.dest"/>" maxlength="100" aria-describedby="dest-error" required>
            <p class="field-error" id="dest-error" aria-live="polite"></p>
        </div>
        <div class="input-group">
            <label for="contactnum"><fmt:message key="leave.f.contact"/></label>
            <input type="tel" name="contactnum" id="contactnum" inputmode="tel" placeholder="<fmt:message key="leave.ph.contact"/>" autocomplete="tel" maxlength="16" aria-describedby="contactnum-error" required>
            <p class="field-error" id="contactnum-error" aria-live="polite"></p>
        </div>
    </div>
    <div class="input-group">
        <label for="reason"><fmt:message key="leave.f.reasonlabel"/></label>
        <textarea name="reason" id="reason" placeholder="<fmt:message key="leave.ph.reason"/>" maxlength="1000" aria-describedby="reason-error" required></textarea>
        <p class="field-error" id="reason-error" aria-live="polite"></p>
    </div>
    <div class="input-group">
        <label for="att"><fmt:message key="leave.f.attachment"/> <span class="lr-upload-optional"><fmt:message key="leave.att.hint"/></span></label>
        <input type="file" name="att" id="att" class="lr-upload-input" accept=".pdf,.jpg,.jpeg,.png,.doc,.docx" aria-describedby="att-error">
        <p class="field-error" id="att-error" aria-live="polite"></p>
    </div>
    <p class="form-status" role="status"></p>
    <button type="submit" class="requestaleave-btn">
        <fmt:message key="leave.submit"/>
        <svg style="transition: 0.3s;" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
    </button>
</form>
<h1 class="pgtitle"><fmt:message key="leave.title.mine"/></h1>

<c:choose>
    <c:when test="${requestsError}">
        <p class="form-status error" role="status"><fmt:message key="leave.error.mine"/></p>
    </c:when>
    <c:otherwise>
        <div class="lr-tablewrap">
            <table class="lr-table" data-cancel-url="${pageContext.request.contextPath}/dashboard/leave/cancel" data-attachment-url="${pageContext.request.contextPath}/dashboard/leave/attachment" data-csrf="${sessionScope.csrf}">
                <thead>
                    <tr>
                        <th><fmt:message key="leave.th.type"/></th>
                        <th><fmt:message key="leave.th.date"/></th>
                        <th class="lr-col-dur"><fmt:message key="leave.f.duration"/></th>
                        <th class="lr-col-sub"><fmt:message key="leave.f.submitted"/></th>
                        <th><fmt:message key="leave.th.status"/></th>
                        <th class="lr-col-toggle"><span class="lr-sr"><fmt:message key="leave.th.details"/></span></th>
                    </tr>
                </thead>
                <c:forEach var="r" items="${requests}">
                    <tbody class="lr-item" data-id="${r.id}" data-status="${r.status}" data-submitted="${r.submittedIso()}">
                        <tr class="lr-row" tabindex="0" aria-expanded="false">
                            <td><span class="lr-type">${r.typeText(tx)}</span></td>
                            <td class="lr-date">${r.dateRangeText(tx)}</td>
                            <td class="lr-col-dur">${r.durationText(tx)}</td>
                            <td class="lr-col-sub">${r.submittedText(tx)}</td>
                            <td><span class="lr-status ${r.status}">${r.statusText(tx)}</span></td>
                            <td class="lr-col-toggle"><svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="m6 9 6 6 6-6"/></svg></td>
                        </tr>
                        <tr class="lr-detail-row">
                            <td colspan="6">
                                <div class="lr-details">
                                    <div class="lr-grid">
                                        <div class="lr-field"><span><fmt:message key="leave.f.id"/></span><p><c:out value="${empty r.requestNo ? tx.get('profile.notset') : r.requestNo}"/></p></div>
                                        <div class="lr-field"><span><fmt:message key="leave.f.type"/></span><p>${r.typeText(tx)}</p></div>
                                        <div class="lr-field"><span><fmt:message key="leave.f.start"/></span><p>${r.startText(tx)}</p></div>
                                        <div class="lr-field"><span><fmt:message key="leave.f.end"/></span><p>${r.endText(tx)}</p></div>
                                        <div class="lr-field"><span><fmt:message key="leave.f.duration"/></span><p>${r.durationText(tx)}</p></div>
                                        <div class="lr-field"><span><fmt:message key="leave.f.submitted"/></span><p>${r.submittedText(tx)}</p></div>
                                        <div class="lr-field"><span><fmt:message key="leave.f.dest"/></span><p><c:out value="${r.destination}"/></p></div>
                                        <div class="lr-field"><span><fmt:message key="leave.f.contact"/></span><p><c:out value="${r.contactNumber}"/></p></div>
                                        <div class="lr-field"><span><fmt:message key="leave.f.attachment"/></span><p><c:choose><c:when test="${empty r.attachmentName}"><fmt:message key="leave.none"/></c:when><c:otherwise><a href="${pageContext.request.contextPath}/dashboard/leave/attachment?id=${r.id}" class="lr-file"><c:out value="${r.attachmentName}"/></a></c:otherwise></c:choose></p></div>
                                    </div>
                                    <div class="lr-field lr-reason"><span><fmt:message key="leave.f.reason"/></span><p><c:out value="${r.reason}"/></p></div>
                                    <c:choose>
                                        <c:when test="${r.status == 'pending'}">
                                            <div class="lr-actions">
                                                <p><fmt:message key="leave.waiting"/></p>
                                                <button type="button" class="lr-cancel"><fmt:message key="leave.cancel.title"/></button>
                                            </div>
                                        </c:when>
                                        <c:when test="${r.status == 'cancelled'}">
                                            <div class="lr-actions"><p class="lr-note"><fmt:message key="js.leave.youcancelled"/></p></div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="lr-review ${r.status}">
                                                <span><fmt:message key="leave.reviewedby"><fmt:param><c:out value="${empty r.reviewerName ? tx.get('leave.counseloroffice') : r.reviewerName}"/></fmt:param><fmt:param value="${r.reviewedText(tx)}"/></fmt:message></span>
                                                <c:if test="${not empty r.reviewComment}">
                                                    <p><c:out value="${r.reviewComment}"/></p>
                                                </c:if>
                                                <c:if test="${r.status == 'approved'}">
                                                    <a href="${pageContext.request.contextPath}/dashboard/leave/slip?id=${r.id}" class="lr-slip"><svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 4v11M7 10l5 5 5-5M5 20h14"/></svg><fmt:message key="leave.slip.download"/></a>
                                                </c:if>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </c:forEach>
                <tbody class="lr-empty">
                    <tr>
                        <td colspan="6"><fmt:message key="leave.empty.mine"/></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <template id="lr-template">
            <tbody class="lr-item" data-status="pending">
                <tr class="lr-row" tabindex="0" aria-expanded="false">
                    <td><span class="lr-type" data-f="typeText"></span></td>
                    <td class="lr-date" data-f="dateRange"></td>
                    <td class="lr-col-dur" data-f="duration"></td>
                    <td class="lr-col-sub" data-f="submitted"></td>
                    <td><span class="lr-status pending" data-f="statusText"></span></td>
                    <td class="lr-col-toggle"><svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="m6 9 6 6 6-6"/></svg></td>
                </tr>
                <tr class="lr-detail-row">
                    <td colspan="6">
                        <div class="lr-details">
                            <div class="lr-grid">
                                <div class="lr-field"><span><fmt:message key="leave.f.id"/></span><p data-f="requestNo"></p></div>
                                <div class="lr-field"><span><fmt:message key="leave.f.type"/></span><p data-f="typeText"></p></div>
                                <div class="lr-field"><span><fmt:message key="leave.f.start"/></span><p data-f="start"></p></div>
                                <div class="lr-field"><span><fmt:message key="leave.f.end"/></span><p data-f="end"></p></div>
                                <div class="lr-field"><span><fmt:message key="leave.f.duration"/></span><p data-f="duration"></p></div>
                                <div class="lr-field"><span><fmt:message key="leave.f.submitted"/></span><p data-f="submitted"></p></div>
                                <div class="lr-field"><span><fmt:message key="leave.f.dest"/></span><p data-f="destination"></p></div>
                                <div class="lr-field"><span><fmt:message key="leave.f.contact"/></span><p data-f="contact"></p></div>
                                <div class="lr-field"><span><fmt:message key="leave.f.attachment"/></span><p class="lr-attachment"><fmt:message key="leave.none"/></p></div>
                            </div>
                            <div class="lr-field lr-reason"><span><fmt:message key="leave.f.reason"/></span><p data-f="reason"></p></div>
                            <div class="lr-actions">
                                <p><fmt:message key="leave.waiting"/></p>
                                <button type="button" class="lr-cancel"><fmt:message key="leave.cancel.title"/></button>
                            </div>
                        </div>
                    </td>
                </tr>
            </tbody>
        </template>
    </c:otherwise>
</c:choose>
