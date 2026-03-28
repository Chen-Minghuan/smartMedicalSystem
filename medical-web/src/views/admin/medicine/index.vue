<template>
  <div class="medicine-management-page">
    <!-- 页面标题区 -->
    <div class="page-header">
      <div class="header-left">
        <i class="fa-solid fa-capsules page-icon"></i>
        <div>
          <h2 class="page-title">药品管理</h2>
          <p class="page-desc">药品信息维护与库存管理</p>
        </div>
      </div>
    </div>

    <!-- 主内容卡片 -->
    <div class="content-card">
      <!-- 搜索栏 -->
      <div class="toolbar">
        <div class="search-wrap">
          <i class="fa-solid fa-magnifying-glass search-icon"></i>
          <el-input
              v-model="searchForm.name"
              placeholder="搜索药品名称、编码或通用名"
              clearable
              class="search-input"
              @clear="handleSearch"
              @keyup.enter="handleSearch"
          />
          <el-button class="search-btn" @click="handleSearch">
            <i class="fa-solid fa-search"></i>
            搜索
          </el-button>

          <el-select
              v-model="searchForm.categoryId"
              placeholder="药品分类"
              clearable
              size="large"
              class="filter-select"
              style="width: 150px"
              @change="handleSearch"
          >
            <el-option
                v-for="item in categoryList"
                :key="item.categoryId"
                :label="item.name"
                :value="item.categoryId"
            />
          </el-select>

          <el-select
              v-model="searchForm.status"
              placeholder="状态"
              clearable
              size="large"
              class="filter-select"
              style="width: 120px"
              @change="handleSearch"
          >
            <el-option :value="1" label="在用" />
            <el-option :value="0" label="停用" />
          </el-select>
        </div>
        <div class="action-buttons">
          <el-button class="category-btn" @click="handleCategoryManage">
            <i class="fa-solid fa-folder-tree"></i>
            分类管理
          </el-button>
          <el-button class="add-btn" @click="handleAdd">
            <i class="fa-solid fa-plus"></i>
            新增药品
          </el-button>
        </div>
      </div>

      <!-- 表格 -->
      <div class="table-wrap" v-loading="loading" element-loading-text="加载中...">
        <el-table
            :data="tableData"
            class="data-table"
            :header-cell-style="headerCellStyle"
            :row-class-name="tableRowClassName"
            @selection-change="handleSelectionChange"
        >
          <el-table-column type="selection" width="55" align="center" />
          <el-table-column prop="medicineCode" label="药品编码" width="140" show-overflow-tooltip>
            <template #default="{ row }">
              <span class="cell-code clickable" @click="handleView(row)">
                {{ row.medicineCode }}
              </span>
            </template>
          </el-table-column>
          <el-table-column prop="name" label="药品名称" min-width="150" show-overflow-tooltip>
            <template #default="{ row }">
              <span class="cell-name">{{ row.name }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="commonName" label="通用名" min-width="120" show-overflow-tooltip />
          <el-table-column prop="categoryName" label="分类" width="100" />
          <el-table-column prop="spec" label="规格" width="120" show-overflow-tooltip />
          <el-table-column prop="unit" label="单位" width="70" align="center" />
          <el-table-column prop="manufacturer" label="生产厂家" width="160" show-overflow-tooltip />
          <el-table-column prop="unitPrice" label="零售价(元)" width="100" align="right">
            <template #default="{ row }">
              <span class="price-text">¥{{ formatPrice(row.unitPrice) }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="stockQuantity" label="库存" width="90" align="center">
            <template #default="{ row }">
              <span :class="['stock-quantity', { 'stock-warning': row.stockQuantity <= row.minStock }]">
                {{ row.stockQuantity }}
              </span>
            </template>
          </el-table-column>
          <el-table-column prop="minStock" label="预警值" width="80" align="center" />
          <el-table-column prop="status" label="状态" width="80" align="center">
            <template #default="{ row }">
              <span :class="['status-dot', row.status === 1 ? 'enabled' : 'disabled']"></span>
              <span class="status-text">{{ row.status === 1 ? '在用' : '停用' }}</span>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="200" align="center" fixed="right">
            <template #default="{ row }">
              <el-button link type="primary" size="small" @click="handleEdit(row)">
                <i class="fa-solid fa-pen"></i> 编辑
              </el-button>
              <el-button
                  link
                  :type="row.status === 1 ? 'warning' : 'success'"
                  size="small"
                  @click="handleToggleStatus(row)"
              >
                <i :class="row.status === 1 ? 'fa-solid fa-ban' : 'fa-solid fa-check'"></i>
                {{ row.status === 1 ? '停用' : '启用' }}
              </el-button>
              <el-button link type="danger" size="small" @click="handleDelete(row)">
                <i class="fa-solid fa-trash"></i> 删除
              </el-button>
            </template>
          </el-table-column>
        </el-table>

        <!-- 批量操作栏 -->
        <div v-if="selectedIds.length > 0" class="batch-bar">
          <span class="batch-info">已选择 {{ selectedIds.length }} 项</span>
          <el-button type="danger" size="small" @click="handleBatchDelete">
            <i class="fa-solid fa-trash"></i> 批量删除
          </el-button>
        </div>

        <!-- 分页 -->
        <div class="pagination-wrap">
          <el-pagination
              v-model:current-page="pageParams.current"
              v-model:page-size="pageParams.size"
              :total="total"
              :page-sizes="[10, 20, 50, 100]"
              layout="total, sizes, prev, pager, next, jumper"
              background
              @size-change="handleSizeChange"
              @current-change="handleCurrentChange"
          />
        </div>
      </div>
    </div>

    <!-- 新增/编辑药品弹窗 -->
    <el-dialog
        v-model="dialogVisible"
        width="680px"
        class="medicine-dialog"
        :close-on-click-modal="false"
        align-center
        @close="handleDialogClose"
    >
      <template #header>
        <div class="dialog-header">
          <i class="fa-solid fa-capsules dialog-icon"></i>
          <div>
            <span class="dialog-title">{{ dialogTitle }}</span>
            <span class="dialog-subtitle">{{ dialogTitle === '新增药品' ? '填写药品基本信息' : '修改药品信息' }}</span>
          </div>
        </div>
      </template>
      <el-form
          ref="formRef"
          :model="formData"
          :rules="formRules"
          label-position="top"
          class="edit-form"
      >
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="药品编码" prop="medicineCode">
              <el-input v-model="formData.medicineCode" placeholder="自动生成" disabled class="input-disabled" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="药品名称" prop="name" required>
              <el-input v-model="formData.name" placeholder="请输入药品名称" maxlength="100" show-word-limit />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="通用名" prop="commonName">
              <el-input v-model="formData.commonName" placeholder="请输入通用名" maxlength="100" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="药品分类" prop="categoryId" required>
              <el-tree-select
                  v-model="formData.categoryId"
                  :data="categoryTree"
                  :props="{ label: 'name', value: 'categoryId' }"
                  placeholder="请选择分类"
                  check-strictly
                  style="width: 100%"
              />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="规格" prop="spec" required>
              <el-input v-model="formData.spec" placeholder="如：0.5g*24片" maxlength="100" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="单位" prop="unit" required>
              <el-select v-model="formData.unit" placeholder="请选择单位" style="width: 100%">
                <el-option label="盒" value="盒" />
                <el-option label="瓶" value="瓶" />
                <el-option label="支" value="支" />
                <el-option label="袋" value="袋" />
                <el-option label="片" value="片" />
                <el-option label="粒" value="粒" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="零售价(元)" prop="unitPrice" required>
              <el-input-number
                  v-model="formData.unitPrice"
                  :precision="2"
                  :min="0"
                  :step="0.1"
                  style="width: 100%"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="成本价(元)" prop="costPrice">
              <el-input-number
                  v-model="formData.costPrice"
                  :precision="2"
                  :min="0"
                  :step="0.1"
                  style="width: 100%"
              />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="库存数量" prop="stockQuantity" required>
              <el-input-number
                  v-model="formData.stockQuantity"
                  :min="0"
                  :step="1"
                  style="width: 100%"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="最低库存预警" prop="minStock">
              <el-input-number
                  v-model="formData.minStock"
                  :min="0"
                  :step="1"
                  style="width: 100%"
              />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="生产厂家" prop="manufacturer">
          <el-input v-model="formData.manufacturer" placeholder="请输入生产厂家" maxlength="200" />
        </el-form-item>
        <el-form-item label="批准文号" prop="approvalNo">
          <el-input v-model="formData.approvalNo" placeholder="请输入批准文号" maxlength="100" />
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input
              v-model="formData.remark"
              type="textarea"
              :rows="3"
              placeholder="请输入备注"
              maxlength="500"
              show-word-limit
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button class="btn-cancel" @click="dialogVisible = false">取消</el-button>
          <el-button class="btn-save" :loading="submitLoading" @click="handleSubmit">
            确定
          </el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 查看详情弹窗 -->
    <el-dialog
        v-model="viewDialogVisible"
        title="药品详情"
        width="760px"
        class="medicine-dialog"
        align-center
    >
      <template #header>
        <div class="dialog-header">
          <i class="fa-solid fa-info-circle dialog-icon"></i>
          <div>
            <span class="dialog-title">药品详情</span>
            <span class="dialog-subtitle">完整药品信息</span>
          </div>
        </div>
      </template>
      <el-descriptions :column="2" border size="small" class="detail-desc">
        <el-descriptions-item label="药品编码">{{ viewData.medicineCode }}</el-descriptions-item>
        <el-descriptions-item label="药品名称">{{ viewData.name }}</el-descriptions-item>
        <el-descriptions-item label="通用名">{{ viewData.commonName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="药品分类">{{ viewData.categoryName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="规格">{{ viewData.spec || '-' }}</el-descriptions-item>
        <el-descriptions-item label="单位">{{ viewData.unit || '-' }}</el-descriptions-item>
        <el-descriptions-item label="零售价">
          <span class="price-text">¥{{ formatPrice(viewData.unitPrice) }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="成本价">¥{{ formatPrice(viewData.costPrice) }}</el-descriptions-item>
        <el-descriptions-item label="库存数量">
          <span :class="{ 'stock-warning': viewData.stockQuantity <= viewData.minStock }">
            {{ viewData.stockQuantity }}
          </span>
        </el-descriptions-item>
        <el-descriptions-item label="最低库存预警">{{ viewData.minStock }}</el-descriptions-item>
        <el-descriptions-item label="生产厂家" :span="2">{{ viewData.manufacturer || '-' }}</el-descriptions-item>
        <el-descriptions-item label="批准文号" :span="2">{{ viewData.approvalNo || '-' }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <span :class="['status-dot', viewData.status === 1 ? 'enabled' : 'disabled']"></span>
          <span class="status-text">{{ viewData.status === 1 ? '在用' : '停用' }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ viewData.remark || '-' }}</el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ viewData.createdTime }}</el-descriptions-item>
        <el-descriptions-item label="更新时间">{{ viewData.updatedTime }}</el-descriptions-item>
      </el-descriptions>
      <template #footer>
        <div class="dialog-footer">
          <el-button class="btn-cancel" @click="viewDialogVisible = false">关闭</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 库存预警弹窗 -->
    <el-dialog
        v-model="warningDialogVisible"
        title="库存预警列表"
        width="1000px"
        class="medicine-dialog"
        align-center
    >
      <template #header>
        <div class="dialog-header">
          <i class="fa-solid fa-triangle-exclamation dialog-icon" style="background: linear-gradient(135deg, #f5a623, #f39c12);"></i>
          <div>
            <span class="dialog-title">库存预警</span>
            <span class="dialog-subtitle">库存低于预警值的药品</span>
          </div>
        </div>
      </template>
      <el-table :data="warningData" stripe border class="data-table">
        <el-table-column prop="medicineCode" label="药品编码" width="140" />
        <el-table-column prop="name" label="药品名称" min-width="150" />
        <el-table-column prop="spec" label="规格" width="120" />
        <el-table-column prop="stockQuantity" label="当前库存" width="100" align="center">
          <template #default="{ row }">
            <span class="stock-warning">{{ row.stockQuantity }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="minStock" label="预警值" width="100" align="center" />
        <el-table-column prop="unit" label="单位" width="80" align="center" />
        <el-table-column prop="manufacturer" label="生产厂家" width="200" show-overflow-tooltip />
      </el-table>
      <div class="pagination-wrap" style="margin-top: 20px;">
        <el-pagination
            v-model:current-page="warningParams.current"
            v-model:page-size="warningParams.size"
            :total="warningTotal"
            layout="total, prev, pager, next"
            background
            @current-change="loadWarningList"
        />
      </div>
    </el-dialog>

    <!-- 分类管理弹窗 -->
    <el-dialog
        v-model="categoryDialogVisible"
        width="700px"
        class="medicine-dialog"
        align-center
    >
      <template #header>
        <div class="dialog-header">
          <i class="fa-solid fa-folder-tree dialog-icon"></i>
          <div>
            <span class="dialog-title">药品分类管理</span>
            <span class="dialog-subtitle">维护药品分类结构</span>
          </div>
        </div>
      </template>
      <div class="category-manage">
        <div class="category-toolbar">
          <el-button class="add-category-btn" @click="handleAddCategory">
            <i class="fa-solid fa-plus"></i> 新增分类
          </el-button>
        </div>
        <el-tree
            :data="categoryTree"
            :props="{ label: 'name', children: 'children' }"
            node-key="categoryId"
            default-expand-all
            highlight-current
            class="category-tree"
        >
          <template #default="{ node, data }">
            <span class="category-node">
              <span class="category-name">
                <i class="fa-solid fa-folder"></i>
                {{ node.label }}
              </span>
              <span class="category-actions">
                <el-button link type="primary" size="small" @click.stop="handleEditCategory(data)">
                  <i class="fa-solid fa-pen"></i> 编辑
                </el-button>
                <el-button link type="danger" size="small" @click.stop="handleDeleteCategory(data)">
                  <i class="fa-solid fa-trash"></i> 删除
                </el-button>
              </span>
            </span>
          </template>
        </el-tree>
      </div>
    </el-dialog>

    <!-- 分类新增/编辑弹窗 -->
    <el-dialog
        v-model="categoryFormDialogVisible"
        width="500px"
        class="medicine-dialog"
        align-center
        @close="resetCategoryForm"
    >
      <template #header>
        <div class="dialog-header">
          <i class="fa-solid fa-folder dialog-icon"></i>
          <div>
            <span class="dialog-title">{{ categoryDialogTitle }}</span>
            <span class="dialog-subtitle">{{ categoryDialogTitle === '新增分类' ? '添加新的药品分类' : '修改分类信息' }}</span>
          </div>
        </div>
      </template>
      <el-form
          ref="categoryFormRef"
          :model="categoryFormData"
          :rules="categoryFormRules"
          label-position="top"
          class="edit-form"
      >
        <el-form-item label="上级分类" prop="parentId">
          <el-tree-select
              v-model="categoryFormData.parentId"
              :data="categoryTree"
              :props="{ label: 'name', value: 'categoryId' }"
              placeholder="请选择上级分类（不选则为顶级分类）"
              clearable
              check-strictly
              style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="分类名称" prop="name" required>
          <el-input v-model="categoryFormData.name" placeholder="请输入分类名称" maxlength="100" show-word-limit />
        </el-form-item>
        <el-form-item label="排序" prop="sortOrder">
          <el-input-number v-model="categoryFormData.sortOrder" :min="0" :max="999" style="width: 100%" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="categoryFormData.status">
            <el-radio :label="1">启用</el-radio>
            <el-radio :label="0">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="categoryFormData.remark" type="textarea" :rows="3" maxlength="500" show-word-limit />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button class="btn-cancel" @click="categoryFormDialogVisible = false">取消</el-button>
          <el-button class="btn-save" :loading="categorySubmitLoading" @click="handleSubmitCategory">
            确定
          </el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  getMedicinePage,
  getMedicineById,
  addMedicine,
  updateMedicine,
  deleteMedicine,
  batchDeleteMedicine,
  updateMedicineStatus,
  getStockWarningList
} from '@/api/medicine'
import {
  getCategoryTree,
  getCategoryList,
  addCategory,
  updateCategory,
  deleteCategory
} from '@/api/medicineCategory'

// 表格样式
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

// 数据定义
const loading = ref(false)
const submitLoading = ref(false)
const tableData = ref([])
const total = ref(0)
const selectedIds = ref([])
const categoryTree = ref([])
const categoryList = ref([])

// 搜索表单
const searchForm = reactive({
  name: '',
  medicineCode: '',
  categoryId: null,
  status: null
})

// 分页参数
const pageParams = reactive({
  current: 1,
  size: 10
})

// 弹窗相关
const dialogVisible = ref(false)
const dialogTitle = ref('新增药品')
const formRef = ref()
const formData = reactive({
  medicineId: null,
  medicineCode: '',
  name: '',
  commonName: '',
  categoryId: null,
  spec: '',
  unit: '',
  manufacturer: '',
  approvalNo: '',
  unitPrice: 0,
  costPrice: 0,
  stockQuantity: 0,
  minStock: 10,
  status: 1,
  remark: ''
})

// 表单验证规则
const formRules = {
  name: [{ required: true, message: '请输入药品名称', trigger: 'blur' }],
  categoryId: [{ required: true, message: '请选择药品分类', trigger: 'change' }],
  spec: [{ required: true, message: '请输入规格', trigger: 'blur' }],
  unit: [{ required: true, message: '请选择单位', trigger: 'change' }],
  unitPrice: [{ required: true, message: '请输入零售价', trigger: 'blur' }],
  stockQuantity: [{ required: true, message: '请输入库存数量', trigger: 'blur' }]
}

// 查看详情
const viewDialogVisible = ref(false)
const viewData = ref({})

// 库存预警
const warningDialogVisible = ref(false)
const warningData = ref([])
const warningTotal = ref(0)
const warningCount = ref(0)
const warningParams = reactive({
  current: 1,
  size: 10
})

// 分类管理
const categoryDialogVisible = ref(false)
const categoryFormDialogVisible = ref(false)
const categoryDialogTitle = ref('新增分类')
const categoryFormRef = ref()
const categorySubmitLoading = ref(false)
const categoryFormData = reactive({
  categoryId: null,
  parentId: null,
  name: '',
  sortOrder: 0,
  status: 1,
  remark: ''
})

const categoryFormRules = {
  name: [{ required: true, message: '请输入分类名称', trigger: 'blur' }]
}

// 格式化价格
const formatPrice = (price) => {
  if (price === null || price === undefined) return '0.00'
  return Number(price).toFixed(2)
}

// 重置表单
const resetForm = () => {
  Object.assign(formData, {
    medicineId: null,
    medicineCode: '',
    name: '',
    commonName: '',
    categoryId: null,
    spec: '',
    unit: '',
    manufacturer: '',
    approvalNo: '',
    unitPrice: 0,
    costPrice: 0,
    stockQuantity: 0,
    minStock: 10,
    status: 1,
    remark: ''
  })
  if (formRef.value) {
    formRef.value.clearValidate()
  }
}

// 加载数据
const loadData = async () => {
  loading.value = true
  try {
    const params = {
      name: searchForm.name || undefined,
      medicineCode: searchForm.medicineCode || undefined,
      categoryId: searchForm.categoryId || undefined,
      status: searchForm.status !== null ? searchForm.status : undefined,
      ...pageParams
    }
    const res = await getMedicinePage(params)
    tableData.value = res.records || []
    total.value = res.total || 0
  } catch (error) {
    console.error('加载药品列表失败:', error)
  } finally {
    loading.value = false
  }
}

// 加载分类树
const loadCategoryTree = async () => {
  try {
    const res = await getCategoryTree()
    categoryTree.value = res || []
  } catch (error) {
    console.error('加载分类树失败:', error)
  }
}

// 加载分类列表
const loadCategoryList = async () => {
  try {
    const res = await getCategoryList()
    categoryList.value = res || []
  } catch (error) {
    console.error('加载分类列表失败:', error)
  }
}

// 加载预警数量
const loadWarningCount = async () => {
  try {
    const res = await getStockWarningList({ current: 1, size: 1 })
    warningCount.value = res.total || 0
  } catch (error) {
    console.error('加载预警数量失败:', error)
  }
}

// 加载预警列表
const loadWarningList = async () => {
  try {
    const res = await getStockWarningList(warningParams)
    warningData.value = res.records || []
    warningTotal.value = res.total || 0
  } catch (error) {
    console.error('加载预警列表失败:', error)
  }
}

// 事件处理
const handleSearch = () => {
  pageParams.current = 1
  loadData()
}

const handleReset = () => {
  searchForm.name = ''
  searchForm.medicineCode = ''
  searchForm.categoryId = null
  searchForm.status = null
  handleSearch()
}

const handleSelectionChange = (selection) => {
  selectedIds.value = selection.map(item => item.medicineId)
}

const handleAdd = () => {
  dialogTitle.value = '新增药品'
  resetForm()
  dialogVisible.value = true
}

const handleEdit = async (row) => {
  dialogTitle.value = '编辑药品'
  try {
    const res = await getMedicineById(row.medicineId)
    Object.assign(formData, res)
    dialogVisible.value = true
  } catch (error) {
    console.error('获取药品详情失败:', error)
  }
}

const handleView = async (row) => {
  try {
    const res = await getMedicineById(row.medicineId)
    viewData.value = res
    viewDialogVisible.value = true
  } catch (error) {
    console.error('获取药品详情失败:', error)
  }
}

const handleSubmit = async () => {
  if (!formRef.value) return

  await formRef.value.validate(async (valid) => {
    if (valid) {
      submitLoading.value = true
      try {
        if (formData.medicineId) {
          await updateMedicine(formData)
          ElMessage.success('修改成功')
        } else {
          await addMedicine(formData)
          ElMessage.success('新增成功')
        }
        dialogVisible.value = false
        loadData()
        loadWarningCount()
      } catch (error) {
        console.error('提交失败:', error)
      } finally {
        submitLoading.value = false
      }
    }
  })
}

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm(
        `确定要删除药品「${row.name}」吗？删除后不可恢复。`,
        '删除确认',
        {
          confirmButtonText: '删除',
          cancelButtonText: '取消',
          type: 'warning',
          confirmButtonClass: 'el-button--danger'
        }
    )
    await deleteMedicine(row.medicineId)
    ElMessage.success('删除成功')
    loadData()
    loadWarningCount()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除失败:', error)
    }
  }
}

const handleBatchDelete = async () => {
  if (selectedIds.value.length === 0) return

  try {
    await ElMessageBox.confirm(
        `确定要删除选中的 ${selectedIds.value.length} 个药品吗？删除后不可恢复。`,
        '批量删除确认',
        {
          confirmButtonText: '删除',
          cancelButtonText: '取消',
          type: 'warning',
          confirmButtonClass: 'el-button--danger'
        }
    )
    await batchDeleteMedicine(selectedIds.value)
    ElMessage.success('批量删除成功')
    selectedIds.value = []
    loadData()
    loadWarningCount()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('批量删除失败:', error)
    }
  }
}

const handleToggleStatus = async (row) => {
  const newStatus = row.status === 1 ? 0 : 1
  const action = newStatus === 1 ? '启用' : '停用'
  try {
    await ElMessageBox.confirm(
        `确定要${action}药品「${row.name}」吗？`,
        `${action}确认`,
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }
    )
    await updateMedicineStatus(row.medicineId, newStatus)
    ElMessage.success(`${action}成功`)
    loadData()
    loadWarningCount()
  } catch (error) {
    if (error !== 'cancel') {
      console.error(`${action}失败:`, error)
    }
  }
}

