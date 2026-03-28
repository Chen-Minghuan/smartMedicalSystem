package com.medical.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("nurse")
public class Nurse {
    @TableId(type = IdType.AUTO)
    private Long nurseId;
    private Long userId;
    private String nurseNo;
    private String name;
    private Long deptId;
    private String title;
    private String phone;
    private Integer status;
    private Integer sortOrder;
    private String remark;
    private LocalDateTime createdTime;
    private LocalDateTime updatedTime;
    private String createdBy;
    private String updatedBy;
}
