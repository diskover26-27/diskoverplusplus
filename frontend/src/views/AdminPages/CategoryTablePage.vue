<template>
  <v-container class="mt-16 fill-height d-flex align-top justify-center py-8">
    <v-sheet class="pa-4 pa-sm-8 rounded-xl" elevation="2" width="100%" max-width="1000">
      
      <div class="d-flex flex-column flex-sm-row justify-space-between align-sm-center mb-6">
        <div class="text-h5 font-weight-bold mb-4 mb-sm-0">Categories</div>
        
        <v-btn
          color="maroon"
          class="text-white px-4"
          prepend-icon="mdi-plus"
          @click="onClickNewCategory"
        >
          Add New Category
        </v-btn>
      </div>

      <v-divider class="mb-6"></v-divider>

      <CategoryTable 
        @edit-item="onEditItem" 
        @delete-item="prepareDelete" 
        :categories="categories" 
      />
    </v-sheet>

    <ConfirmDeleteModal
      :isVisible="isDeleteModalVisible"
      :isSubmitting="isSubmitting"
      :itemName="categoryToDelete?.name"
      itemType="Category"
      @confirm="handleDeleteConfirm"
      @cancel="isDeleteModalVisible = false"
    />
  </v-container>
</template>

<script>
import axios from 'axios';
import AdminVerifierMixin from "@/mixins/AdminVerifierMixin";
import CategoryTable from "@/components/admin/CategoryTable.vue"; 
import ConfirmDeleteModal from "@/components/admin/ConfirmDeleteModal.vue";
import { useMainStore } from "@/stores/index";

export default {
  mixins: [AdminVerifierMixin],
  components: { CategoryTable, ConfirmDeleteModal },
  data() {
    return {
      isDeleteModalVisible: false,
      isSubmitting: false,
      categoryToDelete: null,
    };
  },
  computed: {
    categories() {
      const mainStore = useMainStore();
      return mainStore.categories;
    },
  },
  mounted() {
    this.refreshCategories();
  },
  methods: {
    async refreshCategories() {
      const mainStore = useMainStore();
      try {
        const response = await axios.get('/admin/categories/');
        mainStore.setCategories(response.data);
      } catch (error) {
        console.error("Error fetching categories:", error);
      }
    },
    onClickNewCategory() {
      this.$router.push(`/categoryform/create`);
    },
    onEditItem(id) {
      this.$router.push(`/categoryform/update/${id}`);
    },
    // The table emits 'delete-item', which we catch here
    prepareDelete(id) {
      console.log("Preparing to delete ID:", id);
      this.categoryToDelete = this.categories.find(c => c.id === id);
      this.isDeleteModalVisible = true;
    },
    async handleDeleteConfirm() {
      if (!this.categoryToDelete) return;

      this.isSubmitting = true;
      try {
        await axios.delete(`/admin/categories/${this.categoryToDelete.id}/`);
        await this.refreshCategories(); // Update the list
        this.isDeleteModalVisible = false;
        this.categoryToDelete = null;
      } catch (error) {
        console.error("Delete failed:", error);
        alert("Delete failed. Check console.");
      } finally {
        this.isSubmitting = false;
      }
    },
  },
};
</script>

<style scoped>
@import "@/assets/stylesheets/style.css";
</style>
