$(document).ready(function () {

    $(".hamburger-menu").click(function () {

        $(this).toggleClass("active");

        if ($(this).hasClass("active")) {
            $(".menu").stop(true, true).slideDown(300);
        } else {
            $(".menu").stop(true, true).slideUp(300);
        }

        const isOpen = $(this).hasClass("active");

        $(this).attr("aria-expanded", isOpen);
        $(this).attr("aria-label", isOpen ? "Close navigation" : "Open navigation");
    });

    $(".menu a").click(function () {
        if (!$(".hamburger-menu").is(":visible")) return;

        $(".hamburger-menu").removeClass("active");
        $(".menu").stop(true, true).slideUp(300);

        $(".hamburger-menu")
            .attr("aria-expanded", "false")
            .attr("aria-label", "Open navigation");

    });

    $(window).on("resize", function () {
        if (window.innerWidth > 1000) {
            $(".menu").removeAttr("style");
            $(".hamburger-menu")
                .removeClass("active")
                .attr("aria-expanded", "false")
                .attr("aria-label", "Open navigation");
        }
    });

    const $uniData = $("#uni-data");
    const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

    $uniData.find(".datanum").each(function () {
        const text = $(this).text().trim();
        $(this).data({
            prefix: text.startsWith("+") ? "+" : "",
            commas: text.includes(",")
        });
    });

    function formatNum($el, value) {
        const num = $el.data("commas") ? value.toLocaleString("en-US") : String(value);
        return $el.data("prefix") + num;
    }

    function countUp(index, el) {
        const $el = $(el);
        const target = parseInt($el.data("target"), 10);
        const duration = 1800;
        const startDelay = index * 120;
        let startTime = null;

        cancelAnimationFrame(el._countFrame);
        $el.text(formatNum($el, 0));

        function step(now) {
            if (startTime === null) startTime = now + startDelay;
            const progress = Math.min(Math.max((now - startTime) / duration, 0), 1);
            const eased = 1 - Math.pow(1 - progress, 3);
            $el.text(formatNum($el, Math.round(target * eased)));
            if (progress < 1) el._countFrame = requestAnimationFrame(step);
        }
        el._countFrame = requestAnimationFrame(step);
    }

    function resetNumbers() {
        $uniData.find(".datanum").each(function () {
            cancelAnimationFrame(this._countFrame);
            $(this).text(formatNum($(this), 0));
        });
    }

    if ($uniData.length) {
        if (reduceMotion || !("IntersectionObserver" in window)) {
            $uniData.addClass("in-view");
        } else {
            const observer = new IntersectionObserver(function (entries) {
                entries.forEach(function (entry) {
                    if (entry.isIntersecting) {
                        $uniData.addClass("in-view");
                        $uniData.find(".datanum").each(countUp);
                    } else {
                        $uniData.removeClass("in-view");
                        resetNumbers();
                    }
                });
            }, { threshold: 0.35 });

            observer.observe($uniData[0]);
        }
    }

    const $animated = $("[data-animate]");
    const scrollAnimations = $("#uni-data").length > 0;

    if (reduceMotion || !scrollAnimations || !("IntersectionObserver" in window)) {
        $animated.addClass("in-view");
    } else {
        const sectionObserver = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                const $target = $(entry.target);
                if (entry.intersectionRatio >= 0.3) {
                    $target.addClass("in-view");
                } else if (!entry.isIntersecting) {
                    $target.removeClass("in-view");
                }
            });
        }, { threshold: [0, 0.3] });

        $animated.addClass("anim-ready").each(function () {
            sectionObserver.observe(this);
        });
    }

    function useNewsFallback(img) {
        const $fallback = $('<div class="news-img-fallback" role="img"></div>')
            .attr("aria-label", img.alt || "SDUST news")
            .append($('<img alt="">').attr("src", $(".nav-logo img").attr("src")));
        $(img).replaceWith($fallback);
    }

    $(".news-card > img").each(function () {
        if (this.complete && this.naturalWidth === 0) {
            useNewsFallback(this);
        } else {
            $(this).one("error", function () { useNewsFallback(this); });
        }
    });

    $(".news-track").each(function () {
        $(this).children().clone(true)
            .attr("aria-hidden", "true")
            .attr("tabindex", "-1")
            .appendTo(this);
    });

    const $vdSection = $("#campus-video");

    if ($vdSection.length) {
        const video = $vdSection.find(".vd-media")[0];

        if (reduceMotion) {
            video.removeAttribute("autoplay");
            video.pause();
        } else if ("IntersectionObserver" in window) {
            new IntersectionObserver(function (entries) {
                entries.forEach(function (entry) {
                    if (entry.isIntersecting) {
                        video.play().catch(function () {});
                    } else if (!video.paused) {
                        video.pause();
                    }
                });
            }).observe($vdSection[0]);
        }
    }


    const $backToTop = $(".back-to-top");

    if ($backToTop.length) {
        const toggleBackToTop = function () {
            $backToTop.toggleClass("visible", $(window).scrollTop() > 400);
        };

        $(window).on("scroll", toggleBackToTop);
        toggleBackToTop();

        $backToTop.on("click", function () {
            window.scrollTo({ top: 0, behavior: reduceMotion ? "auto" : "smooth" });
        });
    }

    if ($(".pass-toggle").length) {
        $(document).on("click", ".pass-toggle", function(){
            const $button = $(this);
            const $input = $("#" + $button.attr("aria-controls"));
            const show = $input.attr("type") === "password";
            $input.attr("type", show ? "text" : "password");
            $button.attr("aria-pressed", show ? "true" : "false").attr("aria-label", $button.attr(show ? "data-hide" : "data-show"));
        });
    }

    const $loginForm = $(".login-form");

    if ($loginForm.length) {
        const $role = $("#loginas");
        const $userId = $("#userid");
        const $password = $("#password");
        const $alert = $("#login-alert");
        const idLabel = function () {
            return $role.val() === "Student" ? "student" : "staff";
        };

        const showAlert = function (message) {
            $alert.removeClass("info shake").attr("hidden", false);
            $alert.find(".login-alert-text").text(message);
            void $alert[0].offsetWidth;
            $alert.addClass("shake");
        };

        const hideAlert = function () {
            $alert.attr("hidden", true).removeClass("shake");
        };

        const markField = function ($input, invalid) {
            $input.toggleClass("invalid", invalid).attr("aria-invalid", invalid ? "true" : "false");
        };

        const syncRole = function () {
            $("label[for='userid']").text($loginForm.data("label-" + idLabel()));
            $userId.attr("placeholder", $loginForm.data("placeholder-" + idLabel()));
        };

        $loginForm.on("input", "input", function () {
            if ($(this).hasClass("invalid") && $(this).val() !== "") markField($(this), false);
            if (!$loginForm.find("input.invalid").length && $alert.hasClass("client")) {
                hideAlert();
                $alert.removeClass("client");
            }
        });

        $role.on("change", syncRole);

        $loginForm.on("submit", function (e) {
            const missingId = $.trim($userId.val()) === "";
            const missingPassword = $password.val() === "";
            markField($userId, missingId);
            markField($password, missingPassword);

            if (!missingId && !missingPassword) {
                $loginForm.find(".pass-toggle[aria-pressed='true']").trigger("click");
                return;
            }

            e.preventDefault();
            let message = $loginForm.data("password");
            if (missingId && missingPassword) message = $loginForm.data("missing-" + idLabel());
            else if (missingId) message = $loginForm.data("id-" + idLabel());
            showAlert(message);
            $alert.addClass("client");
            (missingId ? $userId : $password).trigger("focus");
        });

        syncRole();
    }

    if($(".login-forgot").length){
        $(".login-forgot").on("click", function(){
            var $note = $("#forgot-note");
            var open = !$note.is(":visible");
            var speed = reduceMotion ? 0 : 280;
            $(this).attr("aria-expanded", open);
            if(open){
                $note.prop("hidden", false).hide().stop(true, true).slideDown(speed);
            } else {
                $note.stop(true, true).slideUp(speed, function(){
                    $note.prop("hidden", true);
                });
            }
        });
    }
});
