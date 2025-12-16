package com.kumarent.model;

import java.sql.Timestamp;

public class Offer {

    private int id;
    private String message;
    private boolean active;
    private Timestamp createdAt;

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public String getMessage() {
        return message;
    }
    public void setMessage(String message) {
        this.message = message;
    }

    public boolean isActive() {
        return active;
    }
    public void setActive(boolean active) {
        this.active = active;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
