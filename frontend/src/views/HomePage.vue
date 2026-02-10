<template>
  <!-- Homepage of diskover shown at default https://diskover.up.edu.ph -->
  <div class="homepage-container">
    <!-- Content overlay -->
    <div class="content-overlay" align="center">
      <!-- Title Section -->
      <v-container class="pa-0 mt-10">
        <v-row  justify="center" class="column">
          <v-col cols="12" class="text-center">
            <p class="caption text-white">
              Ready to diskover something new today?
            </p>
              <SearchBar class="search-bar" />
          </v-col>
        </v-row>

      </v-container>

    <v-container fluid class="base-container">
      <v-img :src="crescent"></v-img>
    </v-container>

    <!-- Quick Home page links and widgets -->
    <v-container fluid class="carousel-container">
        <v-container fluid>
            <v-slide-group show-arrows>
              <v-slide-group-item
                v-for="(item, i) in categories"
                :key="i"
              >
                <CategoryCard :category="item" />
              </v-slide-group-item>
            </v-slide-group>
        </v-container>
    </v-container>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue';
import { useDisplay } from 'vuetify';
import { useMainStore } from '@/stores/index.js';
import bgImage from '@/assets/backgrounds/bgimg.png';
import crescent from '@/assets/backgrounds/crescent.png';
import miniMapImage from '@/assets/images/mini_map.png';
import SearchBar from '@/components/search/SearchBar.vue'; // Import the SearchBar component
import InfoCard from '@/components/ui/InfoCard.vue'; // Import the InfoCard component
import CategoryCard from '@/components/home/CategoryCard.vue'; // Import the CategoryCard component

const { mdAndUp } = useDisplay();
const mainStore = useMainStore();

const categories = computed(() => {
  return mainStore.categories;
});

const homeLayout = computed(() => {
  return {
    column: !mdAndUp.value,
    row: mdAndUp.value,
  };
});
</script>

<style scoped>
@import '@/assets/stylesheets/style.css';

/* Full-page container */
.homepage-container {
  position: relative;
  width: 100%;
  overflow: hidden; /* Allow content to overflow */
}

.caption {
  margin-bottom: 1%;
}

/* Background image */
.bg-image {
  position: fixed; /* Fix the background image to the viewport */
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 1;
}

/* Content overlay */
.content-overlay {
  position: relative;
  z-index: 2;
  width: 100%;
  height: 100vh;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  padding-top: 175px;
  padding-bottom: 175px;
}

.search-bar {
  padding: 0 30%;
}

.base-container {
  padding: 0;
  margin-top: auto;
}

.carousel-container {
  position: absolute;
  margin-top: 18%;
  padding: 0 20%;
  z-index: 3;
}

/* Title styling */
.diskover-title {
  text-shadow: 0px 1px 3px #000000;
}

.no-underline {
  text-decoration: none;
}

.text-center {
  text-align: center;
}

.fill-width {
  width: 100%;
}

.full-width {
  width: 100%;
}
</style>
