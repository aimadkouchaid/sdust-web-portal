package edu.sdust.web;

import edu.sdust.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String role = "student";
        HttpSession session = req.getSession(false);
        if (session != null) {
            Object user = session.getAttribute(LoginServlet.SESSION_USER);
            if (user instanceof User) {
                role = ((User) user).getRole();
            }
            session.invalidate();
        }
        resp.sendRedirect(req.getContextPath() + "/login?role=" + role + "&logout=1");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        doGet(req, resp);
    }
}
