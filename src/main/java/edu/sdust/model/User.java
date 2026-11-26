package edu.sdust.model;

import java.io.Serializable;

public class User implements Serializable {

    private static final long serialVersionUID = 2L;

    private final String id;
    private final String role;
    private final String name;

    public User(String id, String role, String name) {
        this.id = id;
        this.role = role;
        this.name = name;
    }

    public String getId() {
        return id;
    }

    public String getRole() {
        return role;
    }

    public String getName() {
        return name;
    }

    public String getInitial() {
        return name.isBlank() ? "?" : name.trim().substring(0, 1).toUpperCase();
    }
}
