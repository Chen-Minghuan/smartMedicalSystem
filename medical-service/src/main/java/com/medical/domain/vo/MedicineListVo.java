package com.medical.domain.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 药品列表 VO
 */
@Data
public class MedicineListVo {
    private Long medicineId;
    private String medicineCode;
    private String name;
    private String commonName;
    private Long categoryId;
    /** 分类名称（关联查询填充） */
    private String categoryName;
    private String spec;
    private String unit;
    private String manufacturer;
    private String approvalNo;
    private BigDecimal unitPrice;
    private BigDecimal costPrice;
    private Integer stockQuantity;
    private Integer minStock;
    private Integer status;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createdTime;
}
