package com.medical.domain.dto;

import lombok.Data;

/**
 * 用户信息更新 DTO
 */
@Data
public class UserUpdateDto {
    private String name;
    private String email;
    private String mobilePhone;
}
