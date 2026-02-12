<template>
  <v-container class="mt-md-10">
  <v-card :class="$vuetify.display.mdAndUp ? 'elevation-24' : 'elevation-4'" class="mt-5 rounded-xl">
  <v-row>  
    <v-col cols="12" md="6">
      <!-- Map View -->
      <div style="position: relative;">
        <FormMapView
          height="300px"
          @click="handleMapClick"
          :defaultFormCoords="defaultCoords"
          :readonly="isReadOnly"
        />
        <v-btn 
          @click="resetMapView" 
          class="reset-map-btn"
          size="small"
          elevation="2"
        >
          Reset Map
        </v-btn>
      </div>
<!-- Coordinates Field -->
    <div class="px-10 pt-5 pa-md-5">
    <label>LatLng (Click on the map to set):</label>
              <v-text-field
                label="Coordinates"
                v-model="coordsDisplay"
                readonly
              />

            <!-- Subareas Dropdown -->
                <v-autocomplete
                  v-model="subareaIds"
                  :items="subareaItems"
                  item-title="name"
                  item-value="value"
                  :search-input.sync="subareaSearch"
                  multiple
                  cache-items
                  hide-selected
                  auto-select-first
                  chips
                  clearable
                  deletable-chips
                  label="Subareas"
                  placeholder="Search a subarea"
                  color="black"
                  :menu-props="{ zIndex: '1001' }"
                  :readonly="isReadOnly"
                  :error="isReadOnly"
                  @change="clearSubareaSearch"
                />

            <!-- Main Building Dropdown -->
                <v-autocomplete
                  v-model="mainBuildingId"
                  :items="mainBuildingItems"
                  :search-input.sync="mainBuildingSearch"
                  cache-items
                  hide-selected
                  auto-select-first
                  clearable
                  label="Main Building"
                  placeholder="Search a main building"
                  color="black"
                  :menu-props="{ zIndex: '1001' }"
                  :readonly="isReadOnly"
                  :error="isReadOnly"
                  item-title="name"
                  item-value="value"
                />
    </div>
      </v-col>

      <v-divider vertical></v-divider>

      <v-col cols="12" md="6">
      <!-- Name Field -->
       <div class="px-10 pb-5 pa-md-5">              
        <label>Name</label>
              <v-text-field
                placeholder="Name"
                color="black"
                v-model="name"
                :readonly="isReadOnly"
                :error="isReadOnly"
              />

            <!-- Category Dropdown -->
              <label>Category</label>
              <v-select
                :items="categoryItems"
                item-title="name"
                item-value="id"
                placeholder="Category"
                color="black"
                :menu-props="{ zIndex: '1001' }"
                v-model="categoryId"
                :readonly="isReadOnly"
                :error="isReadOnly"
              />

            <!-- Tags Dropdown -->
                <label>Tags</label>
                <v-select
                  :items="tagItems"
                  item-title="name"
                  item-value="value"
                  placeholder="Tags"
                  color="black"
                  chips
                  deletable-chips
                  :menu-props="{ zIndex: '1001' }"
                  multiple
                  v-model="tagIds"
                  :readonly="isReadOnly"
                  :error="isReadOnly"
                />
            <!-- Description Field -->
              <label>Description</label>
              <v-textarea
                v-model="description"
                color="black"
                auto-grow
                placeholder="Description"
                :readonly="isReadOnly"
                :error="isReadOnly"
              />
            <!-- Action Buttons -->
             <div class="d-flex align-center justify-center"> 
                  <v-btn
                  v-if="mode === 'create'"
                  color="black"
                  class="mr-2"
                  @click="handleCreateClick"
                  :disabled="isSubmitting"
                >
                  Create Location
                </v-btn>
                <v-btn
                  v-else-if="mode === 'update'"
                  color="success"
                  class="mr-2"
                  @click="handleUpdateClick"
                  :disabled="isSubmitting"
                >
                  Update Location
                </v-btn>
                <v-btn
                  v-else
                  color="error"
                  class="mr-2"
                  @click="handleDeleteClick"
                  :disabled="isSubmitting"
                >
                  Delete Location
                </v-btn>
                <v-btn @click="handleCancelClick">Cancel</v-btn>
              </div>
                </div>
      </v-col>
    </v-row>
</v-card>
</v-container>
</template>

<script>
import axios from "axios";
import AdminVerifierMixin from "@/mixins/AdminVerifierMixin";
import { useMainStore } from "@/stores/index.js";
import FormMapView from "@/components/map/FormMapView.vue";


