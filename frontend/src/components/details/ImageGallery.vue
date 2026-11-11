<template>
  <v-container>
    <v-infinite-scroll direction="horizontal" @load="load">
      <!-- Only display if nearby locations are found -->
      <v-list v-if="nearbyLocations && nearbyLocations.length">
        <!-- Add hyperlinks to nearby locations that navigate to their details page -->
        <v-list-item
          v-for="near in nearbyLocations"
          :key="near.id"
          :to="`/map/details/${near.id}`"
          link
        >
          <v-list-item-title class="text-small">{{
            near.name
          }}</v-list-item-title>
        </v-list-item>
      </v-list>
      <!-- Display indicator if no nearby locations are found -->
      <v-container v-else>
        <span class="body-2">No nearby locations found</span>
      </v-container>
    </v-infinite-scroll>

    <!-- Carousel Modal for showing a bigger view of the images -->
    <CenterModal
      :is-visible="isCarouselVisible"
      @close="setCarouselModal(false)"
    >
      <v-card class="pa-4" max-width="1200px" max-height="90vh">
        <v-carousel v-model="carouselIndex" :cycle="false" height="80vh">
          <v-carousel-item v-for="(url, i) in fullImageUrls" :key="i">
            <v-img :src="url" height="100%" contain />
          </v-carousel-item>
        </v-carousel>
      </v-card>
    </CenterModal>
  </v-container>
</template>

<script setup>
import { ref, computed } from 'vue';
import CenterModal from '@/components/ui/CenterModal.vue';

// Props
const props = defineProps({
  imageUrls: {
    type: Array,
    default: () => [],
  },
});

// Modal visibility and current index in carousel
const isCarouselVisible = ref(false);
const carouselIndex = ref(0);

// Resolve full URLs for image paths
const fullImageUrls = computed(() =>
  props.imageUrls.map((url) => {
    const backendStaticPath = import.meta.env.VITE_APP_STATIC_URL;
    return `${backendStaticPath}/images/locations/${url}`;
  })
);

// Modal open/close logic
const setCarouselModal = (value) => {
  isCarouselVisible.value = value;
};

function load({ done }) {
  setTimeout(() => {
    done('ok');
  }, 1000);
}
</script>
