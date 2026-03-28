package com.medical.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.medical.domain.entity.MedicineCategory;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MedicineCategoryMapper extends BaseMapper<MedicineCategory> {
}
