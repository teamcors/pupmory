package com.hamahama.pupmory.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class Message {
    private String role;
    private String content;

    public Message(String message) {
        this.role = "user";
        this.content = message;
    }
}