package edu.sdust.web;

import com.lowagie.text.Chunk;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import edu.sdust.i18n.Texts;
import jakarta.servlet.http.HttpServletResponse;

import java.awt.Color;
import java.io.IOException;
import java.io.InputStream;
import java.io.UncheckedIOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;

final class PdfSupport {

    static final Color BLUE = new Color(0x00, 0x4A, 0x9F);
    static final Color TEXT = new Color(0x1F, 0x29, 0x37);
    static final Color MUTED = new Color(0x6B, 0x72, 0x80);
    static final Color LINE = new Color(0xE6, 0xED, 0xF6);
    static final Color GREEN = new Color(0x2F, 0x85, 0x5A);
    static final Color WHITE = Color.WHITE;

    private static BaseFont font;

    private PdfSupport() {
    }

    static synchronized BaseFont font() {
        if (font == null) {
            try (InputStream in = PdfSupport.class.getResourceAsStream("/fonts/NotoSansSC-Regular.ttf")) {
                if (in == null) {
                    throw new IllegalStateException("fonts/NotoSansSC-Regular.ttf is missing from the classpath");
                }
                font = BaseFont.createFont("NotoSansSC-Regular.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED, true, in.readAllBytes(), null);
            } catch (IOException e) {
                throw new UncheckedIOException(e);
            } catch (DocumentException e) {
                throw new IllegalStateException(e);
            }
        }
        return font;
    }

    static Phrase text(String s, float size, Color color) {
        return new Phrase(s == null ? "" : s, new Font(font(), size, Font.NORMAL, color));
    }

    static Phrase bold(String s, float size, Color color) {
        Chunk chunk = new Chunk(s == null ? "" : s, new Font(font(), size, Font.NORMAL, color));
        chunk.setTextRenderMode(PdfContentByte.TEXT_RENDER_MODE_FILL_STROKE, size / 28f, color);
        return new Phrase(chunk);
    }

    static void header(Document doc, Texts tx, String title, String subtitle) throws DocumentException {
        Paragraph school = new Paragraph(bold(tx.get("pdf.school").toUpperCase(tx.getLocale()), 9, BLUE));
        school.setSpacingAfter(2);
        doc.add(school);
        Paragraph heading = new Paragraph(bold(title, 18, TEXT));
        heading.setSpacingAfter(6);
        doc.add(heading);
        PdfPTable line = new PdfPTable(2);
        line.setWidthPercentage(100);
        line.setWidths(new float[]{3, 2});
        PdfPCell left = cell(text(subtitle, 10, MUTED));
        PdfPCell right = cell(text(tx.format("pdf.generated", tx.date(LocalDate.now())), 9, MUTED));
        right.setHorizontalAlignment(Element.ALIGN_RIGHT);
        for (PdfPCell c : new PdfPCell[]{left, right}) {
            c.setBorder(PdfPCell.BOTTOM);
            c.setBorderWidthBottom(1.5f);
            c.setBorderColorBottom(BLUE);
            c.setPaddingBottom(8);
            line.addCell(c);
        }
        line.setSpacingAfter(14);
        doc.add(line);
    }

    static PdfPCell cell(Phrase phrase) {
        PdfPCell cell = new PdfPCell(phrase);
        cell.setBorder(PdfPCell.NO_BORDER);
        cell.setPadding(0);
        return cell;
    }

    static void send(HttpServletResponse resp, String fileName, byte[] pdf) throws IOException {
        resp.setContentType("application/pdf");
        resp.setContentLength(pdf.length);
        resp.setHeader("X-Content-Type-Options", "nosniff");
        resp.setHeader("Content-Disposition", "attachment; filename*=UTF-8''"
                + URLEncoder.encode(fileName, StandardCharsets.UTF_8).replace("+", "%20"));
        resp.getOutputStream().write(pdf);
    }
}
