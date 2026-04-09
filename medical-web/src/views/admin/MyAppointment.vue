<template>
  <div class="my-appointment-page">
    <!-- 页面标题 → 药品列表同款 -->
    <div class="page-header">
      <div class="header-left">
        <i class="fa-solid fa-calendar-check page-icon"></i>
        <div>
          <h2 class="page-title">我的预约</h2>
          <p class="page-desc">查看您的全部挂号预约记录</p>
        </div>
      </div>
    </div>

    <!-- 内容卡片 → 药品列表玻璃毛玻璃 -->
    <div class="content-card">
      <el-empty
          v-if="appointmentList.length === 0"
          description="暂无预约记录"
          class="empty-custom"
      />

      <div
          v-for="item in appointmentList"
          :key="item.appointmentId"
          class="appointment-card"
      >
        <div class="card-header">
          <div class="hospital-info">
            <span class="dept-name">{{ item.deptName }}</span>
            <el-tag :type="getStatusType(item.status)" size="small">{{ getStatusText(item.status) }}</el-tag>
          </div>
          <div class="appointment-no">预约号：{{ item.appointmentNo }}</div>
        </div>

        <div class="card-body">
          <div class="doctor-info">
            <div class="doctor-avatar">
              <i class="fa-solid fa-user-md"></i>
            </div>
            <div class="doctor-detail">
              <div class="doctor-name">{{ item.doctorName }}</div>
              <div class="doctor-title">{{ item.doctorTitle || '医师' }}</div>
            </div>
          </div>

          <div class="appointment-info">
            <div class="info-row">
              <span class="info-label">就诊日期</span>
              <span class="info-value">{{ item.appointmentDate }} {{ item.timeSlot }}</span>
            </div>
            <div class="info-row">
              <span class="info-label">就诊科室</span>
              <span class="info-value">{{ item.deptName }}</span>
            </div>
            <div class="info-row">
              <span class="info-label">挂号费用</span>
              <span class="info-value">
                ¥{{ item.feeAmount }}
                <span :class="item.paid === 1 ? 'paid' : 'unpaid'">
                  {{ item.paid === 1 ? '（已支付）' : '（未支付）' }}
                </span>
              </span>
            </div>
            <div class="info-row">
              <span class="info-label">预约时间</span>
              <span class="info-value">{{ formatTime(item.createdTime) }}</span>
            </div>
          </div>
        </div>

        <div class="card-footer">
          <el-button
              v-if="item.status === 1"
              plain
              size="small"
              class="btn-cancel"
              @click="handleCancel(item)"
          >
            <i class="fa-solid fa-xmark"></i> 取消预约
          </el-button>
          <el-button
              v-if="item.status === 1 && item.paid === 0"
              plain
              size="small"
              class="btn-pay"
              @click="handlePay(item)"
          >
            <i class="fa-solid fa-credit-card"></i> 去支付
          </el-button>
          <span v-if="item.status !== 1" class="finished-tip">该预约已完成/取消</span>
        </div>
      </div>
    </div>

    <!-- 取消弹窗 → 药品列表同款 -->
    <el-dialog
        v-model="cancelDialogVisible"
        title="取消预约"
        width="400px"
        :append-to-body="true"
        align-center
        class="medicine-dialog edit-dialog"
    >
      <p>确定要取消该预约吗？取消后号源将释放。</p>
      <template #footer>
        <div class="edit-dialog-footer">
          <el-button class="btn-cancel" @click="cancelDialogVisible = false">再想想</el-button>
          <el-button class="btn-save" type="danger" @click="confirmCancel">确认取消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getMyAppointments, cancelAppointment } from '@/api/patient'

const appointmentList = ref([])
const cancelDialogVisible = ref(false)
const currentCancelItem = ref(null)

const fetchAppointments = async () => {
  try {
    const res = await getMyAppointments()
    console.log('完整响应:', res)
    let list = []
    if (Array.isArray(res)) {
      list = res
    } else if (res.code === 200) {
      list = res.data || []
    } else {
      list = []
    }
    const statusOrder = { 1: 1, 2: 2, 4: 3, 3: 4 }
    list.sort((a, b) => (statusOrder[a.status] || 5) - (statusOrder[b.status] || 5))
    appointmentList.value = list
  } catch (error) {
    console.error('获取预约列表失败:', error)
    ElMessage.error('获取预约列表失败')
  }
}

const handleCancel = (item) => {
  currentCancelItem.value = item
  cancelDialogVisible.value = true
}

const confirmCancel = async () => {
  try {
    await cancelAppointment(currentCancelItem.value.appointmentId)
    ElMessage.success('取消成功')
    cancelDialogVisible.value = false
    fetchAppointments()
  } catch (error) {
    ElMessage.error(error.message || '取消失败，请稍后重试')
  }
}

const handlePay = (item) => {
  ElMessage.info('支付功能开发中...')
}

const formatTime = (time) => {
  if (!time) return ''
  return new Date(time).toLocaleString()
}

const getStatusText = (status) => {
  const map = { 1: '待就诊', 2: '已就诊', 3: '已取消', 4: '爽约' }
  return map[status] || '未知'
}

const getStatusType = (status) => {
  const map = { 1: 'warning', 2: 'success', 3: 'info', 4: 'danger' }
  return map[status] || 'info'
}

onMounted(() => {
  fetchAppointments()
})
</script>

