package edu.sdust.web;

import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

final class UploadStore {

    private static final Path ROOT = root();

    private UploadStore() {
    }

    private static Path root() {
        String configured = System.getenv("SDUST_UPLOAD_DIR");
        Path base = configured == null || configured.isBlank()
                ? Paths.get(System.getProperty("user.home"), "sdust-uploads")
                : Paths.get(configured);
        return base.toAbsolutePath().normalize();
    }

    static String save(String folder, Part part, String extension) throws IOException {
        Path dir = ROOT.resolve(folder);
        Files.createDirectories(dir);
        String name = UUID.randomUUID() + "." + extension;
        try (InputStream in = part.getInputStream()) {
            Files.copy(in, dir.resolve(name), StandardCopyOption.REPLACE_EXISTING);
        }
        return folder + "/" + name;
    }

    static Path resolve(String stored) {
        Path path = ROOT.resolve(stored).normalize();
        return path.startsWith(ROOT) ? path : null;
    }

    static void delete(String stored) {
        Path path = stored == null ? null : resolve(stored);
        if (path != null) {
            try {
                Files.deleteIfExists(path);
            } catch (IOException ignored) {
            }
        }
    }
}
