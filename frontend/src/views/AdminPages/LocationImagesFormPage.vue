<template>
  <v-container class="fill-height d-flex align-center justify-center">
    <v-sheet class="pa-8 rounded-xl" elevation="2" width="100%" max-width="900">
      <div class="text-h5 mb-6">
        Update images binded to
        <span class="font-weight-bold">{{ locationName }}</span>
      </div>

      <v-divider class="mb-6"></v-divider>

      <div class="mb-6">
        <div class="text-h6 mb-4 font-weight-bold">
          Images currently binded to location
        </div>
        <v-row>
          <v-col
            v-for="image in bindedImages"
            :key="image.id"
            cols="12"
            sm="6"
            md="4"
            lg="3"
          >
            <v-card
              class="cursor-pointer"
              height="150"
              @click="toggleBindedImageSelection(image.id)"
            >
              <v-img :src="getFullImageUrl(image.img_url)" height="100%" cover>
                <div
                  v-if="selectedBindedImages.includes(image.id)"
                  class="d-flex fill-height align-center justify-center bg-black-transparent"
                >
                  <v-icon
                    color="white"
                    size="48"
                    icon="mdi-check-circle"
                  ></v-icon>
                </div>
              </v-img>
            </v-card>
            <div
              class="text-center mt-2 text-caption font-weight-light text-truncate"
            >
              {{ image.img_url }}
            </div>
          </v-col>
        </v-row>
      </div>

      <v-divider class="mb-6"></v-divider>

      <div class="mb-6">
        <div class="text-h6 mb-4 font-weight-bold">
          Add images binded to other locations
        </div>
        <v-autocomplete
          v-model="locationSearchId"
          v-model:search="locationSearchQuery"
          :items="locationSearchItemsWithUnbinded"
          item-title="text"
          item-value="value"
          hide-selected
          auto-select-first
          clearable
          label="Location Search"
          placeholder="Search images from a location"
          variant="outlined"
          density="comfortable"
          :menu-props="{ zIndex: '1001' }"
          @update:model-value="apiGetLocationSearchImages"
        />

        <v-row v-if="locationSearchImages.length > 0" class="mt-2">
          <v-col
            v-for="image in locationSearchImages"
            :key="image.id"
            cols="12"
            sm="6"
            md="4"
            lg="3"
          >
            <v-card
              class="cursor-pointer"
              height="150"
              @click="toggleSearchImageSelection(image.id)"
            >
              <v-img :src="getFullImageUrl(image.img_url)" height="100%" cover>
                <div
                  v-if="selectedSearchImages.includes(image.id)"
                  class="d-flex fill-height align-center justify-center bg-black-transparent"
                >
                  <v-icon
                    color="white"
                    size="48"
                    icon="mdi-check-circle"
                  ></v-icon>
                </div>
              </v-img>
            </v-card>
            <div
              class="text-center mt-2 text-caption font-weight-light text-truncate"
            >
              {{ image.img_url }}
            </div>
          </v-col>
        </v-row>
      </div>

      <v-divider class="mb-6"></v-divider>

      <div class="mt-4">
        <div class="text-h6 mb-4 font-weight-bold">Upload new images</div>

        <v-file-input
          v-model="uploadedImageFiles"
          multiple
          accept="image/*"
          label="Click here to select images"
          variant="outlined"
          prepend-icon="mdi-image-multiple"
          show-size
          counter
          color="primary"
        ></v-file-input>
      </div>

      <div class="mt-6 d-flex justify-end">
        <v-btn
          color="black"
          class="mr-3"
          :disabled="isSubmitting"
          @click="handleUpdateClick()"
        >
          Update location images
        </v-btn>
        <v-btn variant="text" @click="handleCancelClick()">Cancel</v-btn>
      </div>
    </v-sheet>
  </v-container>
</template>

<script>
import AdminVerifierMixin from '@/mixins/AdminVerifierMixin';
import axios from 'axios';

