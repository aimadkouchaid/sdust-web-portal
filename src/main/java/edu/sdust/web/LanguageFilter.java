package edu.sdust.web;

import edu.sdust.i18n.Texts;
import jakarta.servlet.DispatcherType;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.jsp.jstl.core.Config;
import jakarta.servlet.jsp.jstl.fmt.LocalizationContext;

import java.io.IOException;
import java.util.Set;

@WebFilter(urlPatterns = "/*", dispatcherTypes = {DispatcherType.REQUEST, DispatcherType.ERROR})
public class LanguageFilter extends HttpFilter {

    public static final String COOKIE = "lang";
    public static final Set<String> LANGUAGES = Set.of("en", "zh");

    @Override
    protected void doFilter(HttpServletRequest req, HttpServletResponse resp, FilterChain chain) throws IOException, ServletException {
        String lang = "en";
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (COOKIE.equals(cookie.getName()) && LANGUAGES.contains(cookie.getValue())) {
                    lang = cookie.getValue();
                }
            }
        }

        Texts texts = Texts.forLanguage(lang);
        Config.set(req, Config.FMT_LOCALIZATION_CONTEXT, new LocalizationContext(texts.getBundle(), texts.getLocale()));
        Config.set(req, Config.FMT_LOCALE, texts.getLocale());
        req.setAttribute(Texts.ATTRIBUTE, texts);

        req.setAttribute("lang", lang);
        req.setAttribute("htmlLang", "zh".equals(lang) ? "zh-CN" : "en");
        if (req.getDispatcherType() == DispatcherType.REQUEST) {
            String path = req.getRequestURI().substring(req.getContextPath().length());
            if ("GET".equals(req.getMethod()) && req.getQueryString() != null) {
                path += "?" + req.getQueryString();
            }
            req.setAttribute("currentPath", path);
        }
        chain.doFilter(req, resp);
    }
}