const handleStockWarning = async () => {
  warningParams.current = 1
  await loadWarningList()
  warningDialogVisible.value = true
}

const handleCategoryManage = () => {
  loadCategoryTree()
  categoryDialogVisible.value = true
}

const handleAddCategory = () => {
  categoryDialogTitle.value = '新增分类'
  resetCategoryForm()
  categoryFormDialogVisible.value = true
}

const handleEditCategory = (data) => {
  categoryDialogTitle.value = '编辑分类'
  Object.assign(categoryFormData, {
    categoryId: data.categoryId,
    parentId: data.parentId,
    name: data.name,
    sortOrder: data.sortOrder || 0,
    status: data.status,
    remark: data.remark || ''
  })
  categoryFormDialogVisible.value = true
}

const handleDeleteCategory = async (data) => {
  try {
    await ElMessageBox.confirm(
        `确定要删除分类「${data.name}」吗？删除后该分类下的药品将无法关联。`,
        '删除分类',
        {
          confirmButtonText: '删除',
          cancelButtonText: '取消',
          type: 'warning',
          confirmButtonClass: 'el-button--danger'
        }
    )
    await deleteCategory(data.categoryId)
    ElMessage.success('删除成功')
    loadCategoryTree()
    loadCategoryList()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除失败:', error)
    }
  }
}

