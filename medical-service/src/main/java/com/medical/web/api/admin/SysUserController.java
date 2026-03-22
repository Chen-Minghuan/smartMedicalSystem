package com.medical.web.api.admin;

import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.medical.common.exception.ServiceException;
import com.medical.common.pagination.PageResult;
import com.medical.common.response.ResultVo;
import com.medical.domain.dto.UserUpdateDto;
import com.medical.domain.entity.SysUser;
import com.medical.domain.vo.UserListVo;
import com.medical.mapper.SysRoleMapper;
import com.medical.mapper.SysUserMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 用户管理 API
 */
@Slf4j
@RestController
@RequestMapping("/api/admin/user")
@RequiredArgsConstructor
public class SysUserController {

    private final SysUserMapper sysUserMapper;
    private final SysRoleMapper sysRoleMapper;

    @GetMapping("/page")
    public ResultVo<PageResult<UserListVo>> page(
            @RequestParam(value = "current", defaultValue = "1") Long current,
            @RequestParam(value = "size", defaultValue = "10") Long size,
            @RequestParam(value = "keyword", required = false) String keyword) {
        LambdaQueryWrapper<SysUser> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w.like(SysUser::getUsername, keyword)
                    .or().like(SysUser::getName, keyword)
                    .or().like(SysUser::getMobilePhone, keyword));
        }
        wrapper.orderByDesc(SysUser::getCreatedTime);
        Page<SysUser> page = sysUserMapper.selectPage(new Page<>(current, size), wrapper);
        List<UserListVo> voList = page.getRecords().stream().map(u -> {
            UserListVo vo = new UserListVo();
            vo.setUserId(u.getUserId());
            vo.setUsername(u.getUsername());
            vo.setName(u.getName());
            vo.setEmail(u.getEmail());
            vo.setMobilePhone(u.getMobilePhone());
            vo.setStatus(u.getStatus());
            vo.setCreatedTime(u.getCreatedTime());
            List<String> roleNames = sysRoleMapper.selectRoleNamesByUserId(u.getUserId());
            vo.setRoleNames(roleNames != null ? roleNames : Collections.emptyList());
            return vo;
        }).collect(Collectors.toList());
        PageResult<UserListVo> result = new PageResult<>();
        result.setCurrentPage(page.getCurrent());
        result.setPageSize(page.getSize());
        result.setTotal(page.getTotal());
        result.setList(voList);
        return ResultVo.ok(result);
    }

    @PutMapping("/{id}")
    public ResultVo<Void> update(
            @PathVariable(value = "id") Long id,
            @RequestBody UserUpdateDto dto) {
        SysUser exist = sysUserMapper.selectById(id);
        if (exist == null) {
            throw new ServiceException("用户不存在");
        }
        LambdaUpdateWrapper<SysUser> wrapper = new LambdaUpdateWrapper<SysUser>()
                .eq(SysUser::getUserId, id);
        if (dto.getName() != null) wrapper.set(SysUser::getName, dto.getName());
        if (dto.getEmail() != null) wrapper.set(SysUser::getEmail, dto.getEmail());
        if (dto.getMobilePhone() != null) wrapper.set(SysUser::getMobilePhone, dto.getMobilePhone());
        sysUserMapper.update(null, wrapper);
        return ResultVo.ok();
    }

    @PutMapping("/{id}/status")
    public ResultVo<Void> updateStatus(
            @PathVariable(value = "id") Long id,
            @RequestParam(value = "status") Integer status) {
        SysUser exist = sysUserMapper.selectById(id);
        if (exist == null) {
            throw new ServiceException("用户不存在");
        }
        if (status != 0 && status != 1) {
            throw new ServiceException("状态值无效");
        }
        sysUserMapper.update(null, new LambdaUpdateWrapper<SysUser>()
                .eq(SysUser::getUserId, id)
                .set(SysUser::getStatus, status));
        return ResultVo.ok();
    }
}
