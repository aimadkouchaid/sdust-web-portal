<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<h1 class="pgtitle"><fmt:message key="dash.nav.leaverequests"/></h1>
<c:choose>
    <c:when test="${requestsError}">
        <p class="form-status error" role="status"><fmt:message key="leave.error.all"/></p>
    </c:when>
    <c:otherwise>
        <div class="lr-filters" role="group" aria-label="<fmt:message key="leave.filter.aria"/>">
            <button type="button" class="lr-filter active" data-filter="all" aria-pressed="true"><fmt:message key="leave.filter.all"/> <span class="lr-count">0</span></button>
            <button type="button" class="lr-filter" data-filter="pending" aria-pressed="false"><fmt:message key="leave.filter.pending"/> <span class="lr-count">0</span></button>
            <button type="button" class="lr-filter" data-filter="approved" aria-pressed="false"><fmt:message key="leave.filter.approved"/> <span class="lr-count">0</span></button>
            <button type="button" class="lr-filter" data-filter="rejected" aria-pressed="false"><fmt:message key="leave.filter.rejected"/> <span class="lr-count">0</span></button>
            <button type="button" class="lr-filter" data-filter="cancelled" aria-pressed="false"><fmt:message key="leave.filter.cancelled"/> <span class="lr-count">0</span></button>
        </div>

        <div class="lr-tablewrap">
            <table class="lr-table lr-counselor" data-slip-url="${pageContext.request.contextPath}/dashboard/leave/slip" data-slip-label="<fmt:message key="leave.slip.download"/>" data-review-url="${pageContext.request.contextPath}/dashboard/counselor/leave/review" data-csrf="${sessionScope.csrf}">
                <thead>
                    <tr>
                        <th><fmt:message key="leave.f.student"/></th>
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
                            <td><span class="lr-student"><c:out value="${r.studentName}"/></span></td>
                            <td><span class="lr-type">${r.typeText(tx)}</span></td>
                            <td class="lr-date">${r.dateRangeText(tx)}</td>
                            <td class="lr-col-dur">${r.durationText(tx)}</td>
                            <td class="lr-col-sub">${r.submittedText(tx)}</td>
                            <td><span class="lr-status ${r.status}">${r.statusText(tx)}</span></td>
                            <td class="lr-col-toggle"><svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="m6 9 6 6 6-6"/></svg></td>
                        </tr>
                        <tr class="lr-detail-row">
                            <td colspan="7">
                                <div class="lr-details">
                                    <div class="lr-grid">
                                        <div class="lr-field"><span><fmt:message key="leave.f.id"/></span><p><c:out value="${empty r.requestNo ? tx.get('profile.notset') : r.requestNo}"/></p></div>
                                        <div class="lr-field"><span><fmt:message key="leave.f.student"/></span><p><c:out value="${r.studentName}"/></p></div>
                                        <div class="lr-field"><span><fmt:message key="leave.f.studentid"/></span><p><c:out value="${r.studentId}"/></p></div>
                                        <div class="lr-field"><span><fmt:message key="leave.f.class"/></span><p><c:out value="${empty r.className ? 'Not set' : r.className}"/></p></div>
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
                                            <form class="lr-review-form" novalidate>
                                                <div class="input-group">
                                                    <label for="lr-comment-${r.id}"><fmt:message key="review.comment"/> <span class="lr-upload-optional"><fmt:message key="review.comment.hint"/></span></label>
                                                    <textarea id="lr-comment-${r.id}" name="comment" rows="3" maxlength="500" placeholder="<fmt:message key="review.comment.ph"/>" aria-describedby="lr-comment-${r.id}-error"></textarea>
                                                    <p class="field-error" id="lr-comment-${r.id}-error" aria-live="polite"></p>
                                                </div>
                                                <p class="form-status" role="status"></p>
                                                <div class="lr-review-buttons">
                                                    <button type="button" class="lr-reject" data-decision="reject"><fmt:message key="review.reject"/></button>
                                                    <button type="button" class="lr-approve" data-decision="approve"><fmt:message key="review.approve"/></button>
                                                </div>
                                            </form>
                                        </c:when>
                                        <c:when test="${r.status == 'cancelled'}">
                                            <div class="lr-actions"><p class="lr-note"><fmt:message key="leave.studentcancelled"/></p></div>
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
                        <td colspan="7"><fmt:message key="leave.empty.all"/></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </c:otherwise>
</c:choose>
