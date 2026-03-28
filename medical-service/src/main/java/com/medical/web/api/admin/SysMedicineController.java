package com.medical.web.api.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.medical.common.pagination.PageResult;
import com.medical.common.response.ResultVo;
import com.medical.domain.entity.Medicine;
import com.medical.domain.entity.MedicineCategory;
import com.medical.domain.vo.MedicineCategoryVo;
import com.medical.domain.vo.MedicineListVo;
import com.medical.mapper.MedicineCategoryMapper;
import com.medical.mapper.MedicineMapper;
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

/**
 * 药品管理 API（列表 / 分类）
 */
@RestController
@RequestMapping("/api/admin/medicine")
@RequiredArgsConstructor
public class SysMedicineController {

    private final MedicineMapper medicineMapper;
    private final MedicineCategoryMapper medicineCategoryMapper;

    @GetMapping("/page")
    public ResultVo<PageResult<MedicineListVo>> page(
            @RequestParam(value = "current", defaultValue = "1") Long current,
            @RequestParam(value = "size", defaultValue = "10") Long size,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "categoryId", required = false) Long categoryId,
            @RequestParam(value = "status", required = false) Integer status) {
        LambdaQueryWrapper<Medicine> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(keyword)) {
            String kw = keyword.trim();
            wrapper.and(w -> w.like(Medicine::getName, kw)
                    .or().like(Medicine::getCommonName, kw)
                    .or().like(Medicine::getMedicineCode, kw));
        }
        if (categoryId != null) {
            wrapper.eq(Medicine::getCategoryId, categoryId);
        }
        if (status != null) {
            wrapper.eq(Medicine::getStatus, status);
        }
        wrapper.orderByAsc(Medicine::getMedicineId);
        Page<Medicine> page = medicineMapper.selectPage(new Page<>(current, size), wrapper);

        Set<Long> catIds = page.getRecords().stream()
                .map(Medicine::getCategoryId)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
        Map<Long, String> categoryNameMap = new HashMap<>();
        if (!catIds.isEmpty()) {
            List<MedicineCategory> cats = medicineCategoryMapper.selectBatchIds(catIds);
            for (MedicineCategory c : cats) {
                categoryNameMap.put(c.getCategoryId(), c.getName());
            }
        }

        List<MedicineListVo> voList = page.getRecords().stream().map(m -> {
            MedicineListVo vo = new MedicineListVo();
            BeanUtils.copyProperties(m, vo);
            if (m.getCategoryId() != null) {
                vo.setCategoryName(categoryNameMap.get(m.getCategoryId()));
            }
            return vo;
        }).collect(Collectors.toList());

        PageResult<MedicineListVo> result = new PageResult<>();
        result.setCurrentPage(page.getCurrent());
        result.setPageSize(page.getSize());
        result.setTotal(page.getTotal());
        result.setList(voList);
        return ResultVo.ok(result);
    }

    /**
     * 药品分类列表（启用），用于筛选下拉
     */
    @GetMapping("/categories")
    public ResultVo<List<MedicineCategoryVo>> categories() {
        List<MedicineCategory> list = medicineCategoryMapper.selectList(
                new LambdaQueryWrapper<MedicineCategory>()
                        .eq(MedicineCategory::getStatus, 1)
                        .orderByAsc(MedicineCategory::getSortOrder)
                        .orderByAsc(MedicineCategory::getCategoryId));
        List<MedicineCategoryVo> voList = list.stream().map(c -> {
            MedicineCategoryVo vo = new MedicineCategoryVo();
            vo.setCategoryId(c.getCategoryId());
            vo.setName(c.getName());
            return vo;
        }).collect(Collectors.toList());
        return ResultVo.ok(voList);
    }
}
