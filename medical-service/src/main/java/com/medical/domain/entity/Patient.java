package com.medical.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 患者档案（与表 patient 对应，sys_user 中 PATIENT 角色应对应一行）
 */
@Data
@TableName("patient")
public class Patient {
    @TableId(type = IdType.AUTO)
    private Long patientId;
    private Long userId;
    private String patientNo;
    private String name;
    private String idCard;
    private String gender;
    private LocalDate birthDate;
    private String phone;
    private String email;
    private String address;
    private String avatarUrl;
    private String bloodType;
    private String allergyHistory;
    private String chronicDiseases;
    private String emergencyContact;
    private String emergencyPhone;
    private Integer status;
    private String remark;
    private LocalDateTime createdTime;
    private LocalDateTime updatedTime;
    private String createdBy;
    private String updatedBy;
}
