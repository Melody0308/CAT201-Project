package com.bookstore.util;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

/**
 * Order number generator utility class
 */
public class OrderNoUtil {
    
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyyMMddHHmmss");
    private static final Random RANDOM = new Random();
    
    /**
     * Generate unique order number
     * Format: timestamp + 4 random digits
     */
    public static synchronized String generate() {
        String timestamp = DATE_FORMAT.format(new Date());
        int randomNum = RANDOM.nextInt(9000) + 1000;
        return timestamp + randomNum;
    }
}
