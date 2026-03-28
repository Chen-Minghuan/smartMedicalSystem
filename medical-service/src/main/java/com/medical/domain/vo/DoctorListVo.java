package com.medical.domain.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 医生列表 VO（含科室名、系统用户名）
 */
@Data
public class DoctorListVo {
    private Long doctorId;
    private Long userId;
    private String doctorNo;
    private String name;
    private Long deptId;
    /** 科室名称（关联填充） */
    private String deptName;
    /** 关联 sys_user.username */
    private String username;
    private String title;
    private String specialty;
    private String introduction;
    private String avatarUrl;
    private String phone;
    private BigDecimal consultationFee;
    private Integer status;
    private Integer sortOrder;
    private String remark;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createdTime;
}