export default {
  mixins: [AdminVerifierMixin],
  data() {
    return {
      locationName: '',
      bindedImages: [],
      selectedBindedImages: [],
      locationSearchId: -1,
      locationSearchItems: [],
      locationSearchQuery: '',
      locationSearchImages: [],
      selectedSearchImages: [],
      uploadedImageFiles: [], // v-file-input binds directly to this!
      isSubmitting: false,
    };
  },
  computed: {
    locationId() {
      return this.$route.params.id;
    },
    locationSearchItemsWithUnbinded() {
      return [
        ...this.locationSearchItems,
        { text: 'Unbinded', value: 0 },
        { text: 'None', value: -1 },
      ];
    },
    updatedImageIds() {
      return [...this.selectedBindedImages, ...this.selectedSearchImages];
    },
  },
  watch: {
    $route() {
      this.handleRouteChange();
    },
  },
  mounted() {
    this.handleRouteChange();
  },
  methods: {
    handleRouteChange() {
      this.apiGetLocationToUpdateImages(this.locationId);
      this.apiGetLocationSearchItems('');
    },
    apiGetLocationToUpdateImages(id) {
      axios
        .get(`/admin/locations/images/${id}`)
        .then((response) => {
          console.log(
            'Successfully retrieved images data from API: ',
            response.data
          );
          this.locationName = response.data.name;
          this.bindedImages = response.data.images;
          this.selectedBindedImages = response.data.images.map(
            (image) => image.id
          );
        })
        .catch((error) => {
          console.log(
            'Error retrieving location update/delete data from API: ',
            error
          );
        });
    },
    apiGetLocationSearchItems(searchValue) {
      axios
        .get(`/admin/locations/`, {
          params: {
            search: searchValue,
          },
          paramsSerializer: (params) => {
            return this.$qs.stringify(params, { indices: false });
          },
        })
        .then((response) => {
          this.locationSearchItems = response.data.map((loc) => ({
            text: loc.name,
            value: loc.id,
          }));
        })
        .catch((error) => {
          alert('Error receiving queried results from API: ');
          console.log(error);
        });
    },
    apiGetLocationSearchImages() {
      this.locationSearchQuery = null;
      this.selectedSearchImages = [];
      if (!this.locationSearchId && this.locationSearchId != 0) {
        this.locationSearchId = -1;
      }
      axios
        .get(`/admin/images/`, {
          params: { location_id: this.locationSearchId },
          paramsSerializer: (params) => {
            return this.$qs.stringify(params, { indices: false });
          },
        })
        .then((response) => {
          console.log(
            'Successfully retrieved location search images data from API: ',
            response.data
          );
          this.locationSearchImages = response.data;
        })
        .catch((error) => {
          alert('Error receiving queried results from API: ');
          console.log(error);
        });
    },
    getFullImageUrl(imgUrl) {
      return `${this.$backendStaticPath}/images/locations/${imgUrl}`;
    },
    // New methods for toggling array selection
    toggleBindedImageSelection(id) {
      const index = this.selectedBindedImages.indexOf(id);
      if (index > -1) {
        this.selectedBindedImages.splice(index, 1);
      } else {
        this.selectedBindedImages.push(id);
      }
    },
    toggleSearchImageSelection(id) {
      const index = this.selectedSearchImages.indexOf(id);
      if (index > -1) {
        this.selectedSearchImages.splice(index, 1);
      } else {
        this.selectedSearchImages.push(id);
      }
    },
    handleUpdateClick() {
      this.isSubmitting = true;
      let formData = new FormData();
      for (let imageId of this.updatedImageIds) {
        formData.append('image_ids', imageId);
      }
      for (let imageFile of this.uploadedImageFiles) {
        formData.append('images', imageFile);
      }
      console.log(formData);
      axios
        .patch(`/admin/locations/images/${this.locationId}/`, formData, {
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        })
        .then((response) => {
          console.log('Successfully patched updated location to API', response);
          this.$router.push({
            name: 'details',
            params: { id: this.locationId },
          });
        })
        .catch((error) => {
          alert('Error patching updated location to API', error);
        })
        .finally(() => {
          this.isSubmitting = false;
        });
    },
    handleCancelClick() {
      console.log('Cancel');
      this.$router.go(-1);
    },
  },
};
</script>

<style scoped>
.bg-black-transparent {
  background-color: rgba(0, 0, 0, 0.4);
}
</style>
