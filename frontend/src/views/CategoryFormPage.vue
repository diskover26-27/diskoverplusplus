<template>
  <v-container class="fill-height d-flex align-top justify-center py-8">
    <v-sheet class="pa-4 pa-sm-8 rounded-xl" elevation="2" width="100%" max-width="600">
      <div class="text-h5 font-weight-bold mb-6">
        {{ mode === 'create' ? 'Create New Category' : 'Edit Category' }}
      </div>

      <v-divider class="mb-6"></v-divider>

      <v-form @submit.prevent="onSubmitClick">
        <div class="text-subtitle-1 mb-2 font-weight-medium">Category Details</div>
        
        <v-text-field
          v-model="name"
          label="Category Name"
          placeholder="e.g., Food & Dining"
          variant="outlined"
          density="comfortable"
          class="mb-2"
          :readonly="isReadOnly"
          :disabled="isSubmitting"
        />

        <v-text-field
          v-model="url"
          label="URL Slug"
          placeholder="e.g., food-and-dining"
          variant="outlined"
          density="comfortable"
          class="mb-2"
          :readonly="isReadOnly"
          :disabled="isSubmitting"
        />

        <div class="text-subtitle-1 mb-2 mt-4 font-weight-medium">Map Display</div>
        <div class="d-flex align-center flex-wrap mb-6">
          <label class="mr-4 text-body-1 mb-2 mb-sm-0">Route Color:</label>
          <div class="d-flex align-center">
            <input
              v-model="color"
              type="color"
              class="color-picker"
              :disabled="isReadOnly || isSubmitting"
              @change="onColorSelected"
            />
            <span class="ml-3 text-caption text-medium-emphasis text-uppercase">{{ color }}</span>
          </div>
        </div>

        <v-divider class="mb-6"></v-divider>

        <v-row class="mt-2" dense>
          <v-col cols="12" sm="auto" v-if="mode !== 'create'">
            <v-btn 
              color="error" 
              block
              @click="isDeleteConfirmVisible = true" 
              :disabled="isSubmitting"
            >
              Delete Category
            </v-btn>
          </v-col>

          <v-spacer class="d-none d-sm-block"></v-spacer>

          <v-col cols="12" sm="auto">
            <v-btn 
              color="black" 
              block
              @click="onCancelClick"
              :disabled="isSubmitting"
            >
              Cancel
            </v-btn>
          </v-col>

          <v-col cols="12" sm="auto">
            <v-btn 
              color="black" 
              block
              type="submit"
              :loading="isSubmitting"
            >
              {{ mode === 'create' ? 'Create' : 'Save Changes' }}
            </v-btn>
          </v-col>
        </v-row>

      </v-form>
    </v-sheet>

    <ConfirmDeleteModal
      :isVisible="isDeleteConfirmVisible"
      :isSubmitting="isSubmitting"
      :itemName="name"
      itemType="Category"
      @confirm="onDeleteConfirm"
      @cancel="isDeleteConfirmVisible = false"
    />
  </v-container>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import axios from 'axios';
import ConfirmDeleteModal from "@/components/admin/ConfirmDeleteModal.vue";

const route = useRoute();
const router = useRouter();

const name = ref('');
const url = ref('');
const color = ref('#000000');
const isSubmitting = ref(false);
const isDeleteConfirmVisible = ref(false);

const id = computed(() => route.params.id);
const mode = computed(() => id.value ? 'update' : 'create'); 
const isReadOnly = computed(() => mode.value === 'delete');

onMounted(() => {
  if (mode.value === 'update' || mode.value === 'delete') {
    getUpdateData(id.value);
  }
});

const getUpdateData = async (categoryId) => {
  try {
    const response = await axios.get(`/admin/categories/${categoryId}/`);
    const data = response.data;
    name.value = data.name;
    url.value = data.url;
    color.value = data.route_color; 
  } catch (error) {
    console.error(`Failed to get category ${categoryId}:`, error);
  }
};

const onSubmitClick = async () => {
  if (!name.value || !url.value) {
    alert("Please fill in all fields.");
    return;
  }

  isSubmitting.value = true;
  const endpoint = mode.value === 'create' ? '/admin/categories/' : `/admin/categories/${id.value}/`;
  const method = mode.value === 'create' ? 'post' : 'patch';

  try {
    await axios({
      method,
      url: endpoint,
      data: { name: name.value, url: url.value, route_color: color.value },
    });
    router.push('/admin/browse/categories'); 
  } catch (error) {
    console.error('Failed to submit category:', error);
    alert('Failed to save category. Check console for details.');
  } finally {
    isSubmitting.value = false;
  }
};

const onDeleteConfirm = async () => {
  isSubmitting.value = true;
  try {
    await axios.delete(`/admin/categories/${id.value}/`);
    isDeleteConfirmVisible.value = false; 
    router.push('/admin/browse/categories'); 
  } catch (error) {
    console.error('Failed to delete category:', error);
    alert('Failed to delete category.');
  } finally {
    isSubmitting.value = false;
  }
};

const onCancelClick = () => router.push('/admin/browse/categories');

const onColorSelected = (event) => {
  color.value = event.target.value;
};
</script>

<style scoped>
.color-picker {
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  width: 50px;
  height: 50px;
  background-color: transparent;
  border: none;
  cursor: pointer;
  padding: 0;
}
.color-picker::-webkit-color-swatch {
  border-radius: 8px;
  border: 2px solid #e0e0e0;
}
.color-picker::-moz-color-swatch {
  border-radius: 8px;
  border: 2px solid #e0e0e0;
}
</style>