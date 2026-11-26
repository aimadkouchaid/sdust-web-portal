package edu.sdust.i18n;

import jakarta.servlet.http.HttpServletRequest;

import java.text.MessageFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.Locale;
import java.util.MissingResourceException;
import java.util.ResourceBundle;
import java.util.TreeSet;

public final class Texts {

    public static final String ATTRIBUTE = "tx";

    private static final String BUNDLE = "i18n.messages";
    private static final ResourceBundle.Control CONTROL = ResourceBundle.Control.getNoFallbackControl(ResourceBundle.Control.FORMAT_PROPERTIES);
    private static final DateTimeFormatter TIME = DateTimeFormatter.ofPattern("HH:mm");

    private final String lang;
    private final Locale locale;
    private final ResourceBundle bundle;

    private Texts(String lang) {
        this.lang = lang;
        this.locale = "zh".equals(lang) ? Locale.SIMPLIFIED_CHINESE : Locale.ENGLISH;
        this.bundle = ResourceBundle.getBundle(BUNDLE, locale, CONTROL);
    }

    public static Texts forLanguage(String lang) {
        return new Texts("zh".equals(lang) ? "zh" : "en");
    }

    public static Texts of(HttpServletRequest req) {
        Object value = req.getAttribute(ATTRIBUTE);
        return value instanceof Texts texts ? texts : forLanguage("en");
    }

    public String getLang() {
        return lang;
    }

    public Locale getLocale() {
        return locale;
    }

    public ResourceBundle getBundle() {
        return bundle;
    }

    public static String fit(String s, int max) {
        return s.length() > max ? s.substring(0, max - 3) + "..." : s;
    }

    public String get(String key) {
        return plain(raw(key));
    }

    public String format(String key, Object... args) {
        return plain(new MessageFormat(raw(key), locale).format(args));
    }

    public String date(LocalDate date) {
        return date == null ? "" : pattern("fmt.date").format(date);
    }

    public String date(LocalDateTime time) {
        return time == null ? "" : date(time.toLocalDate());
    }

    public String dayMonth(LocalDate date) {
        return pattern("fmt.daymonth").format(date);
    }

    public String weekdayDate(LocalDate date) {
        return pattern("fmt.weekdaydate").format(date);
    }

    public String month(LocalDate date) {
        return pattern("fmt.month").format(date).toUpperCase(locale);
    }

    public String weekday(LocalDate date) {
        return pattern("fmt.weekday").format(date);
    }

    public String time(LocalTime time) {
        return TIME.format(time);
    }

    public String dateRange(LocalDate start, LocalDate end) {
        if (start.equals(end)) {
            return date(start);
        }
        if (start.getYear() == end.getYear()) {
            return pattern("fmt.rangestart").format(start) + " – " + date(end);
        }
        return date(start) + " – " + date(end);
    }

    public String json(String prefix) {
        StringBuilder out = new StringBuilder("{");
        for (String key : new TreeSet<>(Collections.list(bundle.getKeys()))) {
            if (!key.startsWith(prefix)) {
                continue;
            }
            if (out.length() > 1) {
                out.append(',');
            }
            out.append(quote(key.substring(prefix.length()))).append(':').append(quote(get(key)));
        }
        return out.append('}').toString();
    }

    private String raw(String key) {
        try {
            return bundle.getString(key);
        } catch (MissingResourceException e) {
            return key;
        }
    }

    private DateTimeFormatter pattern(String key) {
        return DateTimeFormatter.ofPattern(raw(key), locale);
    }

    private static String plain(String s) {
        return s.replace("&lt;", "<").replace("&gt;", ">").replace("&quot;", "\"").replace("&#39;", "'").replace("&amp;", "&");
    }

    private static String quote(String s) {
        StringBuilder out = new StringBuilder("\"");
        for (char c : s.toCharArray()) {
            switch (c) {
                case '"' -> out.append("\\\"");
                case '\\' -> out.append("\\\\");
                case '<' -> out.append("\\u003c");
                case '>' -> out.append("\\u003e");
                case '&' -> out.append("\\u0026");
                default -> {
                    if (c < 0x20) {
                        out.append(String.format("\\u%04x", (int) c));
                    } else {
                        out.append(c);
                    }
                }
            }
        }
        return out.append('"').toString();
    }
}
