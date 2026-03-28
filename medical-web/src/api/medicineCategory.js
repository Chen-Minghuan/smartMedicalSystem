import request from '@/utils/request'

// 获取分类树
export const getCategoryTree = () => {
    return request({
        url: '/api/admin/medicine-category/tree',
        method: 'get'
    })
}

// 获取分类列表
export const getCategoryList = () => {
    return request({
        url: '/api/admin/medicine-category/list',
        method: 'get'
    })
}

// 获取分类详情
export const getCategoryById = (categoryId) => {
    return request({
        url: `/api/admin/medicine-category/${categoryId}`,
        method: 'get'
    })
}

// 新增分类
export const addCategory = (data) => {
    return request({
        url: '/api/admin/medicine-category',
        method: 'post',
        data: data
    })
}

// 修改分类
export const updateCategory = (data) => {
    return request({
        url: '/api/admin/medicine-category',
        method: 'put',
        data: data
    })
}

// 删除分类
export const deleteCategory = (categoryId) => {
    return request({
        url: `/api/admin/medicine-category/${categoryId}`,
        method: 'delete'
    })
}

// 更新分类状态
export const updateCategoryStatus = (categoryId, status) => {
    return request({
        url: `/api/admin/medicine-category/${categoryId}/status`,
        method: 'put',
        params: { status }
    })
}