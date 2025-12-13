package com.kumarent.util;

import java.security.SecureRandom;

public class OrderIdGenerator {
    private static final SecureRandom rnd = new SecureRandom();
    private static final String PREFIX = "KUMTRAENT";

    public static String generate() {
        int num = rnd.nextInt(900000) + 100000;
        return PREFIX + num;
    }
}
