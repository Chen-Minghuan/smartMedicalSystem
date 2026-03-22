package com.medical.domain.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 用户列表 VO（含角色名称）
 */
@Data
public class UserListVo {
    private Long userId;
    private String username;
    private String name;
    private String email;
    private String mobilePhone;
    private Integer status;
    private List<String> roleNames;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createdTime;
}