export default {
  mixins: [AdminVerifierMixin],
  components: {
    FormMapView,
  },
  mounted() {
    this.handleRouteChange(); // Initialize the component state
    this.coords = this.defaultCoords;
  },
  data() {
    return {
      name: "",
      categoryId: "",
      tagIds: [],
      description: "",
      coords: [],
      defaultCoords: this.$defaultStartCoords,
      subareaIds: [],
      subareaSearch: "",
      subareaItems: [],
      mainBuildingId: "",
      mainBuildingSearch: "",
      mainBuildingItems: [],
      isSubmitting: false,
    };
  },
  computed: {
    categoryItems() {
      const mainStore = useMainStore();
      return mainStore.categories;
    },
    tagItems() {
      const mainStore = useMainStore();
      return mainStore.tags;
    },
    isReadOnly() {
      return this.mode === "delete";
    },
    id() {
      return this.$route.params.id;
    },
    mode() {
      return this.$route.params.mode;
    },
    coordsDisplay: {
      get() {
        return Array.isArray(this.coords) ? this.coords.join(", ") : "";
      },
      set(value) {
        const [lat, lng] = value.split(",").map((coord) => parseFloat(coord.trim()));
        if (!isNaN(lat) && !isNaN(lng)) {
          this.coords = [lat, lng];
        }
      },
    },
  },
  watch: {
    $route() {
      this.handleRouteChange(); // React to route changes
    },
    subareaSearch(newSearch) {
      this.apiGetSubareaItems(newSearch);
    },
    mainBuildingSearch(newSearch) {
      this.apiGetMainBuildingItems(newSearch);
    },
  },
  methods: {
    resetMapView() {
      this.$eventBus.emit("reset-map-view", 15);
    },
    handleMapClick(newCoords) {
      if (Array.isArray(newCoords)) {
        this.coords = newCoords;
      }
    },
    handleRouteChange() {
      // Reset form fields when the route changes
      this.name = "";
      this.categoryId = "";
      this.tagIds = [];
      this.description = "";
      this.coords = [];
      this.defaultCoords = this.$defaultStartCoords;
      this.subareaIds = [];
      this.subareaSearch = "";
      this.subareaItems = [];
      this.mainBuildingId = "";
      this.mainBuildingSearch = "";
      this.mainBuildingItems = [];

      // Re-fetch subareas and main buildings
      this.apiGetSubareaItems(""); // Fetch all subareas
      this.apiGetMainBuildingItems(""); // Fetch all main buildings

      // Fetch data if in update or delete mode
      if (this.mode === "update" || this.mode === "delete") {
        this.getUpdateData(this.id);
      }
    },
    async getUpdateData(id) {
      try {
        const response = await axios.get(`/admin/locations/${id}`);
        const {
          name,
          category,
          tags,
          description,
          lat,
          lng,
          subareas,
          main_building,
        } = response.data;
        this.name = name;
        this.categoryId = category;
        this.tagIds = tags;
        this.description = description;
        this.defaultCoords = [lat, lng];
        this.coords = [lat, lng];
        this.subareaIds = subareas
        console.log("Subareas:", subareas);
        if (main_building) {
          this.mainBuildingId = main_building.id;
        }
        console.log("Main Building:", main_building);
      } catch (error) {
        console.error("Error retrieving location data:", error);
      }
    },
    async apiGetSubareaItems(searchValue) {
      try {
        const params = searchValue ? { search: searchValue } : {};
        const response = await axios.get(`/admin/locations`, { params });
        this.subareaItems = response.data.map((sub) => ({
          name: sub.name,
          value: sub.id,
        }));
      } catch (error) {
        console.error("Error retrieving subarea items:", error);
      }
    },
    async apiGetMainBuildingItems(searchValue) {
      try {
        const params = searchValue ? { search: searchValue } : {};
        const response = await axios.get(`/admin/locations`, { params });
        this.mainBuildingItems = response.data.map((building) => ({
          name: building.name,
          value: building.id,
        }));
      } catch (error) {
        console.error("Error retrieving main building items:", error);
      }
    },
    handleCancelClick() {
      this.$router.go(-1);
    },
    async handleDeleteClick() {
      this.isSubmitting = true;
      try {
        await axios.delete(`/admin/locations/${this.id}/`);
        this.$router.push(`/map/search`);
      } catch (error) {
        console.error("Error deleting location:", error);
      } finally {
        this.isSubmitting = false;
      }
    },
    async handleCreateClick() {
      this.isSubmitting = true;
      const payload = {
        name: this.name,
        category: this.categoryId,
        tags: this.tagIds,
        description: this.description,
        lat: this.coords[0],
        lng: this.coords[1],
        subareas: this.subareaIds,
        main_building: this.mainBuildingId,
      };
      console.log("Payload for Create:", payload); // Print the payload
      try {
        const response = await axios.post(`/admin/locations/`, payload);
        this.$router.push(`/map/details/${response.data.id}`);
      } catch (error) {
        console.error("Error creating location:", error);
      } finally {
        this.isSubmitting = false;
      }
    },
    async handleUpdateClick() {
      this.isSubmitting = true;
      const payload = {
        name: this.name,
        category: this.categoryId,
        tags: this.tagIds,
        description: this.description,
        lat: this.coords[0],
        lng: this.coords[1],
        subareas: this.subareaIds,
        main_building: this.mainBuildingId,
      };
      console.log("Payload for Update:", payload); // Print the payload
      try {
        await axios.patch(`/admin/locations/${this.id}/`, payload);
        this.$router.push(`/map/details/${this.id}`);
      } catch (error) {
        console.error("Error updating location:", error);
      } finally {
        this.isSubmitting = false;
      }
    },
    clearSubareaSearch() {
      this.subareaSearch = ""; // Clear the search input explicitly
    },
  },
};
</script>

<style scoped>
.form-container {
  background-color: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  width: 100%;
}

label {
  font-weight: bold;
  font-size: 16px;
}

.maroon-chips .v-chip {
  background-color: var(--v-primary-base);
  color: white;
}

.reset-map-btn {
  position: absolute;
  bottom: 10px;
  right: 10px;
  z-index: 1000;
}
</style>