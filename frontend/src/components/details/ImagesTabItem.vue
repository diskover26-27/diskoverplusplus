<template>
  <v-container>
    <v-infinite-scroll direction="horizontal" @load="load">
      <div v-for="(url, i) in fullImageUrls" :key="url">
        <v-hover v-slot="{ isHovering }">
          <v-card
            :class="`elevation-${isHovering ? 12 : 2}`"
            tile
            @click="openCarouselModalAt(i)"
          >
            <v-img
              cover
              width="100"
              height="100"
              :src="url"
              :aspect-ratio="1"
            />
          </v-card>
        </v-hover>
      </div>
      <template #empty> </template>
    </v-infinite-scroll>

    <!-- Carousel Modal for showing a bigger view of the images -->
    <CenterModal
      :is-visible="isCarouselVisible"
      @close="setCarouselModal(false)"
    >
      <v-card
        flat
        theme="light"
        class="pa-4"
        max-width="1200px"
        max-height="90vh"
      >
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

const openCarouselModalAt = (index) => {
  carouselIndex.value = index;
  setCarouselModal(true);
};

function load({ done }) {
  setTimeout(() => {
    done('empty');
  }, 1000);
}
</script>
