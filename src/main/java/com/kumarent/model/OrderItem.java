package com.kumarent.model;

public class OrderItem {
    private int id;
    private int orderId;
    private int materialId;
    private String materialName;
    private int quantity;
    private double priceEach;

    public OrderItem() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public int getMaterialId() { return materialId; }
    public void setMaterialId(int materialId) { this.materialId = materialId; }
    public String getMaterialName() { return materialName; }
    public void setMaterialName(String materialName) { this.materialName = materialName; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public double getPriceEach() { return priceEach; }
    public void setPriceEach(double priceEach) { this.priceEach = priceEach; }
}
