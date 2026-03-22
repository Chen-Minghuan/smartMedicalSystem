package com.medical.domain.dto;

import lombok.Data;

/**
 * 角色信息更新 DTO
 */
@Data
public class RoleUpdateDto {
    private String roleName;
    private String description;
}
