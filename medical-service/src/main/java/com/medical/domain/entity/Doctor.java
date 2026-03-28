package com.medical.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 医生（与表 doctor 对应）
 */
@Data
@TableName("doctor")
public class Doctor {
    @TableId(type = IdType.AUTO)
    private Long doctorId;
    private Long userId;
    private String doctorNo;
    private String name;
    private Long deptId;
    private String title;
    private String specialty;
    private String introduction;
    private String avatarUrl;
    private String phone;
    private BigDecimal consultationFee;
    private Integer status;
    private Integer sortOrder;
    private String remark;
    private LocalDateTime createdTime;
    private LocalDateTime updatedTime;
    private String createdBy;
    private String updatedBy;
}
