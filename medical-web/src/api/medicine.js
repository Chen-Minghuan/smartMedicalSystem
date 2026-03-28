import request from '@/utils/request'

// 分页查询药品列表
export const getMedicinePage = (params) => {
    return request({
        url: '/api/admin/medicine/page',
        method: 'post',
        data: params
    })
}

// 获取药品详情
export const getMedicineById = (medicineId) => {
    return request({
        url: `/api/admin/medicine/${medicineId}`,
        method: 'get'
    })
}

// 新增药品
export const addMedicine = (data) => {
    return request({
        url: '/api/admin/medicine',
        method: 'post',
        data: data
    })
}

// 修改药品
export const updateMedicine = (data) => {
    return request({
        url: '/api/admin/medicine',
        method: 'put',
        data: data
    })
}

// 删除药品
export const deleteMedicine = (medicineId) => {
    return request({
        url: `/api/admin/medicine/${medicineId}`,
        method: 'delete'
    })
}

// 批量删除药品
export const batchDeleteMedicine = (medicineIds) => {
    return request({
        url: '/api/admin/medicine/batch',
        method: 'delete',
        data: medicineIds
    })
}

// 更新药品状态
export const updateMedicineStatus = (medicineId, status) => {
    return request({
        url: `/api/admin/medicine/${medicineId}/status`,
        method: 'put',
        params: { status }
    })
}

// 库存预警列表
export const getStockWarningList = (params) => {
    return request({
        url: '/api/admin/medicine/stock-warning',
        method: 'get',
        params: params
    })
}

// 搜索药品
export const searchMedicine = (keyword) => {
    return request({
        url: '/api/admin/medicine/search',
        method: 'get',
        params: { keyword }
    })
}