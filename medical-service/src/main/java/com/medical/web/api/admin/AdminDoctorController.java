package com.medical.web.api.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.medical.common.pagination.PageResult;
import com.medical.common.response.ResultVo;
import com.medical.domain.entity.Doctor;
import com.medical.domain.entity.SysDept;
import com.medical.domain.entity.SysUser;
import com.medical.domain.vo.DoctorListVo;
import com.medical.mapper.DoctorMapper;
import com.medical.mapper.SysDeptMapper;
import com.medical.mapper.SysUserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/admin/doctor")
@RequiredArgsConstructor
public class AdminDoctorController {

    private final DoctorMapper doctorMapper;
    private final SysUserMapper sysUserMapper;
    private final SysDeptMapper sysDeptMapper;

    @GetMapping("/page")
    public ResultVo<PageResult<DoctorListVo>> page(
            @RequestParam(value = "current", defaultValue = "1") Long current,
            @RequestParam(value = "size", defaultValue = "10") Long size,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "deptId", required = false) Long deptId,
            @RequestParam(value = "status", required = false) Integer status) {
        LambdaQueryWrapper<Doctor> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(keyword)) {
            String kw = keyword.trim();
            List<Long> userIds = sysUserMapper.selectList(
                    new LambdaQueryWrapper<SysUser>()
                            .select(SysUser::getUserId)
                            .and(w -> w.like(SysUser::getUsername, kw).or().like(SysUser::getName, kw))
            ).stream().map(SysUser::getUserId).filter(Objects::nonNull).collect(Collectors.toList());
            wrapper.and(w -> {
                w.like(Doctor::getName, kw)
                        .or().like(Doctor::getDoctorNo, kw)
                        .or().like(Doctor::getSpecialty, kw)
                        .or().like(Doctor::getTitle, kw);
                if (!userIds.isEmpty()) {
                    w.or().in(Doctor::getUserId, userIds);
                }
            });
        }
        if (deptId != null) {
            wrapper.eq(Doctor::getDeptId, deptId);
        }
        if (status != null) {
            wrapper.eq(Doctor::getStatus, status);
        }
        wrapper.orderByAsc(Doctor::getDoctorId);
        Page<Doctor> page = doctorMapper.selectPage(new Page<>(current, size), wrapper);

        Set<Long> deptIds = page.getRecords().stream()
                .map(Doctor::getDeptId)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
        Map<Long, String> deptNameMap = new HashMap<>();
        if (!deptIds.isEmpty()) {
            for (SysDept d : sysDeptMapper.selectBatchIds(deptIds)) {
                if (d != null) {
                    deptNameMap.put(d.getDeptId(), d.getName());
                }
            }
        }

        Set<Long> userIds = page.getRecords().stream()
                .map(Doctor::getUserId)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
        Map<Long, String> usernameMap = new HashMap<>();
        if (!userIds.isEmpty()) {
            for (SysUser u : sysUserMapper.selectBatchIds(userIds)) {
                if (u != null) {
                    usernameMap.put(u.getUserId(), u.getUsername());
                }
            }
        }

        List<DoctorListVo> list = page.getRecords().stream().map(d -> {
            DoctorListVo vo = new DoctorListVo();
            BeanUtils.copyProperties(d, vo);
            if (d.getDeptId() != null) {
                vo.setDeptName(deptNameMap.get(d.getDeptId()));
            }
            if (d.getUserId() != null) {
                vo.setUsername(usernameMap.get(d.getUserId()));
            }
            return vo;
        }).collect(Collectors.toList());

        PageResult<DoctorListVo> result = new PageResult<>();
        result.setCurrentPage(page.getCurrent());
        result.setPageSize(page.getSize());
        result.setTotal(page.getTotal());
        result.setList(list);
        return ResultVo.ok(result);
    }
}