const handleSubmitCategory = async () => {
  if (!categoryFormRef.value) return

  await categoryFormRef.value.validate(async (valid) => {
    if (valid) {
      categorySubmitLoading.value = true
      try {
        if (categoryFormData.categoryId) {
          await updateCategory(categoryFormData)
          ElMessage.success('修改成功')
        } else {
          await addCategory(categoryFormData)
          ElMessage.success('新增成功')
        }
        categoryFormDialogVisible.value = false
        loadCategoryTree()
        loadCategoryList()
      } catch (error) {
        console.error('提交失败:', error)
      } finally {
        categorySubmitLoading.value = false
      }
    }
  })
}

const resetCategoryForm = () => {
  Object.assign(categoryFormData, {
    categoryId: null,
    parentId: null,
    name: '',
    sortOrder: 0,
    status: 1,
    remark: ''
  })
  categoryFormRef.value?.resetFields()
}

const handleSizeChange = (size) => {
  pageParams.size = size
  pageParams.current = 1
  loadData()
}

const handleCurrentChange = (current) => {
  pageParams.current = current
  loadData()
}

const handleDialogClose = () => {
  resetForm()
}

// 初始化
onMounted(() => {
  loadData()
  loadCategoryTree()
  loadCategoryList()
  loadWarningCount()
})
</script>

