package com.medical.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 药品
 */
@Data
@TableName("medicine")
public class Medicine {
    @TableId(type = IdType.AUTO)
    private Long medicineId;
    private String medicineCode;
    private String name;
    private String commonName;
    private Long categoryId;
    private String spec;
    private String unit;
    private String manufacturer;
    private String approvalNo;
    private BigDecimal unitPrice;
    private BigDecimal costPrice;
    private Integer stockQuantity;
    private Integer minStock;
    private Integer status;
    private String remark;
    private LocalDateTime createdTime;
    private LocalDateTime updatedTime;
    private String createdBy;
    private String updatedBy;
}
