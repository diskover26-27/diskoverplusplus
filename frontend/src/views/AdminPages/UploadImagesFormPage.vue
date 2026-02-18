<template>
  <v-container class="fill-height d-flex align-center justify-center">
    
    <v-sheet
      class="pa-8 rounded-xl"
      elevation="2"
      width="100%"
      max-width="900"
    >
      
      <div class="mb-6">
        <div class="text-h5 mb-4 font-weight-bold">Current unbinded images</div>
        <v-row>
          <v-col
            v-for="image in unbindedImages"
            :key="image.id"
            cols="12"
            sm="6"
            md="4"
            lg="3"
            class="text-center"
          >
            <v-img :src="getFullImageUrl(image.img_url)" height="150px" class="mb-2 rounded" />
            <div class="text-caption font-weight-light text-truncate" style="max-width: 100%;">
              {{ image.img_url }}
            </div>
          </v-col>
        </v-row>
      </div>

      <v-divider class="mb-6"></v-divider>

      <div class="mt-4">
        <div class="text-h6 mb-4">Upload unbinded images</div>
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
          @click="handleUploadClick()" 
          :disabled="isSubmitting || uploadedImageFiles.length === 0"
        >
          Upload unbinded images
        </v-btn>
        <v-btn variant="text" @click="handleCancelClick()">Cancel</v-btn>
      </div>
      
    </v-sheet>
  </v-container>
</template>

<script>
import AdminVerifierMixin from "@/mixins/AdminVerifierMixin";

export default {
  mixins: [AdminVerifierMixin],
  mounted() {
    this.apiGetUnbindedImages();
  },
  data() {
    return {
      uploadedImageFiles: [], // v-model populates this automatically now!
      unbindedImages: [],
      isSubmitting: false,
    };
  },
  methods: {
    apiGetUnbindedImages() {
      this.$http
        .get(`/admin/images/`, {
          params: {
            location_id: 0,
          },
        })
        .then((response) => {
          console.log("successful retrieved images data from API: ", response.data);
          this.unbindedImages = response.data;
        })
        .catch((error) => {
          console.log("error retrieving location update/delete data from API: ", error);
        });
    },
    getFullImageUrl(imgUrl) {
      return `${this.$backendStaticPath}/images/locations/${imgUrl}`;
    },
    // handleImageUploads() is completely deleted! 
    
    handleUploadClick() {
      this.isSubmitting = true;
      let formData = new FormData();
      
      // This loop still works perfectly because uploadedImageFiles is an array of Files
      for (let imageFile of this.uploadedImageFiles) {
        formData.append("images", imageFile);
      }
      
      console.log(formData);
      this.$http
        .post(`/admin/images/`, formData, {
          headers: {
            "Content-Type": "multipart/form-data",
          },
        })
        .then((response) => {
          console.log("successfully uploaded unbinded images to API", response);
          this.$router.go();
        })
        .catch(function (error) {
          alert("error uploading unbinded images to API", error);
        })
        .finally(() => {
          this.isSubmitting = false;
          this.uploadedImageFiles = []; // Clear the input after finish
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
  background-color: white; 
  padding: 30px; 
  border-radius: 16px; 
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05); 
  width: 100%; 
  max-width: 900px; 
}
</style>