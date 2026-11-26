package edu.sdust.web;

import edu.sdust.model.User;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRegistration;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.Arrays;
import java.util.HexFormat;
import java.util.Map;

@WebFilter("/dashboard/*")
public class AuthFilter extends HttpFilter {

    private static final Map<String, String> HOME = Map.of(
            "student", "/dashboard/timetable",
            "teacher", "/dashboard/teacher/timetable",
            "counselor", "/dashboard/counselor/leave");

    public static final String SESSION_CSRF = "csrf";

    private static final SecureRandom RANDOM = new SecureRandom();

    @Override
    protected void doFilter(HttpServletRequest req, HttpServletResponse resp, FilterChain chain) throws IOException, ServletException {
        HttpSession session = req.getSession(false);
        Object user = session == null ? null : session.getAttribute(LoginServlet.SESSION_USER);

        if (!(user instanceof User)) {
            if ("GET".equals(req.getMethod())) {
                String next = req.getRequestURI() + (req.getQueryString() == null ? "" : "?" + req.getQueryString());
                req.getSession(true).setAttribute(LoginServlet.SESSION_NEXT, next);
            }
            String uri = req.getRequestURI();
            String loginRole = uri.contains("/dashboard/teacher") ? "teacher" : uri.contains("/dashboard/counselor") ? "counselor" : "student";
            resp.sendRedirect(req.getContextPath() + "/login?role=" + loginRole);
            return;
        }

        String role = ((User) user).getRole();
        String home = req.getContextPath() + HOME.getOrDefault(role, "/dashboard/profile");
        String path = req.getRequestURI().substring(req.getContextPath().length());
        if (path.equals("/dashboard") || path.equals("/dashboard/") || !allowed(req, role)) {
            resp.sendRedirect(home);
            return;
        }

        if (session.getAttribute(SESSION_CSRF) == null) {
            byte[] token = new byte[32];
            RANDOM.nextBytes(token);
            session.setAttribute(SESSION_CSRF, HexFormat.of().formatHex(token));
        }

        resp.setHeader("Cache-Control", "no-store");
        chain.doFilter(req, resp);
    }

    private boolean allowed(HttpServletRequest req, String role) {
        ServletRegistration registration = getServletContext().getServletRegistration(req.getHttpServletMapping().getServletName());
        String roles = registration == null ? null : registration.getInitParameter("roles");
        return roles != null && Arrays.asList(roles.split(",")).contains(role);
    }
}
