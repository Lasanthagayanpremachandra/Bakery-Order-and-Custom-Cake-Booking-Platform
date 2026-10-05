package com.bakery.util;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Utility class for locating and initializing data storage flat files.
 */
public class FileUtil {
    private static final String DATA_DIR_NAME = "data";

    public static Path getDataFilePath(String fileName) {
        File dataDir = new File("data");
        if (!dataDir.exists()) {
            dataDir = new File(System.getProperty("user.dir"), "data");
        }
        if (!dataDir.exists()) {
            File fallback = new File("/Volumes/Transcend/Bakery Order and Custom Cake Booking Platform /data");
            if (fallback.exists()) {
                dataDir = fallback;
            } else {
                dataDir.mkdirs();
            }
        }
        if (!dataDir.exists()) {
            dataDir.mkdirs();
        }
        File targetFile = new File(dataDir, fileName);
        if (!targetFile.exists()) {
            try {
                if (targetFile.getParentFile() != null && !targetFile.getParentFile().exists()) {
                    targetFile.getParentFile().mkdirs();
                }
                targetFile.createNewFile();
            } catch (IOException e) {
                System.err.println("Notice: Could not create " + fileName + ": " + e.getMessage());
            }
        }
        return targetFile.toPath();
    }
}
