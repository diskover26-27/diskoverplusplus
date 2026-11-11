<template>
  <v-container class="fill-height d-flex align-top justify-center py-8">
    <v-sheet
      class="pa-4 pa-sm-8 rounded-xl"
      elevation="2"
      width="100%"
      max-width="600"
    >
      <div class="text-h5 font-weight-bold mb-6">
        {{ mode === 'create' ? 'Create New Tag' : 'Edit Tag' }}
      </div>

      <v-divider class="mb-6"></v-divider>

      <v-form @submit.prevent="onSubmitClick">
        <div class="text-subtitle-1 mb-2 font-weight-medium">Tag Details</div>

        <v-text-field
          v-model="name"
          label="Tag Name"
          placeholder="e.g., WiFi, Pet Friendly"
          variant="outlined"
          density="comfortable"
          class="mb-2"
          :readonly="isReadOnly"
          :disabled="isSubmitting"
        />

        <v-divider class="mb-6 mt-4"></v-divider>

        <v-row class="mt-2" dense>
          <v-col v-if="mode !== 'create'" cols="12" sm="auto">
            <v-btn
              color="error"
              block
              :disabled="isSubmitting"
              @click="isDeleteConfirmVisible = true"
            >
              Delete Tag
            </v-btn>
          </v-col>

          <v-spacer class="d-none d-sm-block"></v-spacer>

          <v-col cols="12" sm="auto">
            <v-btn
              variant="text"
              block
              :disabled="isSubmitting"
              @click="onCancelClick"
            >
              Cancel
            </v-btn>
          </v-col>

          <v-col cols="12" sm="auto">
            <v-btn
              color="maroon"
              class="text-white"
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
      :is-visible="isDeleteConfirmVisible"
      :is-submitting="isSubmitting"
      :item-name="name"
      item-type="Tag"
      @confirm="onDeleteConfirm"
      @cancel="isDeleteConfirmVisible = false"
    />
  </v-container>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import axios from 'axios';
import ConfirmDeleteModal from '@/components/admin/ConfirmDeleteModal.vue';

const route = useRoute();
const router = useRouter();

const name = ref('');
const isSubmitting = ref(false);
const isDeleteConfirmVisible = ref(false);

const id = computed(() => route.params.id);
const mode = computed(() => (id.value ? 'update' : 'create'));
const isReadOnly = computed(() => mode.value === 'delete');

onMounted(() => {
  if (mode.value === 'update' || mode.value === 'delete') {
    getUpdateData(id.value);
  }
});

const getUpdateData = async (tagId) => {
  try {
    const response = await axios.get(`/admin/tags/${tagId}/`);
    name.value = response.data.name;
  } catch (error) {
    console.error(`Failed to get tag ${tagId}:`, error);
  }
};

const onSubmitClick = async () => {
  if (!name.value) {
    alert('Please enter a tag name.');
    return;
  }

  isSubmitting.value = true;
  const endpoint =
    mode.value === 'create' ? '/admin/tags/' : `/admin/tags/${id.value}/`;
  const method = mode.value === 'create' ? 'post' : 'patch';

  try {
    await axios({
      method,
      url: endpoint,
      data: { name: name.value },
    });
    router.push('/admin/browse/tags');
  } catch (error) {
    console.error('Failed to submit tag:', error);
    alert('Failed to save tag. Check console for details.');
  } finally {
    isSubmitting.value = false;
  }
};

const onDeleteConfirm = async () => {
  isSubmitting.value = true;
  try {
    await axios.delete(`/admin/tags/${id.value}/`);
    isDeleteConfirmVisible.value = false;
    router.push('/admin/browse/tags');
  } catch (error) {
    console.error('Failed to delete tag:', error);
    alert('Failed to delete tag.');
  } finally {
    isSubmitting.value = false;
  }
};

const onCancelClick = () => router.push('/admin/browse/tags');
</script>

<style scoped>
@import '@/assets/stylesheets/style.css';
</style>
