package edu.sdust.web;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/language")
public class LanguageServlet extends HttpServlet {

    private static final int ONE_YEAR = 60 * 60 * 24 * 365;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String to = req.getParameter("to");
        if (to != null && LanguageFilter.LANGUAGES.contains(to)) {
            Cookie cookie = new Cookie(LanguageFilter.COOKIE, to);
            cookie.setPath(req.getContextPath().isEmpty() ? "/" : req.getContextPath());
            cookie.setMaxAge(ONE_YEAR);
            cookie.setHttpOnly(true);
            cookie.setAttribute("SameSite", "Lax");
            resp.addCookie(cookie);
        }

        String back = req.getParameter("back");
        boolean safe = back != null && back.startsWith("/") && !back.startsWith("//") && !back.contains("\\")
                && !back.startsWith("/language");
        resp.sendRedirect(req.getContextPath() + (safe ? back : "/home"));
    }
}
