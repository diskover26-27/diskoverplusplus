<template>
  <v-container class="mt-16 fill-height d-flex align-top justify-center py-8">
    <v-sheet
      class="pa-4 pa-sm-8 rounded-xl"
      elevation="2"
      width="100%"
      max-width="1000"
    >
      <div
        class="d-flex flex-column flex-sm-row justify-space-between align-sm-center mb-6"
      >
        <div class="text-h5 font-weight-bold mb-4 mb-sm-0">Tags</div>
        <v-btn
          color="maroon"
          class="text-white px-4"
          prepend-icon="mdi-plus"
          @click="onClickNewTag"
        >
          Add New Tag
        </v-btn>
      </div>

      <v-divider class="mb-6"></v-divider>

      <TagTable
        :tags="tags"
        @edit-item="onEditItem"
        @delete-item="prepareDelete"
      />
    </v-sheet>

    <ConfirmDeleteModal
      :is-visible="isDeleteModalVisible"
      :is-submitting="isSubmitting"
      :item-name="tagToDelete?.name"
      item-type="Tag"
      @confirm="handleDeleteConfirm"
      @cancel="isDeleteModalVisible = false"
    />
  </v-container>
</template>

<script>
import axios from 'axios';
import AdminVerifierMixin from '@/mixins/AdminVerifierMixin';
import TagTable from '@/components/admin/TagTable.vue';
import ConfirmDeleteModal from '@/components/admin/ConfirmDeleteModal.vue';
export default {
  components: {
    TagTable,
    ConfirmDeleteModal,
  },
  mixins: [AdminVerifierMixin],
  data() {
    return {
      tags: [],
      isDeleteModalVisible: false,
      isSubmitting: false,
      tagToDelete: null,
    };
  },
  mounted() {
    this.getTags();
  },
  methods: {
    async getTags() {
      try {
        const response = await axios.get('/admin/tags/');
        this.tags = response.data;
        console.log('Tags successfully retrieved');
      } catch (error) {
        console.error('Failed to GET tags', error);
      }
    },
    onClickNewTag() {
      this.$router.push(`/tagform/create`);
    },
    onEditItem(id) {
      this.$router.push(`/tagform/update/${id}`);
    },
    prepareDelete(id) {
      this.tagToDelete = this.tags.find((t) => t.id === id);
      this.isDeleteModalVisible = true;
    },
    async handleDeleteConfirm() {
      if (!this.tagToDelete) return;

      this.isSubmitting = true;
      try {
        await axios.delete(`/admin/tags/${this.tagToDelete.id}/`);
        await this.getTags();
        this.isDeleteModalVisible = false;
        this.tagToDelete = null;
      } catch (error) {
        console.error('Failed to delete item', error);
        alert('Error deleting tag. Please try again.');
      } finally {
        this.isSubmitting = false;
      }
    },
  },
};
</script>
<style scoped>
@import '@/assets/stylesheets/style.css';
</style>
