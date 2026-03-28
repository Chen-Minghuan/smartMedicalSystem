<template>
  <div class="medicine-list-page">
    <div class="page-header">
      <div class="header-left">
        <i class="fa-solid fa-pills page-icon"></i>
        <div>
          <h2 class="page-title">药品列表</h2>
          <p class="page-desc">查询药品编码、分类、规格与库存信息</p>
        </div>
      </div>
    </div>

    <div class="content-card">
      <div class="toolbar">
        <div class="search-wrap">
          <i class="fa-solid fa-magnifying-glass search-icon"></i>
          <el-input
            v-model="keyword"
            placeholder="搜索药品名称、通用名或编码"
            clearable
            class="search-input"
            @clear="loadData"
            @keyup.enter="loadData"
          />
          <el-button class="search-btn" @click="loadData">
            <i class="fa-solid fa-search"></i>
            搜索
          </el-button>

          <el-select
            v-model="categoryIdFilter"
            placeholder="药品分类"
            clearable
            filterable
            size="large"
            class="filter-select filter-select-wide"
            style="width: 200px"
            @change="loadData"
          >
            <el-option
              v-for="c in categoryOptions"
              :key="c.categoryId"
              :label="c.name"
              :value="c.categoryId"
            />
          </el-select>

          <el-select
            v-model="statusFilter"
            placeholder="状态"
            clearable
            size="large"
            class="filter-select"
            style="width: 120px"
            @change="loadData"
          >
            <el-option :value="1" label="在用" />
            <el-option :value="0" label="停用" />
          </el-select>
        </div>
      </div>

      <div class="table-wrap" v-loading="loading" element-loading-text="加载中...">
        <el-table
          :data="tableData"
          class="data-table"
          :header-cell-style="headerCellStyle"
          :row-class-name="tableRowClassName"
        >
          <el-table-column prop="medicineCode" label="药品编码" width="118" align="center">
            <template #default="{ row }">
              <span class="cell-code">{{ row.medicineCode }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="name" label="药品名称" min-width="140" />
          <el-table-column prop="commonName" label="通用名" min-width="120" />
          <el-table-column prop="categoryName" label="分类" width="130">
            <template #default="{ row }">
              {{ row.categoryName || '-' }}
            </template>
          </el-table-column>
          <el-table-column prop="spec" label="规格" min-width="120" />
          <el-table-column prop="unit" label="单位" width="64" align="center" />
          <el-table-column prop="manufacturer" label="生产厂家" min-width="160" />
          <el-table-column prop="approvalNo" label="批准文号" min-width="130" />
          <el-table-column prop="unitPrice" label="零售价" width="88" align="right">
            <template #default="{ row }">
              {{ formatMoney(row.unitPrice) }}
            </template>
          </el-table-column>
          <el-table-column prop="stockQuantity" label="库存" width="72" align="center" />
          <el-table-column prop="minStock" label="最低库存" width="88" align="center" />
          <el-table-column prop="status" label="状态" width="72" align="center">
            <template #default="{ row }">
              <span :class="['status-dot', row.status === 1 ? 'enabled' : 'disabled']"></span>
              <span class="status-text">{{ row.status === 1 ? '在用' : '停用' }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="createdTime" label="创建时间" width="160" align="center">
            <template #default="{ row }">
              <span class="cell-time">{{ row.createdTime ?? '-' }}</span>
            </template>
          </el-table-column>
        </el-table>

        <div class="pagination-wrap">
          <el-pagination
            v-model:current-page="currentPage"
            v-model:page-size="pageSize"
            :total="total"
            :page-sizes="[10, 20, 50, 100]"
            layout="total, sizes, prev, pager, next, jumper"
            background
            @size-change="loadData"
            @current-change="loadData"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getMedicinePage, getMedicineCategories } from '@/api/admin'

const loading = ref(false)
const tableData = ref([])
const currentPage = ref(1)
const pageSize = ref(20)
const total = ref(0)
const keyword = ref('')
const categoryIdFilter = ref(null)
const statusFilter = ref(null)
const categoryOptions = ref([])

const headerCellStyle = {
  background: 'rgba(139, 90, 43, 0.08)',
  color: '#5c4a32',
  fontWeight: '600',
  fontSize: '13px',
  borderBottom: '1px solid rgba(139, 90, 43, 0.15)'
}

const tableRowClassName = ({ rowIndex }) => {
  return rowIndex % 2 === 1 ? 'striped-row' : ''
}

const formatMoney = (v) => {
  if (v === null || v === undefined) return '-'
  const n = Number(v)
  if (Number.isNaN(n)) return '-'
  return n.toFixed(2)
}

const loadCategories = async () => {
  try {
    const list = await getMedicineCategories()
    categoryOptions.value = list || []
  } catch {
    categoryOptions.value = []
  }
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await getMedicinePage({
      current: currentPage.value,
      size: pageSize.value,
      keyword: keyword.value || undefined,
      categoryId: categoryIdFilter.value ?? undefined,
      status: statusFilter.value ?? undefined
    })
    tableData.value = res.list || []
    total.value = res.total || 0
  } catch {
    tableData.value = []
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadCategories()
  loadData()
})
</script>

