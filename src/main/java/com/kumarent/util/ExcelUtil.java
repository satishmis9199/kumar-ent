package com.kumarent.util;

import org.apache.poi.ss.usermodel.*;

public class ExcelUtil {

    public static String getString(Cell cell) {
        if (cell == null) return null;

        cell.setCellType(CellType.STRING);
        String val = cell.getStringCellValue();
        return val != null ? val.trim() : null;
    }

    public static double getDouble(Cell cell) {
        if (cell == null) return 0.0;

        if (cell.getCellType() == CellType.NUMERIC) {
            return cell.getNumericCellValue();
        }

        if (cell.getCellType() == CellType.STRING) {
            try {
                return Double.parseDouble(cell.getStringCellValue().trim());
            } catch (Exception e) {
                return 0.0;
            }
        }
        return 0.0;
    }

    public static int getInt(Cell cell) {
        return (int) getDouble(cell);
    }
}