<style scoped>
.medicine-management-page {
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
  flex: 1;
  min-width: 220px;
}

.action-buttons {
  display: flex;
  gap: 12px;
  flex-shrink: 0;
}

.search-icon {
  color: #8b5a2b;
  font-size: 16px;
  opacity: 0.8;
}

.search-input {
  flex: 1;
  min-width: 200px;
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
  border: 1px solid rgba(139, 90, 43, 0.2) !important;
  box-shadow: none !important;
}

.filter-select :deep(.el-select__wrapper:hover),
.filter-select :deep(.el-select__wrapper.is-focus) {
  border-color: rgba(232, 165, 75, 0.5) !important;
  box-shadow: 0 0 0 1px rgba(232, 165, 75, 0.2) !important;
}

.search-btn,
.category-btn,
.add-btn {
  border-radius: 10px;
  padding: 10px 18px;
  font-weight: 600;
  border: none;
}

.search-btn {
  background: linear-gradient(135deg, #e8a54b, #d48232);
  color: #fff;
  box-shadow: 0 4px 14px rgba(212, 130, 50, 0.3);
}

.search-btn:hover {
  background: linear-gradient(135deg, #f0b55c, #e08d3a);
  color: #fff;
  box-shadow: 0 5px 18px rgba(212, 130, 50, 0.4);
}

.category-btn {
  background: rgba(139, 90, 43, 0.12);
  color: #8b5a2b;
  border: 1px solid rgba(139, 90, 43, 0.2);
}

.category-btn:hover {
  background: rgba(232, 165, 75, 0.15);
  border-color: rgba(232, 165, 75, 0.4);
  color: #d48232;
}

.add-btn {
  background: linear-gradient(135deg, #e8a54b, #d48232);
  color: #fff;
  box-shadow: 0 4px 14px rgba(212, 130, 50, 0.3);
}

.add-btn:hover {
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
}

.data-table :deep(.el-table__inner-wrapper::before) {
  display: none;
}

.data-table :deep(.el-table th.el-table__cell) {
  padding: 14px 0;
}

.data-table :deep(.el-table td.el-table__cell) {
  padding: 12px 0;
  border-bottom: 1px solid rgba(139, 90, 43, 0.06);
}

.data-table :deep(.el-table__row:hover > td) {
  background: rgba(232, 165, 75, 0.08) !important;
}

.data-table :deep(.striped-row td) {
  background: rgba(255, 250, 245, 0.5) !important;
}

.cell-code {
  font-weight: 600;
  color: #8b5a2b;
  font-family: monospace;
}

.cell-code.clickable {
  cursor: pointer;
  text-decoration: underline;
  text-decoration-color: rgba(212, 130, 50, 0.6);
}

.cell-name {
  font-weight: 500;
  color: #2c1810;
}

.price-text {
  color: #f56c6c;
  font-weight: 500;
}

.stock-quantity {
  font-weight: 500;
}

.stock-warning {
  color: #f56c6c;
  font-weight: bold;
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

.batch-bar {
  margin-top: 16px;
  padding: 12px 16px;
  background: rgba(232, 165, 75, 0.08);
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.batch-info {
  color: #5c4a32;
  font-size: 13px;
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

/* 对话框样式 */
.medicine-dialog :deep(.el-dialog) {
  border-radius: 16px;
  overflow: hidden;
  background: rgba(255, 252, 250, 0.98);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.6);
  box-shadow: 0 8px 40px rgba(61, 41, 20, 0.15);
}

.medicine-dialog :deep(.el-dialog__header) {
  padding: 20px 24px;
  margin: 0;
  border-bottom: 1px solid rgba(139, 90, 43, 0.12);
  background: rgba(255, 250, 245, 0.5);
}

.medicine-dialog :deep(.el-dialog__headerbtn) {
  width: 36px;
  height: 36px;
  top: 18px;
  right: 20px;
  color: #8b5a2b;
}

.medicine-dialog :deep(.el-dialog__headerbtn:hover) {
  color: #d48232;
  background: rgba(232, 165, 75, 0.15);
  border-radius: 8px;
}

.dialog-header {
  display: flex;
  align-items: center;
  gap: 14px;
}

.dialog-icon {
  width: 44px;
  height: 44px;
  line-height: 44px;
  text-align: center;
  font-size: 20px;
  color: #fff;
  background: linear-gradient(135deg, #e8a54b, #d48232);
  border-radius: 12px;
  box-shadow: 0 4px 14px rgba(212, 130, 50, 0.3);
}

.dialog-title {
  display: block;
  font-size: 17px;
  font-weight: 700;
  color: #2c1810;
}

.dialog-subtitle {
  font-size: 12px;
  color: #5c4a32;
  margin-top: 2px;
}

.medicine-dialog :deep(.el-dialog__body) {
  padding: 24px 24px 8px;
  max-height: calc(100vh - 220px);
  overflow-y: auto;
}

.edit-form :deep(.el-form-item) {
  margin-bottom: 18px;
}

.edit-form :deep(.el-form-item__label) {
  color: #5c4a32;
  font-weight: 500;
  font-size: 13px;
  padding-bottom: 6px;
}

.edit-form :deep(.el-form-item.is-required .el-form-item__label::before) {
  color: #d48232;
}

.edit-form :deep(.el-input__wrapper),
.edit-form :deep(.el-input-number .el-input__wrapper),
.edit-form :deep(.el-textarea__inner) {
  border-radius: 10px;
  border: 1px solid rgba(139, 90, 43, 0.2);
  background: rgba(255, 255, 255, 0.8);
  box-shadow: none;
}

.edit-form :deep(.el-input__wrapper:hover),
.edit-form :deep(.el-input-number .el-input__wrapper:hover),
.edit-form :deep(.el-textarea__inner:hover) {
  border-color: rgba(232, 165, 75, 0.5);
}

.edit-form :deep(.el-input__wrapper.is-focus),
.edit-form :deep(.el-input-number .el-input__wrapper.is-focus),
.edit-form :deep(.el-textarea__inner:focus) {
  border-color: rgba(232, 165, 75, 0.5);
  box-shadow: 0 0 0 1px rgba(232, 165, 75, 0.15);
}

.edit-form :deep(.input-disabled .el-input__wrapper) {
  background: rgba(245, 242, 238, 0.8);
  border-color: rgba(139, 90, 43, 0.12);
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  padding: 16px 0 8px;
}

.btn-cancel {
  border-radius: 10px;
  padding: 10px 20px;
  border: 1px solid rgba(139, 90, 43, 0.3);
  color: #5c4a32;
  background: rgba(255, 255, 255, 0.8);
}

.btn-cancel:hover {
  border-color: rgba(232, 165, 75, 0.5);
  color: #8b5a2b;
  background: rgba(255, 250, 245, 0.9);
}

.btn-save {
  border-radius: 10px;
  padding: 10px 24px;
  border: none;
  color: #fff;
  background: linear-gradient(135deg, #e8a54b, #d48232);
  box-shadow: 0 4px 14px rgba(212, 130, 50, 0.3);
}

.btn-save:hover {
  background: linear-gradient(135deg, #f0b55c, #e08d3a);
  color: #fff;
  box-shadow: 0 5px 18px rgba(212, 130, 50, 0.4);
}

.detail-desc {
  margin-bottom: 16px;
}

.detail-desc :deep(.el-descriptions__label) {
  background: rgba(139, 90, 43, 0.05);
  color: #5c4a32;
  font-weight: 600;
}

.detail-desc :deep(.el-descriptions__content) {
  color: #2c1810;
}

/* 分类管理样式 */
.category-manage {
  max-height: 500px;
  overflow-y: auto;
}

.category-toolbar {
  margin-bottom: 16px;
  padding-bottom: 12px;
  border-bottom: 1px solid rgba(139, 90, 43, 0.1);
}

.add-category-btn {
  background: linear-gradient(135deg, #e8a54b, #d48232);
  border: none;
  color: #fff;
  border-radius: 8px;
  padding: 8px 16px;
  font-size: 13px;
}

.category-tree {
  background: transparent;
}

.category-tree :deep(.el-tree-node__content) {
  height: 44px;
  border-radius: 8px;
  padding-right: 12px;
}

.category-tree :deep(.el-tree-node__content:hover) {
  background: rgba(232, 165, 75, 0.08);
}

.category-node {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
  padding-right: 8px;
}

.category-name {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #5c4a32;
  font-size: 14px;
}

.category-name i {
  color: #e8a54b;
}

.category-actions {
  display: none;
  gap: 8px;
}

.category-node:hover .category-actions {
  display: flex;
}

/* 操作列按钮样式 */
.data-table :deep(.el-button.is-link) {
  padding: 4px 8px;
  font-size: 13px;
}

.data-table :deep(.el-button.is-link[type="primary"]) {
  color: #d48232;
}

.data-table :deep(.el-button.is-link[type="primary"]:hover) {
  color: #e8a54b;
}

.data-table :deep(.el-button.is-link[type="warning"]) {
  color: #f39c12;
}

.data-table :deep(.el-button.is-link[type="warning"]:hover) {
  color: #f5a623;
}

.data-table :deep(.el-button.is-link[type="success"]) {
  color: #52c41a;
}

.data-table :deep(.el-button.is-link[type="success"]:hover) {
  color: #73d13d;
}

.data-table :deep(.el-button.is-link.el-button--danger) {
  color: #f56c6c;
}

.data-table :deep(.el-button.is-link.el-button--danger:hover) {
  color: #f89898;
}
</style>