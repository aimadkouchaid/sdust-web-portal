$(document).ready(function(){
    var dashText = {};
    try {
        dashText = JSON.parse($("#dash-i18n").text() || "{}");
    } catch(e) {
        dashText = {};
    }
    function T(key){
        var text = dashText.hasOwnProperty(key) ? dashText[key] : key;
        for(var i = 1; i < arguments.length; i++){
            text = text.split("{" + (i - 1) + "}").join(arguments[i]);
        }
        return text;
    }
    function TN(key, n){
        return T(key + (+n === 1 ? ".one" : ".many"), n);
    }

    var $tip = $('<div class="sdtip" role="tooltip"></div>').appendTo("body");

    var drawerQuery = window.matchMedia("(max-width: 1000px)");

    function setDrawer(open){
        $("body").toggleClass("sd-open", open);
        $(".sideaction").attr("aria-expanded", open);
    }

    $(".sideaction").on("click", function(){
        $tip.removeClass("show");
        if(drawerQuery.matches){
            setDrawer(!$("body").hasClass("sd-open"));
            return;
        }
        var collapsed = $("body").toggleClass("sd-collapsed").hasClass("sd-collapsed");
        $(".sidebar").toggleClass("expanded", !collapsed);
        $(this).attr("aria-expanded", !collapsed);
    })

    $(".sdbackdrop").on("click", function(){
        setDrawer(false);
    })

    $(document).on("keydown", function(e){
        if(e.key === "Escape" && $("body").hasClass("sd-open")) setDrawer(false);
    })

    function syncDrawer(){
        setDrawer(false);
        $(".sideaction").attr("aria-expanded", drawerQuery.matches ? false : !$("body").hasClass("sd-collapsed"));
    }
    if(drawerQuery.addEventListener){
        drawerQuery.addEventListener("change", syncDrawer);
    } else if(drawerQuery.addListener){
        drawerQuery.addListener(syncDrawer);
    }
    syncDrawer();

    $(".sidebar .sidelink").on("mouseenter focus", function(){
        if(!$("body").hasClass("sd-collapsed") || drawerQuery.matches) return;
        var r = this.getBoundingClientRect();
        $tip.text($.trim($(this).children("span").text()))
            .css({ top: r.top + r.height / 2, left: r.right + 14 })
            .addClass("show");
    }).on("mouseleave blur", function(){
        $tip.removeClass("show");
    })
    
    $(".logout").on("click", function(){
        setDrawer(false);
        $tip.removeClass("show");
        $(".logoutbox").stop(true, true).hide();
        $(".logoutcontainer").stop(true, true).css("display", "flex").hide().fadeIn(300);
        $(".logoutbox").delay(200).fadeIn(200);
    })

    if($(".ntf").length){
        var $ntf = $(".ntf");
        var $ntfBtn = $ntf.find(".notifications");

        function updateBadge(){
            var unread = $ntf.find(".ntf-item.unread").length;
            $ntf.find(".nbadge").text(unread > 9 ? "9+" : unread).toggleClass("empty", !unread);
            $ntf.find(".ntf-readall").prop("disabled", !unread);
            $ntf.find(".ntf-clear").prop("disabled", !$ntf.find(".ntf-item").length);
            $ntfBtn.attr("aria-label", unread ? T("ntf.unread", unread) : T("ntf.title"));
        }

        function setNtf(open){
            $ntf.toggleClass("open", open);
            $ntfBtn.attr("aria-expanded", open);
        }

        $ntfBtn.on("click", function(e){
            e.stopPropagation();
            setNtf(!$ntf.hasClass("open"));
        });
        $ntf.find(".ntf-panel").on("click", function(e){
            e.stopPropagation();
        });
        $(document).on("click", function(){
            if($ntf.hasClass("open")) setNtf(false);
        });
        $(document).on("keydown", function(e){
            if(e.key === "Escape" && $ntf.hasClass("open")){
                setNtf(false);
                $ntfBtn.trigger("focus");
            }
        });
        var ntfReadUrl = $ntf.attr("data-read-url");
        var ntfCsrf = $ntf.attr("data-csrf");

        $ntf.find(".ntf-list").on("click", ".ntf-link", function(e){
            var $item = $(this).closest(".ntf-item");
            var href = this.href;
            var wasUnread = $item.hasClass("unread");
            $item.removeClass("unread");
            updateBadge();
            if(!ntfReadUrl || !wasUnread || !$item.attr("data-id")) return;
            if(e.ctrlKey || e.metaKey || e.shiftKey || e.button === 1){
                var body = new URLSearchParams({ csrf: ntfCsrf, id: $item.attr("data-id") });
                if(!(navigator.sendBeacon && navigator.sendBeacon(ntfReadUrl, body))){
                    $.post(ntfReadUrl, body.toString());
                }
                return;
            }
            e.preventDefault();
            $.ajax({
                url: ntfReadUrl,
                method: "POST",
                data: { csrf: ntfCsrf, id: $item.attr("data-id") },
                timeout: 3000
            }).always(function(){
                window.location.href = href;
            });
        });
        $ntf.find(".ntf-readall").on("click", function(){
            if(ntfReadUrl) $.post(ntfReadUrl, { csrf: ntfCsrf });
            $ntf.find(".ntf-item").removeClass("unread");
            updateBadge();
        });

        var $ntfClear = $ntf.find(".ntf-clear");

        $ntfClear.on("click", function(){
            $ntfClear.prop("disabled", true);
            $.ajax({
                url: $ntf.attr("data-clear-url"),
                method: "POST",
                data: { csrf: ntfCsrf },
                dataType: "json"
            }).done(function(){
                $ntf.find(".ntf-item, .ntf-empty").remove();
                $ntf.find(".ntf-list").append($("<li>").addClass("ntf-empty").text(T("ntf.empty")));
            }).always(function(){
                updateBadge();
            });
        });

        updateBadge();
    }

    $(".closelg, .cancellg").on("click", closeLogout)
    $(".logoutcontainer").on("click", function(e){
        if(e.target === this) closeLogout();
    })
    $(document).on("keydown", function(e){
        if(e.key === "Escape" && $(".logoutcontainer").is(":visible")) closeLogout();
    })
    function closeLogout(){
        $(".logoutbox").stop(true, true).fadeOut(200);
        $(".logoutcontainer").stop(true, true).delay(200).fadeOut(200);
    }

    if($(".lr-table").length){
        var $lrTable = $(".lr-table");
        var $lrModal = $(".lr-modal");
        var lrSpeed = window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches ? 0 : 300;
        var $lrTarget = null;

        function sortRequests(){
            var items = $lrTable.children(".lr-item").get();
            items.sort(function(a, b){
                var pa = $(a).attr("data-status") === "pending" ? 0 : 1;
                var pb = $(b).attr("data-status") === "pending" ? 0 : 1;
                if(pa !== pb) return pa - pb;
                return $(b).attr("data-submitted").localeCompare($(a).attr("data-submitted"));
            });
            $lrTable.append(items).append($lrTable.children(".lr-empty"));
        }

        function updateEmpty(){
            $lrTable.children(".lr-empty").toggleClass("show", !$lrTable.children(".lr-item").length);
        }

        function closeItem($item){
            $item.removeClass("open");
            $item.find(".lr-row").attr("aria-expanded", "false");
            $item.find(".lr-details").stop(true, true).slideUp(lrSpeed);
        }

        function toggleItem($item){
            var opening = !$item.hasClass("open");
            closeItem($lrTable.children(".lr-item.open").not($item));
            if(opening){
                $item.addClass("open");
                $item.find(".lr-row").attr("aria-expanded", "true");
                $item.find(".lr-details").stop(true, true).slideDown(lrSpeed);
            } else {
                closeItem($item);
            }
        }

        function closeLrModal(){
            $lrModal.stop(true, true).fadeOut(lrSpeed ? 200 : 0);
            $lrTarget = null;
        }

        $lrTable.on("click", ".lr-row", function(){
            toggleItem($(this).closest(".lr-item"));
        }).on("keydown", ".lr-row", function(e){
            if(e.key === "Enter" || e.key === " "){
                e.preventDefault();
                toggleItem($(this).closest(".lr-item"));
            }
        });

        $lrTable.on("click", ".lr-cancel", function(){
            $lrTarget = $(this).closest(".lr-item");
            var $cells = $lrTarget.find(".lr-row td");
            $lrModal.find(".lr-modal-info").text($cells.eq(0).text() + " (" + $cells.eq(1).text() + ")");
            $lrModal.stop(true, true).css("display", "flex").hide().fadeIn(lrSpeed);
            $lrModal.find(".lr-keep").trigger("focus");
        });

        $lrModal.on("click", ".lr-keep, .lr-modal-close", closeLrModal);
        $lrModal.on("click", function(e){
            if(e.target === this) closeLrModal();
        });
        $(document).on("keydown", function(e){
            if(e.key === "Escape" && $lrModal.is(":visible")) closeLrModal();
        });

        $lrModal.on("click", ".lr-confirm", function(){
            var $item = $lrTarget;
            closeLrModal();
            if(!$item) return;
            var $actions = $item.find(".lr-actions");
            $actions.find(".form-status").remove();
            $actions.find(".lr-cancel").prop("disabled", true);
            $.ajax({
                url: $lrTable.attr("data-cancel-url"),
                method: "POST",
                data: { csrf: $lrTable.attr("data-csrf"), id: $item.attr("data-id") },
                dataType: "json"
            }).done(function(){
                $item.attr("data-status", "cancelled");
                $item.find(".lr-row .lr-status").attr("class", "lr-status cancelled").text(T("leave.cancelled"));
                $actions.replaceWith($("<div>").addClass("lr-actions").append($("<p>").addClass("lr-note").text(T("leave.youcancelled"))));
            }).fail(function(xhr){
                var res = xhr.responseJSON;
                $actions.find(".lr-cancel").prop("disabled", false);
                $actions.append($("<p>").addClass("form-status error").attr("role", "status")
                    .text(res ? res.message : T("session")));
            });
        });

        sortRequests();
        updateEmpty();
    }

    if($(".requestaleave").length){
        var $leave = $(".requestaleave");
        var $start = $("#startdate");
        var $end = $("#enddate");
        var $duration = $leave.find(".duraction");
        var maxFile = 5 * 1024 * 1024;
        var fileTypes = ["pdf", "jpg", "jpeg", "png", "doc", "docx"];

        function isoDate(d){
            return d.getFullYear() + "-" + ("0" + (d.getMonth() + 1)).slice(-2) + "-" + ("0" + d.getDate()).slice(-2);
        }
        function parseDate(value){
            if(!/^\d{4}-\d{2}-\d{2}$/.test(value)) return null;
            var p = value.split("-");
            return new Date(+p[0], p[1] - 1, +p[2]);
        }
        function daysBetween(a, b){
            return Math.round((b - a) / 86400000) + 1;
        }
        var today = new Date();
        today.setHours(0, 0, 0, 0);
        var earliest = new Date(today.getFullYear(), today.getMonth(), today.getDate() - 7);
        var latest = new Date(today.getFullYear() + 1, today.getMonth(), today.getDate());
        $start.attr({ min: isoDate(earliest), max: isoDate(latest) });
        $end.attr("min", isoDate(earliest));

        function updateDuration(){
            var s = parseDate($start.val());
            var e = parseDate($end.val());
            if(s && e && e >= s){
                var days = daysBetween(s, e);
                $duration.text(TN("leave.duration", days));
            } else {
                $duration.text(T("leave.duration.none"));
            }
            if(s) $end.attr("min", isoDate(s));
        }

        var leaveCheck = bindValidation($leave, {
            leavetype: function(value){
                return value ? "" : T("leave.v.type");
            },
            startdate: function(value){
                var d = parseDate(value);
                if(!d) return T("leave.v.start");
                if(d < earliest) return T("leave.v.startpast");
                if(d > latest) return T("leave.v.startyear");
                return "";
            },
            enddate: function(value){
                var d = parseDate(value);
                var s = parseDate($start.val());
                if(!d) return T("leave.v.end");
                if(s && d < s) return T("leave.v.endbefore");
                if(s && daysBetween(s, d) > 30) return T("leave.v.long");
                return "";
            },
            dest: function(value){
                value = $.trim(value);
                if(!value) return T("leave.v.dest");
                if(value.length > 100) return T("leave.v.destlong");
                return "";
            },
            contactnum: function(value){
                var digits = value.replace(/[\s-]/g, "").replace(/^\+?86/, "");
                if(!$.trim(value)) return T("leave.v.contact");
                if(!/^1[3-9]\d{9}$/.test(digits)) return T("phone.invalid");
                return "";
            },
            reason: function(value){
                value = $.trim(value);
                if(!value) return T("leave.v.reason");
                if(value.length < 10) return T("leave.v.reasonshort");
                if(value.length > 1000) return T("leave.v.reasonlong");
                return "";
            },
            att: function(value, $input){
                var file = $input[0].files && $input[0].files[0];
                if(!file) return "";
                var ext = file.name.indexOf(".") < 0 ? "" : file.name.split(".").pop().toLowerCase();
                if(fileTypes.indexOf(ext) < 0) return T("leave.v.filetype");
                if(file.size > maxFile) return T("leave.v.filesize");
                return "";
            }
        });

        $start.add($end).on("change input", function(){
            updateDuration();
            if($end.val() !== "" && (this === $start[0] || $end.hasClass("invalid"))) leaveCheck.check($end);
        });

        function fillRow(res){
            var $row = $($.trim($("#lr-template").html()));
            $row.attr({ "data-id": res.id, "data-submitted": res.submittedIso });
            $row.find("[data-f]").each(function(){
                $(this).text(res[$(this).attr("data-f")]);
            });
            if(res.attachment){
                $row.find(".lr-attachment").empty().append(
                    $("<a>").addClass("lr-file").attr("href", $(".lr-table").attr("data-attachment-url") + "?id=" + encodeURIComponent(res.id)).text(res.attachment));
            }
            return $row;
        }

        $leave.on("submit", function(e){
            e.preventDefault();
            if(!leaveCheck.all()) return;
            var $status = $leave.find(".form-status");
            var $button = $leave.find("button[type='submit']");
            $button.prop("disabled", true);
            $status.removeClass("error").text("");
            $.ajax({
                url: $leave.attr("action"),
                method: "POST",
                data: new FormData($leave[0]),
                processData: false,
                contentType: false,
                dataType: "json"
            }).done(function(res){
                var $table = $(".lr-table");
                $table.children("thead").after(fillRow(res));
                $table.children(".lr-empty").removeClass("show");
                $leave[0].reset();
                $leave.find(".invalid").removeClass("invalid").attr("aria-invalid", "false");
                $leave.find(".field-error").text("");
                updateDuration();
                $status.removeClass("error").text(res.message);
            }).fail(function(xhr){
                var res = xhr.responseJSON;
                if(!res){
                    $status.addClass("error").text(xhr.status === 413 ? T("leave.v.filelarge") : T("session"));
                } else if(res.field){
                    $("#" + res.field).addClass("invalid").attr("aria-invalid", "true").trigger("focus");
                    $("#" + res.field + "-error").text(res.message);
                } else {
                    $status.addClass("error").text(res.message);
                }
            }).always(function(){
                $button.prop("disabled", false);
            });
        });

        updateDuration();
    }

    if($(".ex-form").length){
        var $exForm = $(".ex-form");
        var $exList = $(".ex-list");
        var $exDate = $("#exdate");
        var $exStart = $("#exstart");
        var $exEnd = $("#exend");
        var exToday = new Date();
        exToday.setHours(0, 0, 0, 0);
        var exLatest = new Date(exToday.getFullYear() + 1, exToday.getMonth(), exToday.getDate());

        function exIso(d){
            return d.getFullYear() + "-" + ("0" + (d.getMonth() + 1)).slice(-2) + "-" + ("0" + d.getDate()).slice(-2);
        }
        function exDay(value){
            if(!/^\d{4}-\d{2}-\d{2}$/.test(value)) return null;
            var p = value.split("-");
            return new Date(+p[0], p[1] - 1, +p[2]);
        }
        function exMinutes(value){
            if(!/^\d{2}:\d{2}/.test(value)) return null;
            return +value.slice(0, 2) * 60 + +value.slice(3, 5);
        }
        $exDate.attr({ min: exIso(exToday), max: exIso(exLatest) });

        var exCheck = bindValidation($exForm, {
            exclass: function(value){
                return value ? "" : T("exam.v.class");
            },
            extype: function(value){
                return value ? "" : T("exam.v.type");
            },
            exdate: function(value){
                var d = exDay(value);
                if(!d) return T("exam.v.date");
                if(d < exToday) return T("exam.v.datepast");
                if(d > exLatest) return T("exam.v.dateyear");
                return "";
            },
            exstart: function(value){
                var m = exMinutes(value);
                if(m === null) return T("exam.v.start");
                if(m < 420 || m > 1320) return T("exam.v.hours");
                return "";
            },
            exend: function(value){
                var m = exMinutes(value);
                var s = exMinutes($exStart.val());
                if(m === null) return T("exam.v.end");
                if(s !== null && m <= s) return T("exam.v.endbefore");
                if(m > 1320) return T("exam.v.hours");
                if(s !== null && m - s > 240) return T("exam.v.long");
                return "";
            },
            exlocation: function(value){
                value = $.trim(value);
                if(!value) return T("exam.v.room");
                if(value.length > 100) return T("exam.v.roomlong");
                return "";
            },
            exnotes: function(value){
                return $.trim(value).length > 500 ? T("exam.v.notes") : "";
            }
        });

        $exStart.on("change input", function(){
            if($exEnd.val() !== "") exCheck.check($exEnd);
        });

        function exCard(res){
            var $card = $($.trim($("#ex-template").html()));
            var values = $.extend({}, res, {
                datetime: res.date + ", " + res.time,
                studentsText: TN("exam.students", res.students)
            });
            $card.attr({ "data-id": res.id, "data-sort": res.sort });
            $card.find("[data-f]").each(function(){
                $(this).text(values[$(this).attr("data-f")]);
            });
            $card.find(".ex-type").addClass(res.type);
            return $card;
        }

        function exPlace($card){
            var placed = false;
            $exList.children(".ex-item").each(function(){
                if(!placed && $(this).attr("data-sort") > $card.attr("data-sort")){
                    $card.insertBefore(this);
                    placed = true;
                }
            });
            if(!placed) $exList.append($card);
        }

        function exEmpty(){
            $(".ex-list ~ .ex-empty").prop("hidden", $exList.children(".ex-item").length > 0);
        }

        $exForm.on("submit", function(e){
            e.preventDefault();
            if(!exCheck.all()) return;
            var $status = $exForm.find(".form-status");
            var $button = $exForm.find(".ex-submit").prop("disabled", true);
            $status.removeClass("error").text("");
            $.ajax({
                url: $exForm.attr("action"),
                method: "POST",
                data: $exForm.serialize(),
                dataType: "json"
            }).done(function(res){
                exPlace(exCard(res));
                exEmpty();
                $exForm[0].reset();
                $exForm.find(".invalid").removeClass("invalid").attr("aria-invalid", "false");
                $exForm.find(".field-error").text("");
                $status.removeClass("error").text(res.message);
            }).fail(function(xhr){
                var res = xhr.responseJSON;
                if(!res){
                    $status.addClass("error").text(T("session"));
                } else if(res.field){
                    $("#" + res.field).addClass("invalid").attr("aria-invalid", "true").trigger("focus");
                    $("#" + res.field + "-error").text(res.message);
                } else {
                    $status.addClass("error").text(res.message);
                }
            }).always(function(){
                $button.prop("disabled", false);
            });
        });

        $exList.on("click", ".ex-remove", function(){
            var $btn = $(this);
            var $card = $btn.closest(".ex-item");
            var $status = $(".ex-status");
            if(!$btn.hasClass("armed")){
                $btn.addClass("armed").text(T("exam.confirmremove"));
                setTimeout(function(){
                    if($btn.hasClass("armed")) $btn.removeClass("armed").text(T("exam.remove"));
                }, 4000);
                return;
            }
            $btn.removeClass("armed").prop("disabled", true);
            $status.removeClass("error").text("");
            $.ajax({
                url: $exList.attr("data-remove-url"),
                method: "POST",
                data: { csrf: $exList.attr("data-csrf"), id: $card.attr("data-id") },
                dataType: "json"
            }).done(function(res){
                $status.text(res.message);
                $card.fadeOut(200, function(){
                    $card.remove();
                    exEmpty();
                });
            }).fail(function(xhr){
                var res = xhr.responseJSON;
                $btn.prop("disabled", false).text(T("exam.remove"));
                $status.addClass("error").text(res ? res.message : T("session"));
            });
        });
    }

    if($(".lr-counselor").length){
        var $cl = $(".lr-counselor");
        var clFilter = "all";

        function clApply(){
            var shown = 0;
            $(".lr-filter").each(function(){
                var filter = $(this).attr("data-filter");
                var count = filter === "all" ? $cl.children(".lr-item").length : $cl.children(".lr-item[data-status='" + filter + "']").length;
                $(this).find(".lr-count").text(count);
            });
            $cl.children(".lr-item").each(function(){
                var match = clFilter === "all" || $(this).attr("data-status") === clFilter;
                if(!match && $(this).hasClass("open")){
                    $(this).removeClass("open").find(".lr-row").attr("aria-expanded", "false");
                    $(this).find(".lr-details").hide();
                }
                $(this).toggle(match);
                if(match) shown++;
            });
            $cl.children(".lr-empty").toggleClass("show", !shown);
        }

        $(".lr-filter").on("click", function(){
            clFilter = $(this).attr("data-filter");
            $(".lr-filter").removeClass("active").attr("aria-pressed", "false");
            $(this).addClass("active").attr("aria-pressed", "true");
            clApply();
        });

        $cl.on("input", ".lr-review-form textarea", function(){
            $(this).removeClass("invalid").attr("aria-invalid", "false");
            $("#" + $(this).attr("id") + "-error").text("");
            $(this).closest(".lr-review-form").find(".form-status").text("").removeClass("error");
        });

        $cl.on("click", ".lr-approve, .lr-reject", function(){
            var $form = $(this).closest(".lr-review-form");
            var $item = $form.closest(".lr-item");
            var $comment = $form.find("textarea");
            var $error = $("#" + $comment.attr("id") + "-error");
            var $status = $form.find(".form-status");
            var decision = $(this).attr("data-decision");
            var comment = $.trim($comment.val());

            $status.text("").removeClass("error");
            if(decision === "reject" && !comment){
                $comment.addClass("invalid").attr("aria-invalid", "true").trigger("focus");
                $error.text(T("review.v.comment"));
                return;
            }

            var $buttons = $form.find("button").prop("disabled", true);
            $.ajax({
                url: $cl.attr("data-review-url"),
                method: "POST",
                data: { csrf: $cl.attr("data-csrf"), id: $item.attr("data-id"), decision: decision, comment: comment },
                dataType: "json"
            }).done(function(res){
                $item.attr("data-status", res.status);
                $item.find(".lr-row .lr-status").attr("class", "lr-status " + res.status).text(res.statusText);
                var $review = $("<div>").addClass("lr-review " + res.status)
                    .append($("<span>").text(T("review.by", res.reviewer, res.reviewed)));
                if(res.comment) $review.append($("<p>").text(res.comment));
                if(res.status === "approved"){
                    $review.append($("<a>").addClass("lr-slip")
                        .attr("href", $cl.attr("data-slip-url") + "?id=" + encodeURIComponent($item.attr("data-id")))
                        .text($cl.attr("data-slip-label")));
                }
                var $done = $("<p>").addClass("form-status").attr("role", "status").text(res.message);
                $form.replaceWith($review.add($done));
                clApply();
            }).fail(function(xhr){
                var res = xhr.responseJSON;
                if(!res){
                    $status.addClass("error").text(T("session"));
                } else if(res.field){
                    $comment.addClass("invalid").attr("aria-invalid", "true").trigger("focus");
                    $error.text(res.message);
                } else {
                    $status.addClass("error").text(res.message);
                }
            }).always(function(){
                $buttons.prop("disabled", false);
            });
        });

        clApply();
    }

    if($(".tt-toolbar").length){
        var $ttBar = $(".tt-toolbar");
        var ttParts = $ttBar.attr("data-semester-start").split("-");
        var ttStart = new Date(+ttParts[0], ttParts[1] - 1, +ttParts[2]);
        var ttTotal = +$ttBar.attr("data-weeks");
        var ttMonths = T("tt.months").split(",");
        var ttNow = new Date();
        ttNow.setHours(0, 0, 0, 0);
        var ttDays = Math.round((ttNow - ttStart) / 86400000);
        var ttCurrent = Math.min(Math.max(Math.floor(ttDays / 7) + 1, 1), ttTotal);
        var ttWeek = ttCurrent;

        function ttDate(offset){
            return new Date(ttStart.getFullYear(), ttStart.getMonth(), ttStart.getDate() + offset);
        }

        function ttFormat(d){
            return T("tt.daymonth", ttMonths[d.getMonth()], d.getDate());
        }

        function renderWeek(){
            var base = (ttWeek - 1) * 7;
            var last = ttDate(base + 6);
            $(".tt-weeklabel").text(T("tt.week", ttWeek));
            $(".tt-range").text(T("tt.range", ttFormat(ttDate(base)), ttFormat(last), last.getFullYear()));
            $(".tt-dayhead").each(function(){
                var day = +$(this).attr("data-day");
                var d = ttDate(base + day - 1);
                var isToday = d.getTime() === ttNow.getTime();
                $(this).find(".tt-date").text(ttFormat(d));
                $(this).toggleClass("tt-today", isToday);
                $(".tt-cell.tt-day-" + day).toggleClass("tt-today", isToday);
            });
            var count = 0;
            var ttCells = {};
            $(".tt-session").each(function(){
                var on = ttWeek >= +$(this).attr("data-start-week") && ttWeek <= +$(this).attr("data-end-week");
                var key = (this.className.match(/tt-day-\d/) || [""])[0] + (this.className.match(/tt-slot-\d/) || [""])[0];
                $(this).toggleClass("tt-off", !on);
                (ttCells[key] = ttCells[key] || []).push({ el: this, on: on });
                if(on) count++;
            });
            $.each(ttCells, function(key, list){
                var shown = $.grep(list, function(item){ return item.on; })[0] || list[0];
                $.each(list, function(i, item){
                    $(item.el).toggleClass("tt-hidden", item !== shown);
                });
            });
            $(".tt-count").text(TN("tt.count", count));
            $(".tt-empty").prop("hidden", count > 0);
            $(".tt-prev").prop("disabled", ttWeek <= 1);
            $(".tt-next").prop("disabled", ttWeek >= ttTotal);
            $(".tt-thisweek").prop("disabled", ttWeek === ttCurrent);
        }

        $(".tt-prev").on("click", function(){
            if(ttWeek > 1){ ttWeek--; renderWeek(); }
        });
        $(".tt-next").on("click", function(){
            if(ttWeek < ttTotal){ ttWeek++; renderWeek(); }
        });
        $(".tt-thisweek").on("click", function(){
            ttWeek = ttCurrent;
            renderWeek();
        });

        renderWeek();
    }

    if($("#geclass").length){
        $("#geclass").on("change", function(){
            $(this).closest("form").trigger("submit");
        });
    }

    if($(".ge-form").length){
        var $geForm = $(".ge-form");
        var $geSave = $geForm.find(".ge-save");
        var $geStatus = $geForm.find(".form-status");
        var geLevels = { excellent: 4.5, good: 3.5, medium: 2.5, pass: 1.5, fail: 0 };
        var geTimer = null;

        function gePoint(score){
            return (score >= 60 ? Math.round((score * 10 - 500) / 10) / 10 : 0).toFixed(1);
        }

        function geCheck($input){
            var value = $.trim($input.val());
            var message = "";
            if(value !== "" && !$input.prop("disabled")){
                var n = Number(value);
                if(!/^\d{1,3}(\.\d)?$/.test(value) || isNaN(n) || n > 100) message = T("ge.v.number");
            }
            $input.toggleClass("invalid", !!message).attr("aria-invalid", message ? "true" : "false");
            $("#" + $input.attr("id") + "-error").text(message);
            return !message;
        }

        function geRefresh($row){
            var $input = $row.find(".ge-score");
            var level = $row.find(".ge-level").val();
            var text = "—";
            if(level){
                text = geLevels[level].toFixed(1);
            } else {
                var value = $.trim($input.val());
                if(value !== "" && geCheck($input)) text = gePoint(Number(value));
            }
            $row.find(".ge-point").text(text);
        }

        function geDisarm(){
            clearTimeout(geTimer);
            $geSave.removeClass("armed").text(T("ge.save"));
        }

        function geFilled(){
            return $geForm.find(".ge-row:not(.done)").filter(function(){
                return $(this).find(".ge-level").val() || $.trim($(this).find(".ge-score").val()) !== "";
            }).length;
        }

        $geForm.on("input", ".ge-score", function(){
            var $row = $(this).closest(".ge-row");
            if($(this).hasClass("invalid")) geCheck($(this));
            geRefresh($row);
            geDisarm();
            $geStatus.removeClass("error").text("");
        });
        $geForm.on("blur", ".ge-score", function(){
            geCheck($(this));
        });
        $geForm.on("change", ".ge-level", function(){
            var $row = $(this).closest(".ge-row");
            var $input = $row.find(".ge-score");
            $input.prop("disabled", !!$(this).val());
            if($(this).val()) $input.val("");
            geCheck($input);
            geRefresh($row);
            geDisarm();
        });

        $geForm.on("submit", function(e){
            e.preventDefault();
            var ok = true;
            var $first = null;
            $geForm.find(".ge-score").each(function(){
                if(!geCheck($(this))){
                    ok = false;
                    if(!$first) $first = $(this);
                }
            });
            if(!ok){
                $first.trigger("focus");
                return;
            }
            var count = geFilled();
            if(!count){
                $geStatus.addClass("error").text(T("ge.v.none"));
                return;
            }
            if(!$geSave.hasClass("armed")){
                $geSave.addClass("armed").text(TN("ge.confirm", count));
                geTimer = setTimeout(geDisarm, 5000);
                return;
            }
            geDisarm();
            $geSave.prop("disabled", true);
            $geStatus.removeClass("error").text("");
            $.ajax({
                url: $geForm.attr("action"),
                method: "POST",
                data: $geForm.serialize(),
                dataType: "json"
            }).done(function(res){
                $.each((res.saved || "").split(","), function(i, id){
                    if(!id) return;
                    var $row = $geForm.find(".ge-row[data-id='" + id + "']");
                    $row.addClass("done");
                    $row.find(".ge-cell").empty().append($("<strong>").addClass("ge-final").text(res["score-" + id]));
                    $row.find(".ge-point").text(res["point-" + id]);
                    $row.find(".ge-badge").addClass("done").text(T("ge.final"));
                });
                if(res.avgScore) $(".ge-avgscore").text(res.avgScore);
                if(res.avgPoint) $(".ge-avgpoint").text(res.avgPoint);
                if(res.graded) $(".ge-graded").text(res.graded);
                $geStatus.text(res.message);
                if(!$geForm.find(".ge-row:not(.done)").length) $geSave.remove();
            }).fail(function(xhr){
                var res = xhr.responseJSON;
                if(!res){
                    $geStatus.addClass("error").text(T("session"));
                } else if(res.field){
                    $("#" + res.field).addClass("invalid").attr("aria-invalid", "true").trigger("focus");
                    $("#" + res.field + "-error").text(res.message);
                } else {
                    $geStatus.addClass("error").text(res.message);
                }
            }).always(function(){
                $geSave.prop("disabled", false);
            });
        });
    }

    if($("#grsemester").length){
        $("#grsemester").on("change", function(){
            $(this).closest("form").trigger("submit");
        });
    }

    function bindValidation($form, rules){
        function check($input){
            var rule = rules[$input.attr("id")];
            if(!rule) return true;
            var message = rule($input.val(), $input);
            $input.toggleClass("invalid", !!message).attr("aria-invalid", message ? "true" : "false");
            $("#" + $input.attr("id") + "-error").text(message);
            return !message;
        }

        $form.on("blur", "input, textarea, select", function(){
            if($(this).val() !== "") check($(this));
        });
        $form.on("input change", "input, textarea, select", function(){
            $form.find(".form-status").text("").removeClass("error");
            if($(this).hasClass("invalid")) check($(this));
        });

        return {
            check: check,
            all: function(){
                var $first = null;
                $form.find("input, textarea, select").each(function(){
                    if(!check($(this)) && !$first) $first = $(this);
                });
                if($first) $first.trigger("focus");
                return !$first;
            }
        };
    }

    if($(".contactinfo").length){
        var $contact = $(".contactinfo");
        var contactSaved = { email: $.trim($("#email").val()), phone: $.trim($("#phonenumber").val()) };

        var contactCheck = bindValidation($contact, {
            email: function(value){
                value = $.trim(value);
                if(!value) return T("contact.v.email");
                if(value.length > 100 || !/^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(value)) return T("contact.v.emailinvalid");
                return "";
            },
            phonenumber: function(value){
                var digits = value.replace(/[\s-]/g, "").replace(/^\+?86/, "");
                if(!$.trim(value)) return T("contact.v.phone");
                if(!/^1[3-9]\d{9}$/.test(digits)) return T("phone.invalid");
                return "";
            }
        });

        $contact.on("submit", function(e){
            e.preventDefault();
            if(!contactCheck.all()) return;
            var current = { email: $.trim($("#email").val()), phone: $.trim($("#phonenumber").val()) };
            var $status = $contact.find(".form-status");
            if(current.email === contactSaved.email && current.phone === contactSaved.phone){
                $status.addClass("error").text(T("contact.unchanged"));
                return;
            }
            var $button = $contact.find("button[type='submit']");
            $button.prop("disabled", true);
            $status.removeClass("error").text("");
            $.ajax({
                url: $contact.attr("action"),
                method: "POST",
                data: $contact.serialize(),
                dataType: "json"
            }).done(function(res){
                $("#email").val(res.email);
                $("#phonenumber").val(res.phone);
                contactSaved = { email: res.email, phone: res.phone };
                $status.removeClass("error").text(res.message);
            }).fail(function(xhr){
                var res = xhr.responseJSON;
                if(!res){
                    $status.addClass("error").text(T("session"));
                    return;
                }
                if(res.field){
                    $("#" + res.field).addClass("invalid").attr("aria-invalid", "true").trigger("focus");
                    $("#" + res.field + "-error").text(res.message);
                } else {
                    $status.addClass("error").text(res.message);
                }
            }).always(function(){
                $button.prop("disabled", false);
            });
        });
    }

    if($(".pass-toggle").length){
        $(document).on("click", ".pass-toggle", function(){
            var $button = $(this);
            var $input = $("#" + $button.attr("aria-controls"));
            var show = $input.attr("type") === "password";
            $input.attr("type", show ? "text" : "password");
            $button.attr("aria-pressed", show ? "true" : "false").attr("aria-label", $button.attr(show ? "data-hide" : "data-show"));
        });
    }

    function hidePasswords($form){
        $form.find(".pass-toggle[aria-pressed='true']").trigger("click");
    }

    if($(".changepass").length){
        var $pass = $(".changepass");
        var $current = $("#currentpass");
        var $newPass = $("#newpass");
        var $confirm = $("#confirmpass");

        function passRules(value){
            return {
                length: value.length >= 8,
                letter: /[A-Za-z]/.test(value),
                number: /\d/.test(value),
                different: value !== "" && value !== $current.val()
            };
        }

        function updateRules(){
            var met = passRules($newPass.val());
            $pass.find(".pass-rules li").each(function(){
                $(this).toggleClass("met", met[$(this).attr("data-rule")]);
            });
        }

        var passCheck = bindValidation($pass, {
            currentpass: function(value){
                return value ? "" : T("pass.v.current");
            },
            newpass: function(value){
                var met = passRules(value);
                if(!value) return T("pass.v.new");
                if(!met.length) return T("pass.v.short");
                if(value.length > 64) return T("pass.v.long");
                if(!met.letter || !met.number) return T("pass.v.mix");
                if(!met.different) return T("pass.v.same");
                return "";
            },
            confirmpass: function(value){
                if(!value) return T("pass.v.confirm");
                if(value !== $newPass.val()) return T("pass.v.match");
                return "";
            }
        });

        $newPass.on("input", function(){
            updateRules();
            if($confirm.val() !== "" && ($confirm.hasClass("invalid") || $confirm.val().length >= $newPass.val().length)) passCheck.check($confirm);
        });
        $current.on("input", function(){
            updateRules();
            if($newPass.hasClass("invalid")) passCheck.check($newPass);
        });

        $pass.on("submit", function(e){
            e.preventDefault();
            if(!passCheck.all()) return;
            var $status = $pass.find(".form-status");
            var $button = $pass.find("button[type='submit']");
            $button.prop("disabled", true);
            $status.removeClass("error").text("");
            $.ajax({
                url: $pass.attr("action"),
                method: "POST",
                data: $pass.serialize(),
                dataType: "json"
            }).done(function(res){
                hidePasswords($pass);
                $current.add($newPass).add($confirm).val("").removeClass("invalid").attr("aria-invalid", "false");
                $pass.find(".field-error").text("");
                updateRules();
                $status.removeClass("error").text(res.message);
            }).fail(function(xhr){
                var res = xhr.responseJSON;
                if(!res){
                    $status.addClass("error").text(T("session"));
                    return;
                }
                if(res.field){
                    var $input = $("#" + res.field);
                    $input.addClass("invalid").attr("aria-invalid", "true").trigger("focus");
                    $("#" + res.field + "-error").text(res.message);
                } else {
                    $status.addClass("error").text(res.message);
                }
            }).always(function(){
                $button.prop("disabled", false);
            });
        });

        updateRules();
    }

    if($(".st-table").length){
        var $stRows = $(".st-table .st-row");
        var $stCount = $(".st-count");

        function stApply(){
            var query = $.trim($("#stsearch").val()).toLowerCase();
            var shown = 0;
            $stRows.each(function(){
                var match = !query || $(this).text().toLowerCase().indexOf(query) !== -1;
                $(this).toggle(match);
                if(match) shown++;
            });
            $stCount.text($stCount.attr(shown === 1 ? "data-one" : "data-many").split("{0}").join(shown));
            $(".st-empty").prop("hidden", shown > 0);
        }

        $("#stsearch").on("input", stApply);
        stApply();
    }

    var countTargets = $(".st-stat strong, .gr-stats strong, .ex-count");
    if(countTargets.length && !(window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches) && window.requestAnimationFrame){
        countTargets.each(function(){
            var $el = $(this);
            var text = $.trim($el.text());
            if(!/^\d+(\.\d+)?$/.test(text) || +text === 0) return;
            var target = +text;
            var decimals = (text.split(".")[1] || "").length;
            var start = null;
            $el.text((0).toFixed(decimals));
            function step(now){
                if(start === null) start = now;
                var t = Math.min((now - start) / 900, 1);
                var eased = 1 - Math.pow(1 - t, 3);
                $el.text(t < 1 ? (target * eased).toFixed(decimals) : text);
                if(t < 1) window.requestAnimationFrame(step);
            }
            setTimeout(function(){ window.requestAnimationFrame(step); }, 250);
        });
    }

    var anAdd = null;
    var anRemove = null;

    if($(".an-list").length){
        var $anList = $(".an-list");
        var anSpeed = window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches ? 0 : 300;
        var anFilter = "all";
        var anToday = new Date();
        anToday.setHours(0, 0, 0, 0);

        var anItems = $anList.children(".an-item").get();
        anItems.sort(function(a, b){
            return $(b).attr("data-date").localeCompare($(a).attr("data-date"));
        });
        $anList.append(anItems);

        $(anItems).each(function(){
            var p = $(this).attr("data-date").split("-");
            var age = Math.round((anToday - new Date(+p[0], p[1] - 1, +p[2])) / 86400000);
            if(age >= 0 && age <= 2) $(this).find(".an-cat").after($("<span>").addClass("an-new").text(T("an.new")));
        });

        function applyAnFilter(){
            var query = $.trim($("#ansearch").val()).toLowerCase();
            var shown = 0;
            $(anItems).each(function(){
                var $item = $(this);
                var matchCat = anFilter === "all" || $item.attr("data-category") === anFilter;
                var matchText = !query || $item.text().toLowerCase().indexOf(query) !== -1;
                $item.toggle(matchCat && matchText);
                if(matchCat && matchText) shown++;
            });
            $(".an-count").text(TN("an.count", shown));
            $(".an-empty").toggleClass("show", !shown);
        }

        $(".an-chip").on("click", function(){
            anFilter = $(this).attr("data-filter");
            $(".an-chip").removeClass("active").attr("aria-pressed", "false");
            $(this).addClass("active").attr("aria-pressed", "true");
            applyAnFilter();
        });

        $("#ansearch").on("input", applyAnFilter);

        anAdd = function($item){
            $item.find(".an-cat").after($("<span>").addClass("an-new").text(T("an.new")));
            $anList.prepend($item);
            anItems = $anList.children(".an-item").get();
            applyAnFilter();
        };

        anRemove = function(id){
            $anList.children(".an-item").filter(function(){
                return $(this).attr("data-id") === id;
            }).remove();
            anItems = $anList.children(".an-item").get();
            applyAnFilter();
        };

        $(".an-list, .an-mine").on("click", ".an-toggle", function(){
            var $item = $(this).closest(".an-item");
            var opening = !$item.hasClass("open");
            $item.toggleClass("open", opening);
            $(this).attr("aria-expanded", opening).children("span").text(opening ? T("an.less") : T("an.more"));
            $item.find(".an-body").stop(true, true)[opening ? "slideDown" : "slideUp"](anSpeed);
        });

        applyAnFilter();
    }

    if($(".an-form").length){
        var $anForm = $(".an-form");
        var $anMine = $(".an-mine");
        function anMineCount(){
            $(".an-none").prop("hidden", $anMine.children(".an-item").length > 0);
        }

        function anLength(min, max, empty, short, long){
            return function(value){
                value = $.trim(value);
                if(!value) return empty;
                if(value.length < min) return short;
                if(value.length > max) return long;
                return "";
            };
        }

        var anCheck = bindValidation($anForm, {
            ancategory: function(value){
                return value ? "" : T("an.v.category");
            },
            anaudience: function(value){
                return value ? "" : T("an.v.audience");
            },
            antitle: anLength(5, 200, T("an.v.title"), T("an.v.titleshort"), T("an.v.titlelong")),
            ansummary: anLength(10, 500, T("an.v.summary"), T("an.v.summaryshort"), T("an.v.summarylong")),
            anbody: anLength(10, 5000, T("an.v.body"), T("an.v.bodyshort"), T("an.v.bodylong"))
        });

        function anCard(res){
            var $card = $($.trim($("#an-template").html()));
            $card.attr({ "data-id": res.id, "data-category": res.category, "data-date": res.iso });
            $card.find("[data-f]").each(function(){
                $(this).text(res[$(this).attr("data-f")]);
            });
            $card.find(".an-cat").addClass(res.category);
            $card.find(".an-to").text(T("an.to", res.audienceText));
            $card.find(".an-date").attr("datetime", res.iso);
            return $card;
        }

        $anForm.on("submit", function(e){
            e.preventDefault();
            if(!anCheck.all()) return;
            var $status = $anForm.find(".form-status");
            var $button = $anForm.find(".an-submit").prop("disabled", true);
            $status.removeClass("error").text("");
            $.ajax({
                url: $anForm.attr("action"),
                method: "POST",
                data: $anForm.serialize(),
                dataType: "json"
            }).done(function(res){
                var $card = anCard(res);
                $anMine.prepend($card);
                anMineCount();
                if(anAdd && (res.audience === "all" || res.audience === $anMine.attr("data-role"))){
                    var $copy = $card.clone();
                    $copy.find(".an-to, .an-delete").remove();
                    anAdd($copy);
                }
                $anForm[0].reset();
                $anForm.find(".invalid").removeClass("invalid").attr("aria-invalid", "false");
                $anForm.find(".field-error").text("");
                $status.text(res.message);
            }).fail(function(xhr){
                var res = xhr.responseJSON;
                if(!res){
                    $status.addClass("error").text(T("session"));
                } else if(res.field){
                    $("#" + res.field).addClass("invalid").attr("aria-invalid", "true").trigger("focus");
                    $("#" + res.field + "-error").text(res.message);
                } else {
                    $status.addClass("error").text(res.message);
                }
            }).always(function(){
                $button.prop("disabled", false);
            });
        });

        $anMine.on("click", ".an-delete", function(){
            var $btn = $(this);
            var $card = $btn.closest(".an-item");
            var $status = $(".an-status");
            if(!$btn.hasClass("armed")){
                $btn.addClass("armed").text(T("an.confirmdelete"));
                setTimeout(function(){
                    if($btn.hasClass("armed")) $btn.removeClass("armed").text(T("an.delete"));
                }, 4000);
                return;
            }
            $btn.removeClass("armed").prop("disabled", true);
            $status.removeClass("error").text("");
            $.ajax({
                url: $anMine.attr("data-delete-url"),
                method: "POST",
                data: { csrf: $anMine.attr("data-csrf"), id: $card.attr("data-id") },
                dataType: "json"
            }).done(function(res){
                $status.text(res.message);
                if(anRemove) anRemove($card.attr("data-id"));
                $card.fadeOut(200, function(){
                    $card.remove();
                    anMineCount();
                });
            }).fail(function(xhr){
                var res = xhr.responseJSON;
                $btn.prop("disabled", false).text(T("an.delete"));
                $status.addClass("error").text(res ? res.message : T("session"));
            });
        });
    }
})
