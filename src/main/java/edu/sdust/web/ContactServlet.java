package edu.sdust.web;

import edu.sdust.dao.UserDao;
import edu.sdust.i18n.Texts;
import edu.sdust.model.Contact;
import edu.sdust.model.User;
import jakarta.servlet.annotation.WebInitParam;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;
import java.util.regex.Pattern;

@WebServlet(urlPatterns = "/dashboard/profile/contact",
        initParams = @WebInitParam(name = "roles", value = "student,teacher,counselor"))
public class ContactServlet extends HttpServlet {

    private static final Pattern EMAIL = Pattern.compile("[^\\s@]+@[^\\s@]+\\.[^\\s@]{2,}");
    private static final Pattern PHONE = Pattern.compile("1[3-9]\\d{9}");

    private final UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        User user = (User) req.getSession(false).getAttribute(LoginServlet.SESSION_USER);

        if (!FormSupport.tokenMatches(req)) {
            FormSupport.reply(resp, 403, null, Texts.of(req).get("srv.badtoken"));
            return;
        }

        String email = FormSupport.value(req.getParameter("email")).trim();
        String rawPhone = FormSupport.value(req.getParameter("phonenumber")).trim();
        String phone = rawPhone.replaceAll("[\\s-]", "").replaceFirst("^\\+?86", "");

        if (email.isEmpty()) {
            FormSupport.reply(resp, 400, "email", Texts.of(req).get("js.contact.v.email"));
            return;
        }
        if (email.length() > 100 || !EMAIL.matcher(email).matches()) {
            FormSupport.reply(resp, 400, "email", Texts.of(req).get("js.contact.v.emailinvalid"));
            return;
        }
        if (rawPhone.isEmpty()) {
            FormSupport.reply(resp, 400, "phonenumber", Texts.of(req).get("js.contact.v.phone"));
            return;
        }
        if (!PHONE.matcher(phone).matches()) {
            FormSupport.reply(resp, 400, "phonenumber", Texts.of(req).get("js.phone.invalid"));
            return;
        }

        Contact contact = new Contact(email, phone);
        try {
            if (contact.equals(userDao.findContact(user.getId()))) {
                FormSupport.reply(resp, 400, null, Texts.of(req).get("js.contact.unchanged"));
                return;
            }
            userDao.updateContact(user.getId(), contact);
        } catch (SQLException e) {
            log("Contact update failed because the database could not be reached", e);
            FormSupport.reply(resp, 503, null, Texts.of(req).get("srv.db"));
            return;
        }

        FormSupport.reply(resp, 200, null, Texts.of(req).get("srv.contact.saved"), Map.of("email", email, "phone", phone));
    }
}
