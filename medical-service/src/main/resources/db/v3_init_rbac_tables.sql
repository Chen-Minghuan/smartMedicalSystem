-- ============================================================
-- 智能医疗服务管理系统 - RBAC 权限表及示例数据
-- 版本：v3
-- 说明：sys_user、sys_role、sys_user_role 表结构及 50+ 条示例数据
-- 数据库：MySQL 8.x，字符集：utf8mb4
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

USE `medical_service`;

-- ----------------------------
-- 1. 表结构定义（与开发文档保持一致）
-- ----------------------------

DROP TABLE IF EXISTS `sys_user_role`;
DROP TABLE IF EXISTS `sys_user`;
DROP TABLE IF EXISTS `sys_role`;

-- 角色表
CREATE TABLE `sys_role` (
  `role_id` bigint NOT NULL AUTO_INCREMENT,
  `role_code` varchar(50) NOT NULL,
  `role_name` varchar(50) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `status` tinyint DEFAULT 1 COMMENT '1=启用 0=禁用',
  `created_time` datetime DEFAULT NULL,
  `updated_time` datetime DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `updated_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `uk_role_code` (`role_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 用户表
CREATE TABLE `sys_user` (
  `user_id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `mobile_phone` varchar(20) DEFAULT NULL,
  `avatar_url` varchar(500) DEFAULT NULL,
  `dept_id` bigint DEFAULT NULL,
  `status` tinyint DEFAULT 1 COMMENT '1=启用 0=禁用',
  `last_login_ip` varchar(50) DEFAULT NULL,
  `last_login_time` datetime DEFAULT NULL,
  `remark` varchar(500) DEFAULT NULL,
  `created_time` datetime DEFAULT NULL,
  `updated_time` datetime DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `updated_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 用户-角色关联表
CREATE TABLE `sys_user_role` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `role_id` bigint NOT NULL,
  `created_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_role` (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- 2. sys_role 示例数据（50+ 条）
-- ----------------------------

INSERT INTO `sys_role` (`role_code`, `role_name`, `description`, `status`, `created_time`, `updated_time`) VALUES
('SUPER_ADMIN', '超级管理员', '系统最高权限', 1, NOW(), NOW()),
('ADMIN', '医院管理员', '日常运维管理', 1, NOW(), NOW()),
('RECEPTIONIST', '挂号收费员', '前台挂号收费', 1, NOW(), NOW()),
('DOCTOR', '医生', '门诊接诊', 1, NOW(), NOW()),
('NURSE', '护士/药师', '发药、导诊', 1, NOW(), NOW()),
('PATIENT', '患者', '患者自助服务', 1, NOW(), NOW()),
('DEPT_DIRECTOR', '科主任', '科室负责人', 1, NOW(), NOW()),
('PHARMACY_MANAGER', '药房主管', '药房管理', 1, NOW(), NOW()),
('FINANCE_MANAGER', '财务主管', '财务核算', 1, NOW(), NOW()),
('IT_ADMIN', '信息科管理员', '系统运维', 1, NOW(), NOW()),
('QC_OFFICER', '质控员', '医疗质量把控', 1, NOW(), NOW()),
('LAB_TECH', '检验科技师', '检验科工作', 1, NOW(), NOW()),
('RADIOLOGY_TECH', '放射科技师', '影像科工作', 1, NOW(), NOW()),
('ER_DOCTOR', '急诊科医师', '急诊接诊', 1, NOW(), NOW()),
('PEDIATRICIAN', '儿科医师', '儿科门诊', 1, NOW(), NOW()),
('INTERNIST', '内科医师', '内科门诊', 1, NOW(), NOW()),
('SURGEON', '外科医师', '外科门诊', 1, NOW(), NOW()),
('GYNECOLOGIST', '妇产科医师', '妇产科门诊', 1, NOW(), NOW()),
('ORTHOPEDIST', '骨科医师', '骨科门诊', 1, NOW(), NOW()),
('DERMATOLOGIST', '皮肤科医师', '皮肤科门诊', 1, NOW(), NOW()),
('OPHTHALMOLOGIST', '眼科医师', '眼科门诊', 1, NOW(), NOW()),
('ENT_DOCTOR', '耳鼻喉科医师', '耳鼻喉门诊', 1, NOW(), NOW()),
('CARDIOLOGIST', '心内科医师', '心内科门诊', 1, NOW(), NOW()),
('NEUROLOGIST', '神经科医师', '神经科门诊', 1, NOW(), NOW()),
('ONCOLOGIST', '肿瘤科医师', '肿瘤科门诊', 1, NOW(), NOW()),
('PSYCHIATRIST', '精神科医师', '精神科门诊', 1, NOW(), NOW()),
('TCM_DOCTOR', '中医科医师', '中医门诊', 1, NOW(), NOW()),
('REHAB_DOCTOR', '康复科医师', '康复科门诊', 1, NOW(), NOW()),
('NUTRITIONIST', '营养师', '营养咨询', 1, NOW(), NOW()),
('ANESTHESIOLOGIST', '麻醉医师', '麻醉科', 1, NOW(), NOW()),
('PATHOLOGIST', '病理科医师', '病理诊断', 1, NOW(), NOW()),
('BLOOD_BANK_TECH', '血库技师', '血库管理', 1, NOW(), NOW()),
('MEDICAL_RECORD_CLERK', '病案管理员', '病案归档', 1, NOW(), NOW()),
('SECURITY_GUARD', '安保人员', '安保巡逻', 1, NOW(), NOW()),
('CLEANER', '保洁人员', '卫生清洁', 1, NOW(), NOW()),
('LOGISTICS_STAFF', '后勤人员', '后勤保障', 1, NOW(), NOW()),
('VOLUNTEER', '志愿者', '导诊志愿服务', 1, NOW(), NOW()),
('AUDITOR', '审计员', '内部审计', 1, NOW(), NOW()),
('HR_MANAGER', '人事主管', '人事管理', 1, NOW(), NOW()),
('PROCUREMENT_STAFF', '采购员', '物资采购', 1, NOW(), NOW()),
('WAREHOUSE_KEEPER', '库管员', '库房管理', 1, NOW(), NOW()),
('BILLING_CLERK', '结算员', '费用结算', 1, NOW(), NOW()),
('INSURANCE_CLERK', '医保专员', '医保报销', 1, NOW(), NOW()),
('APPOINTMENT_COORDINATOR', '预约协调员', '预约调度', 1, NOW(), NOW()),
('PATIENT_SERVICE', '患者服务专员', '患者咨询', 1, NOW(), NOW()),
('MEDICAL_EQUIPMENT_TECH', '设备技师', '医疗设备维护', 1, NOW(), NOW()),
('CLINICAL_RESEARCHER', '临床研究员', '科研工作', 1, NOW(), NOW()),
('MEDICAL_STUDENT', '见习医师', '实习轮转', 1, NOW(), NOW()),
('NURSE_HEAD', '护士长', '护理管理', 1, NOW(), NOW()),
('ICU_NURSE', 'ICU护士', '重症护理', 1, NOW(), NOW()),
('OR_NURSE', '手术室护士', '手术配合', 1, NOW(), NOW()),
('EMERGENCY_NURSE', '急诊护士', '急诊护理', 1, NOW(), NOW()),
('PHARMACY_TECH', '药剂师', '药房配药', 1, NOW(), NOW()),
('DISPENSARY_CLERK', '发药员', '窗口发药', 1, NOW(), NOW());

-- ----------------------------
-- 3. sys_user 示例数据（50+ 条，百家姓随机中文名）
-- 密码统一为 123456 的 BCrypt 加密值
-- ----------------------------

INSERT INTO `sys_user` (`username`, `password`, `name`, `email`, `mobile_phone`, `status`, `created_time`, `updated_time`) VALUES
('admin', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '系统管理员', 'admin@hospital.com', '13800000000', 1, NOW(), NOW()),
('zhaowei', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '赵伟', 'zhaowei@hospital.com', '13800000001', 1, NOW(), NOW()),
('qianfang', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '钱芳', 'qianfang@hospital.com', '13800000002', 1, NOW(), NOW()),
('sunmin', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '孙敏', 'sunmin@hospital.com', '13800000003', 1, NOW(), NOW()),
('lijing', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '李静', 'lijing@hospital.com', '13800000004', 1, NOW(), NOW()),
('zhouxin', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '周鑫', 'zhouxin@hospital.com', '13800000005', 1, NOW(), NOW()),
('wuzhen', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '吴珍', 'wuzhen@hospital.com', '13800000006', 1, NOW(), NOW()),
('zhenghao', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '郑浩', 'zhenghao@hospital.com', '13800000007', 1, NOW(), NOW()),
('wangyue', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '王悦', 'wangyue@hospital.com', '13800000008', 1, NOW(), NOW()),
('fengjia', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '冯佳', 'fengjia@hospital.com', '13800000009', 1, NOW(), NOW()),
('chenbo', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '陈博', 'chenbo@hospital.com', '13800000010', 1, NOW(), NOW()),
('chuwei', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '褚威', 'chuwei@hospital.com', '13800000011', 1, NOW(), NOW()),
('weixia', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '卫霞', 'weixia@hospital.com', '13800000012', 1, NOW(), NOW()),
('jianglin', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '蒋琳', 'jianglin@hospital.com', '13800000013', 1, NOW(), NOW()),
('shenqiang', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '沈强', 'shenqiang@hospital.com', '13800000014', 1, NOW(), NOW()),
('hanlei', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '韩磊', 'hanlei@hospital.com', '13800000015', 1, NOW(), NOW()),
('yangjun', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '杨军', 'yangjun@hospital.com', '13800000016', 1, NOW(), NOW()),
('zhuyan', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '朱艳', 'zhuyan@hospital.com', '13800000017', 1, NOW(), NOW()),
('qinjie', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '秦杰', 'qinjie@hospital.com', '13800000018', 1, NOW(), NOW()),
('youting', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '尤婷', 'youting@hospital.com', '13800000019', 1, NOW(), NOW()),
('xuhui', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '许慧', 'xuhui@hospital.com', '13800000020', 1, NOW(), NOW()),
('hebin', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '何斌', 'hebin@hospital.com', '13800000021', 1, NOW(), NOW()),
('lvxin', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '吕欣', 'lvxin@hospital.com', '13800000022', 1, NOW(), NOW()),
('shiting', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '施婷', 'shiting@hospital.com', '13800000023', 1, NOW(), NOW()),
('zhangtao', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '张涛', 'zhangtao@hospital.com', '13800000024', 1, NOW(), NOW()),
('kongna', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '孔娜', 'kongna@hospital.com', '13800000025', 1, NOW(), NOW()),
('caoming', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '曹明', 'caoming@hospital.com', '13800000026', 1, NOW(), NOW()),
('yanlan', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '严兰', 'yanlan@hospital.com', '13800000027', 1, NOW(), NOW()),
('huachun', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '华春', 'huachun@hospital.com', '13800000028', 1, NOW(), NOW()),
('jinxue', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '金雪', 'jinxue@hospital.com', '13800000029', 1, NOW(), NOW()),
('weipeng', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '魏鹏', 'weipeng@hospital.com', '13800000030', 1, NOW(), NOW()),
('taoxuan', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '陶轩', 'taoxuan@hospital.com', '13800000031', 1, NOW(), NOW()),
('jianghong', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '姜虹', 'jianghong@hospital.com', '13800000032', 1, NOW(), NOW()),
('qirui', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '戚瑞', 'qirui@hospital.com', '13800000033', 1, NOW(), NOW()),
('xieying', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '谢颖', 'xieying@hospital.com', '13800000034', 1, NOW(), NOW()),
('zouyang', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '邹阳', 'zouyang@hospital.com', '13800000035', 1, NOW(), NOW()),
('yuwen', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '喻雯', 'yuwen@hospital.com', '13800000036', 1, NOW(), NOW()),
('baifeng', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '柏峰', 'baifeng@hospital.com', '13800000037', 1, NOW(), NOW()),
('shuiting', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '水婷', 'shuiting@hospital.com', '13800000038', 1, NOW(), NOW()),
('douchen', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '窦晨', 'douchen@hospital.com', '13800000039', 1, NOW(), NOW()),
('zhangyue', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '章月', 'zhangyue@hospital.com', '13800000040', 1, NOW(), NOW()),
('yunlong', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '云龙', 'yunlong@hospital.com', '13800000041', 1, NOW(), NOW()),
('suqian', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '苏倩', 'suqian@hospital.com', '13800000042', 1, NOW(), NOW()),
('panjun', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '潘俊', 'panjun@hospital.com', '13800000043', 1, NOW(), NOW()),
('gelei', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '葛蕾', 'gelei@hospital.com', '13800000044', 1, NOW(), NOW()),
('xiping', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '奚平', 'xiping@hospital.com', '13800000045', 1, NOW(), NOW()),
('fanying', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '范英', 'fanying@hospital.com', '13800000046', 1, NOW(), NOW()),
('pengfei', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '彭飞', 'pengfei@hospital.com', '13800000047', 1, NOW(), NOW()),
('langyun', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '郎云', 'langyun@hospital.com', '13800000048', 1, NOW(), NOW()),
('luyu', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '鲁宇', 'luyu@hospital.com', '13800000049', 1, NOW(), NOW()),
('weimin', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '韦敏', 'weimin@hospital.com', '13800000050', 1, NOW(), NOW()),
('changjie', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '昌杰', 'changjie@hospital.com', '13800000051', 1, NOW(), NOW()),
('maling', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '马玲', 'maling@hospital.com', '13800000052', 1, NOW(), NOW()),
('miaohua', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '苗华', 'miaohua@hospital.com', '13800000053', 1, NOW(), NOW()),
('fenghui', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '凤慧', 'fenghui@hospital.com', '13800000054', 1, NOW(), NOW()),
('huaxin', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '花鑫', 'huaxin@hospital.com', '13800000055', 1, NOW(), NOW()),
('fangqiang', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '方强', 'fangqiang@hospital.com', '13800000056', 1, NOW(), NOW()),
('yurong', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '俞蓉', 'yurong@hospital.com', '13800000057', 1, NOW(), NOW()),
('renhao', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '任浩', 'renhao@hospital.com', '13800000058', 1, NOW(), NOW()),
('yuanlin', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '袁林', 'yuanlin@hospital.com', '13800000059', 1, NOW(), NOW()),
('liuyang', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '柳洋', 'liuyang@hospital.com', '13800000060', 1, NOW(), NOW()),
('shixu', '$2a$10$rQbeBO6qTw.ha5Dy6RgaduzMUl9k5bvln4l6mLXTLd5rIdTz27WbO', '史旭', 'shixu@hospital.com', '13800000061', 1, NOW(), NOW());

-- ----------------------------
-- 4. sys_user_role 示例数据（50+ 条用户-角色关联）
-- ----------------------------

INSERT INTO `sys_user_role` (`user_id`, `role_id`, `created_time`) VALUES
(1, 1, NOW()),
(2, 2, NOW()),
(3, 3, NOW()),
(4, 4, NOW()),
(5, 5, NOW()),
(6, 6, NOW()),
(7, 4, NOW()),
(8, 4, NOW()),
(9, 4, NOW()),
(10, 4, NOW()),
(11, 4, NOW()),
(12, 5, NOW()),
(13, 5, NOW()),
(14, 5, NOW()),
(15, 5, NOW()),
(16, 3, NOW()),
(17, 3, NOW()),
(18, 6, NOW()),
(19, 6, NOW()),
(20, 6, NOW()),
(21, 6, NOW()),
(22, 6, NOW()),
(23, 6, NOW()),
(24, 4, NOW()),
(25, 5, NOW()),
(26, 6, NOW()),
(27, 6, NOW()),
(28, 6, NOW()),
(29, 6, NOW()),
(30, 6, NOW()),
(31, 4, NOW()),
(32, 4, NOW()),
(33, 5, NOW()),
(34, 6, NOW()),
(35, 6, NOW()),
(36, 6, NOW()),
(37, 6, NOW()),
(38, 6, NOW()),
(39, 6, NOW()),
(40, 6, NOW()),
(41, 6, NOW()),
(42, 6, NOW()),
(43, 6, NOW()),
(44, 6, NOW()),
(45, 6, NOW()),
(46, 6, NOW()),
(47, 6, NOW()),
(48, 6, NOW()),
(49, 6, NOW()),
(50, 6, NOW()),
(51, 6, NOW()),
(52, 6, NOW()),
(53, 6, NOW()),
(54, 6, NOW()),
(55, 6, NOW()),
(56, 6, NOW()),
(57, 6, NOW()),
(58, 6, NOW()),
(59, 6, NOW()),
(60, 6, NOW()),
(61, 6, NOW()),
(2, 7, NOW()),
(7, 14, NOW()),
(8, 15, NOW()),
(9, 16, NOW()),
(10, 17, NOW()),
(11, 18, NOW()),
(24, 19, NOW()),
(31, 20, NOW()),
(32, 21, NOW());

SET FOREIGN_KEY_CHECKS = 1;
