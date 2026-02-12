<template>
  <v-container
    class="grey lighten-4 fill-height d-flex align-center justify-center"
  >
    <v-row justify="center">
      <v-col cols="12" md="10" lg="8">
        <div class="form-container">
          <div class="title">Search an image to delete via its location</div>
          <div class="maroon-chips">
            <v-autocomplete
              v-model="locationSearchId"
              :items="locationSearchItemsWithUnbinded"
              v-model:search="locationSearchQuery"
              item-title="text"
              item-value="value"
              @update:model-value="apiGetLocationSearchImages"
              label="Location Search"
              placeholder="Search images from a location"
              auto-select-first
              clearable
              hide-selected
            />
          </div>
          <v-row class="justify-end">
            <v-btn
              color="black"
              class="mr-2"
              @click="handleDeleteClick()"
              :disabled="isSubmitting || !selectedDeleteImageId"
            >
              Delete Image
            </v-btn>
            <v-btn @click="handleCancelClick()">Cancel</v-btn>
          </v-row>
          <v-row class="mt-4 justify-center">
            <v-col
              v-for="image in locationSearchImages"
              :key="image.id"
              cols="12"
              sm="6"
              md="4"
            >
              <v-card
                @click="selectedDeleteImageId = image.id"
                class="cursor-pointer"
                height="250"
              >
                <v-img
                  :src="getFullImageUrl(image.img_url)"
                  height="100%"
                  cover
                >
                  <div
                    v-if="selectedDeleteImageId === image.id"
                    class="d-flex fill-height align-center justify-center bg-black-transparent"
                  >
                    <v-icon
                      color="white"
                      size="64"
                      icon="mdi-check-circle"
                    ></v-icon>
                  </div>
                </v-img>
              </v-card>

              <div class="text-center mt-2 text-body-1 text-truncate">
                {{ image.img_url }}
              </div>
            </v-col>
          </v-row>
        </div>
      </v-col>
    </v-row>
    <CenterModal
      :isVisible="isDeleteConfirmVisible"
      @close="isDeleteConfirmVisible = false"
    >
      <v-row class="red lighten-4 text-xs-center">
        <v-col cols="12" class="headline py-3">
          Are you sure you want to delete {{ selectedDeleteImageName }}?
        </v-col>
        <v-col cols="12" class="title pt-2">
          <v-img
            :src="getFullImageUrl(selectedDeleteImageName)"
            height="200px"
            contain
          />
        </v-col>
        <v-row justify="center">
          <v-btn color="blue" dark @click="handleDeleteConfirm">Yes</v-btn>
          <v-btn color="red" dark @click="isDeleteConfirmVisible = false"
            >No</v-btn
          >
        </v-row>
      </v-row>
    </CenterModal>
  </v-container>
</template>

<script>
import AdminVerifierMixin from "@/mixins/AdminVerifierMixin";
import CenterModal from "@/components/ui/CenterModal.vue"; // Adjust the path as needed

export default {
  mixins: [AdminVerifierMixin],
  components: {
    CenterModal, // Register CenterModal
  },
  mounted() {
    this.handleRouteChange();
  },
  data() {
    return {
      locationSearchId: -1,
      locationSearchQuery: "",
      locationSearchItems: [],
      locationSearchImages: [],
      selectedDeleteImageId: "",
      isDeleteConfirmVisible: false,
      isSubmitting: false,
    };
  },
  computed: {
    locationSearchItemsWithUnbinded() {
      const sortedApiItems = this.locationSearchItems.slice().sort((a, b) => {
        const textA = (a.text || "").toLowerCase();
        const textB = (b.text || "").toLowerCase();

        if (textA < textB) return -1;
        if (textA > textB) return 1;
        return 0;
      });
      return [
        { text: "Unbinded", value: 0 },
        ...sortedApiItems,
        { text: "None", value: -1 },
      ];
    },
    selectedDeleteImageName() {
      let image = this.locationSearchImages.find(
        (item) => item.id == this.selectedDeleteImageId,
      );
      return image ? image.img_url : null;
    },
  },
  methods: {
    handleRouteChange() {
      this.apiGetLocationSearchItems("");
    },
    apiGetLocationSearchItems(searchValue) {
      this.$http
        .get(`/admin/locations/`, {
          params: {
            search: searchValue,
          },
          paramsSerializer: (params) => {
            return this.$qs.stringify(params, { indices: false });
          },
        })
        .then((response) => {
          this.locationSearchItems = response.data.map((loc) => {
            return {
              text: loc.name,
              value: loc.id,
            };
          });
        })
        .catch((error) => {
          alert("error receiving queried results from API: ");
          console.log(error);
        });
    },
    apiGetLocationSearchImages() {
      this.locationSearchQuery = null;
      this.selectedDeleteImageId = null;
      if (!this.locationSearchId && this.locationSearchId != 0) {
        this.locationSearchId = -1;
      }
      this.$http
        .get(`/admin/images/`, {
          params: {
            location_id: this.locationSearchId,
          },
          paramsSerializer: (params) => {
            return this.$qs.stringify(params, { indices: false });
          },
        })
        .then((response) => {
          console.log(
            "successful retrieved location search images data from API: ",
            response.data,
          );
          this.locationSearchImages = response.data;
        })
        // alert an error if unsuccessful GET
        .catch((error) => {
          alert("error receiving queried results from API: ");
          console.log(error);
        });
    },
    getFullImageUrl(imgUrl) {
      return `${this.$backendStaticPath}/images/locations/${imgUrl}`;
    },
    handleDeleteClick() {
      this.isDeleteConfirmVisible = true;
    },
    handleDeleteConfirm() {
      this.isSubmitting = true;
      this.$http
        .delete(`/admin/images/${this.selectedDeleteImageId}/`)
        .then((response) => {
          console.log("successfully deleted location from API", response);
          this.$router.go();
        })
        .catch(function (error) {
          alert("error deleting location to API", error);
        })
        .finally(() => {
          this.isSubmitting = false;
        });
    },
    handleCancelClick() {
      console.log("cancel");
      this.$router.go(-1);
    },
  },
};
</script>

<style scoped>
.form-container {
  background-color: white; /* White background for the form */
  padding: 20px; /* Add padding inside the form */
  border-radius: 8px; /* Rounded corners */
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* Optional shadow for better visibility */
  width: 100%; /* Ensure it takes the full width of the column */
}

.bg-black-transparent {
  background-color: rgba(0, 0, 0, 0.4);
}
</style>