<style scoped>
/* 完全和药品列表样式一致 */
.my-appointment-page {
  padding: 24px 28px 32px;
  min-height: 100%;
}

.page-header {
  margin-bottom: 20px;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 14px;
}

.page-icon {
  width: 48px;
  height: 48px;
  line-height: 48px;
  text-align: center;
  font-size: 22px;
  color: #fff;
  background: linear-gradient(135deg, #e8a54b, #d48232);
  border-radius: 12px;
  box-shadow: 0 4px 14px rgba(212, 130, 50, 0.35);
}

.page-title {
  margin: 0;
  font-size: 20px;
  font-weight: 700;
  color: #2c1810;
  text-shadow: 0 1px 2px rgba(255, 255, 255, 0.8);
}

.page-desc {
  margin: 4px 0 0 0;
  font-size: 13px;
  color: #5c4a32;
}

/* 药品列表同款玻璃卡片 */
.content-card {
  border-radius: 16px;
  background: rgba(255, 252, 250, 0.55);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border: 1px solid rgba(255, 255, 255, 0.5);
  box-shadow: 0 4px 24px rgba(61, 41, 20, 0.1);
  overflow: hidden;
  padding: 24px 28px;
}

.empty-custom {
  padding: 60px 0;
  color: #b0a088;
}

/* 卡片样式 */
.appointment-card {
  background: #fefaf5;
  border: 1px solid #f0e4d4;
  border-radius: 14px;
  margin-bottom: 16px;
  padding: 20px 24px;
  transition: all 0.2s ease;
}

.appointment-card:hover {
  border-color: #e8a54b;
  box-shadow: 0 4px 12px rgba(232, 165, 75, 0.15);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 15px;
  border-bottom: 1px solid #f0e4d4;
  margin-bottom: 15px;
}

.hospital-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.dept-name {
  font-size: 16px;
  font-weight: 600;
  color: #2c1810;
}

.appointment-no {
  font-size: 12px;
  color: #b0a088;
}

.card-body {
  display: flex;
  gap: 30px;
  flex-wrap: wrap;
  margin-bottom: 20px;
}

.doctor-info {
  display: flex;
  gap: 15px;
  align-items: center;
  min-width: 180px;
}

.doctor-avatar {
  width: 56px;
  height: 56px;
  line-height: 56px;
  text-align: center;
  font-size: 28px;
  background: linear-gradient(135deg, #e8f4f0, #d4e8e0);
  border-radius: 50%;
  color: #2c7a5e;
}

.doctor-name {
  font-size: 16px;
  font-weight: 600;
  color: #2c1810;
}

.doctor-title {
  font-size: 13px;
  color: #d48232;
}

.appointment-info {
  flex: 1;
}

.info-row {
  display: flex;
  margin-bottom: 10px;
  font-size: 14px;
  color: #2c1810;
}

.info-label {
  width: 80px;
  font-weight: 500;
  color: #8b7a68;
}

.info-value {
  flex: 1;
}

.paid {
  color: #67c23a;
  margin-left: 8px;
}

.unpaid {
  color: #f56c6c;
  margin-left: 8px;
}

.card-footer {
  display: flex;
  justify-content: flex-end;
  padding-top: 15px;
  border-top: 1px solid #f0e4d4;
  gap: 12px;
}

.finished-tip {
  font-size: 13px;
  color: #8b7a68;
}

/* 按钮和药品列表一致 */
.btn-cancel {
  border-color: #f56c6c;
  color: #f56c6c;
  background: rgba(245, 108, 108, 0.1);
  border-radius: 10px;
}

.btn-cancel:hover {
  background: rgba(245, 108, 108, 0.2);
  border-color: #f56c6c;
  color: #f56c6c;
}

.btn-pay {
  border-color: #e8a54b;
  color: #d48232;
  background: rgba(232, 165, 75, 0.1);
  border-radius: 10px;
}

.btn-pay:hover {
  background: rgba(232, 165, 75, 0.2);
  border-color: #e8a54b;
  color: #d48232;
}

/* 弹窗样式完全一致 */
.medicine-dialog.edit-dialog :deep(.el-dialog) {
  border-radius: 16px;
  overflow: hidden;
  background: rgba(255, 252, 250, 0.98);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.6);
  box-shadow: 0 8px 40px rgba(61, 41, 20, 0.15), 0 0 0 1px rgba(139, 90, 43, 0.08);
}

.medicine-dialog.edit-dialog :deep(.el-dialog__header) {
  padding: 20px 24px;
  margin: 0;
  border-bottom: 1px solid rgba(139, 90, 43, 0.12);
  background: rgba(255, 250, 245, 0.5);
}

.medicine-dialog.edit-dialog :deep(.el-dialog__footer) {
  padding: 16px 24px 24px;
  border-top: 1px solid rgba(139, 90, 43, 0.08);
}

.edit-dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

.btn-cancel {
  border-radius: 10px;
  padding: 10px 20px;
  border: 1px solid rgba(139, 90, 43, 0.3);
  color: #5c4a32;
  background: rgba(255, 255, 255, 0.8);
}

.btn-save {
  border-radius: 10px;
  padding: 10px 24px;
  border: none;
  color: #fff;
  background: linear-gradient(135deg, #e8a54b, #d48232);
  box-shadow: 0 4px 14px rgba(212, 130, 50, 0.3);
}
</style>