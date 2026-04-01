<template>
  <!-- Home page category card with huge icon picture and link to filtered search -->
  <v-hover v-slot:default="{ isHovering }">
    <v-btn
      color="maroon"
      class="ma-2 text-white"
      rounded
      :to="{ path: '/map/search', query: { category: category.name } }"
    >
      {{ category.name }}
    </v-btn>
  </v-hover>
</template>

<script>
export default {
  props: {
    category: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      imageUrl: this.defaultUrl, // Start with the default URL
    };
  },
  computed: {
    defaultUrl() {
      return `${this.$backendStaticPath}/images/categories/defaultCategoryImage.jpg`;
    },
    expectedImgUrl() {
      let imgName = this.category.name || "defaultCategoryImage";
      return `${this.$backendStaticPath}/images/categories/${imgName}.jpg`;
    },
  },
  watch: {
    'category.name': {
      immediate: true,
      handler() {
        this.loadImage();
      },
    },
  },
  methods: {
    loadImage() {
      const img = new Image();
      img.src = this.expectedImgUrl;

      img.onload = () => {
        this.imageUrl = this.expectedImgUrl; // Update to the actual image URL if it loads successfully
      };

      img.onerror = () => {
        this.imageUrl = this.defaultUrl; // Fallback to the default URL if the image fails to load
      };
    },
  },
  mounted() {
    this.loadImage(); // Load the image when the component is mounted
  },
};
</script>

<style scoped>
@import "@/assets/stylesheets/style.css";

.text-white {
  color: white !important;
}

.text-black {
  color: black !important;
}

.category-card {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;
}
</style>
