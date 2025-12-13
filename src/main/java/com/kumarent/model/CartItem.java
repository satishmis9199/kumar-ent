package com.kumarent.model;

import java.io.Serializable;

public class CartItem implements Serializable {
    private int materialId;
    private String name;
    private int qty;
    private double price;

    public CartItem() {}
    public CartItem(int materialId, String name, int qty, double price) {
        this.materialId = materialId;
        this.name = name;
        this.qty = qty;
        this.price = price;
    }

    public int getMaterialId() { return materialId; }
    public void setMaterialId(int materialId) { this.materialId = materialId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getQty() { return qty; }
    public void setQty(int qty) { this.qty = qty; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
}
