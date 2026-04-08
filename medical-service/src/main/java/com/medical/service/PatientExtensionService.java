package com.medical.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.medical.domain.entity.Patient;
import com.medical.domain.entity.SysUser;
import com.medical.mapper.PatientMapper;
import com.medical.mapper.SysRoleMapper;
import com.medical.mapper.SysUserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 维护 patient 表与 sys_user（PATIENT 角色）一致。
 */
@Service
@RequiredArgsConstructor
public class PatientExtensionService {

    private final SysUserMapper sysUserMapper;
    private final SysRoleMapper sysRoleMapper;
    private final PatientMapper patientMapper;

    /**
     * 若用户持有 PATIENT 则 upsert 档案；否则删除对应 patient 行。
     */
    @Transactional(rollbackFor = Exception.class)
    public void syncPatientExtension(Long userId) {
        SysUser user = sysUserMapper.selectById(userId);
        if (user == null) {
            return;
        }
        List<String> codes = sysRoleMapper.selectRoleCodesByUserId(userId);
        boolean isPatient = codes != null && codes.contains("PATIENT");
        if (!isPatient) {
            patientMapper.delete(new LambdaQueryWrapper<Patient>().eq(Patient::getUserId, userId));
            return;
        }
        Patient exist = patientMapper.selectOne(
                new LambdaQueryWrapper<Patient>().eq(Patient::getUserId, userId));
        LocalDateTime now = LocalDateTime.now();
        String displayName = StringUtils.hasText(user.getName()) ? user.getName().trim() : user.getUsername();
        if (exist == null) {
            Patient p = new Patient();
            p.setUserId(userId);
            p.setPatientNo("P" + userId);
            p.setName(displayName);
            p.setPhone(StringUtils.hasText(user.getMobilePhone()) ? user.getMobilePhone().trim() : null);
            p.setEmail(StringUtils.hasText(user.getEmail()) ? user.getEmail().trim() : null);
            p.setStatus(user.getStatus() != null ? user.getStatus() : 1);
            p.setCreatedTime(now);
            p.setUpdatedTime(now);
            patientMapper.insert(p);
        } else {
            exist.setName(displayName);
            if (StringUtils.hasText(user.getMobilePhone())) {
                exist.setPhone(user.getMobilePhone().trim());
            }
            if (StringUtils.hasText(user.getEmail())) {
                exist.setEmail(user.getEmail().trim());
            }
            if (user.getStatus() != null) {
                exist.setStatus(user.getStatus());
            }
            exist.setUpdatedTime(now);
            patientMapper.updateById(exist);
        }
    }

    @Transactional(rollbackFor = Exception.class)
    public void deletePatientByUserId(Long userId) {
        patientMapper.delete(new LambdaQueryWrapper<Patient>().eq(Patient::getUserId, userId));
    }
}
