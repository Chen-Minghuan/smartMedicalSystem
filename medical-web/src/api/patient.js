import request from '@/utils/request'

/**
 * 获取我的预约列表
 */
export function getMyAppointments() {
    return request({
        url: '/api/patient/appointment/my',
        method: 'get'
    })
}

/**
 * 取消预约
 * @param {Number} appointmentId 预约ID
 */
export function cancelAppointment(appointmentId) {
    return request({
        url: `/api/patient/appointment/cancel/${appointmentId}`,
        method: 'put'
    })
}

/**
 * 获取预约详情
 * @param {Number} appointmentId 预约ID
 */
export function getAppointmentDetail(appointmentId) {
    return request({
        url: `/api/patient/appointment/${appointmentId}`,
        method: 'get'
    })
}

/**
 * 创建预约
 * @param {Object} data { scheduleId }
 */
export function createAppointment(data) {
    return request({
        url: '/api/patient/appointment/create',
        method: 'post',
        data: data
    })
}