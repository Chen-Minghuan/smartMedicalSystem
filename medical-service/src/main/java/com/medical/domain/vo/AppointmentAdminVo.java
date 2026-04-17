package com.medical.domain.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 管理端 - 预约信息 VO
 */
@Data
public class AppointmentAdminVo {
    private Long appointmentId;
    private String appointmentNo;

    // 医生信息
    private Long doctorId;
    private String doctorName;
    private String doctorTitle;
    private Long deptId;
    private String deptName;

    // 患者信息
    private Long patientId;
    private String patientName;
    private String patientPhone;

    // 预约信息
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate appointmentDate;
    private String timeSlot;
    private Integer queueNo;
    private Integer status;
    private String statusText;
    private BigDecimal feeAmount;
    private Integer paid;

    // 时间信息
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime paidTime;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime checkInTime;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createdTime;

    private String remark;
}