<style scoped>
.medicine-list-page {
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

.content-card {
  border-radius: 16px;
  background: rgba(255, 252, 250, 0.55);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border: 1px solid rgba(255, 255, 255, 0.5);
  box-shadow: 0 4px 24px rgba(61, 41, 20, 0.1);
  overflow: hidden;
}

.toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 12px;
  padding: 18px 24px;
  border-bottom: 1px solid rgba(139, 90, 43, 0.1);
}

.search-wrap {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 12px;
  max-width: 960px;
  flex: 1;
  min-width: 220px;
}

.search-icon {
  color: #8b5a2b;
  font-size: 16px;
  opacity: 0.8;
}

.search-input {
  flex: 1;
  min-width: 160px;
}

.search-input :deep(.el-input__wrapper) {
  background: rgba(255, 255, 255, 0.7);
  border-radius: 10px;
  border: 1px solid rgba(139, 90, 43, 0.2);
  box-shadow: none;
}

.search-input :deep(.el-input__wrapper:hover),
.search-input :deep(.el-input__wrapper.is-focus) {
  border-color: rgba(232, 165, 75, 0.5);
  box-shadow: 0 0 0 1px rgba(232, 165, 75, 0.2);
}

.filter-select :deep(.el-select__wrapper) {
  border-radius: 10px !important;
  background: rgba(255, 255, 255, 0.7) !important;
  border: 1.5px solid rgba(100, 70, 40, 0.5) !important;
  box-shadow: none !important;
}

.filter-select :deep(.el-select__wrapper:hover),
.filter-select :deep(.el-select__wrapper.is-focus) {
  border-color: rgba(232, 165, 75, 0.7) !important;
  box-shadow: 0 0 0 2px rgba(232, 165, 75, 0.15) !important;
}

.search-btn {
  background: linear-gradient(135deg, #e8a54b, #d48232);
  border: none;
  color: #fff;
  border-radius: 10px;
  padding: 10px 18px;
  font-weight: 600;
  box-shadow: 0 4px 14px rgba(212, 130, 50, 0.3);
}

.search-btn:hover {
  background: linear-gradient(135deg, #f0b55c, #e08d3a);
  color: #fff;
  box-shadow: 0 5px 18px rgba(212, 130, 50, 0.4);
}

.table-wrap {
  padding: 0 24px 24px;
}

.data-table {
  --el-table-border-color: rgba(139, 90, 43, 0.12);
  --el-table-header-bg-color: transparent;
  background: transparent !important;
  width: 100%;
}

.data-table :deep(.el-table__inner-wrapper::before) {
  display: none;
}

.data-table :deep(.el-table th.el-table__cell) {
  padding: 12px 0;
}

.data-table :deep(.el-table td.el-table__cell) {
  padding: 10px 0;
  border-bottom: 1px solid rgba(139, 90, 43, 0.06);
}

.data-table :deep(.el-table__row:hover > td) {
  background: rgba(232, 165, 75, 0.08) !important;
}

.data-table :deep(.striped-row td) {
  background: rgba(255, 250, 245, 0.5) !important;
}

.cell-code {
  font-family: 'SF Mono', 'Cascadia Code', 'Consolas', 'Monaco', 'Courier New', monospace;
  font-size: 12px;
  font-weight: 600;
  color: #8b5a2b;
}

.cell-time {
  color: #5c4a32;
  font-size: 13px;
}

.status-dot {
  display: inline-block;
  width: 8px;
  height: 8px;
  border-radius: 50%;
  margin-right: 6px;
  vertical-align: middle;
}

.status-dot.enabled {
  background: #52c41a;
  box-shadow: 0 0 0 2px rgba(82, 196, 26, 0.3);
}

.status-dot.disabled {
  background: #ff4d4f;
  box-shadow: 0 0 0 2px rgba(255, 77, 79, 0.3);
}

.status-text {
  font-size: 13px;
  color: #5c4a32;
}

.pagination-wrap {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

.pagination-wrap :deep(.el-pagination) {
  --el-pagination-button-bg-color: rgba(255, 255, 255, 0.8);
  --el-pagination-hover-color: #e8a54b;
}

.pagination-wrap :deep(.el-pagination.is-background .el-pager li:not(.is-disabled).is-active) {
  background: linear-gradient(135deg, #e8a54b, #d48232);
}

.pagination-wrap :deep(.el-pagination .el-pagination__total) {
  color: #5c4a32;
  font-weight: 500;
}
</style>
