<template>
  <!-- Homepage of diskover shown at default https://diskover.up.edu.ph -->
  <div class="homepage-container">
    <!-- Content overlay -->
    <div class="content-overlay" align="center">
      <!-- Title Section -->
      <v-container class="pa-0 mt-10">
        <v-row  justify="center" class="column">
          <v-col cols="12" class="text-center">
            <p class="text-outline-black font-weight-bold text-h4 text-green">Diskover your way around</p>
            <p class="text-outline-black diskover-title font-weight-bold text-h2 text-maroon">UP Diliman</p>
            <SearchBar class="search-bar" />
          </v-col>
        </v-row>

      </v-container>
    <v-container :class="[mdAndUp ? 'py-2' : 'py-16', 'flex-grow-1']" fluid></v-container>
      <v-container fluid class="crescent">
        <div class="curve-buffer"></div>
        <!-- Quick Home page links and widgets -->
        <v-container fluid class = crescent-elements-container>
          <v-container fluid class="carousel-container">
            <div class="carousel-container">
                  <v-slide-group show-arrows>
                    <template v-slot:prev>
                      <v-btn color="maroon" icon>
                        <v-icon color="white">mdi-chevron-left</v-icon>
                      </v-btn>
                    </template>
                    <v-slide-group-item
                      v-for="(item, i) in categories"
                      :key="i"
                    >
                      <CategoryCard :category="item" />
                    </v-slide-group-item>

                    <template v-slot:next>
                      <v-btn color="maroon" icon>
                        <v-icon color="white">mdi-chevron-right</v-icon>
                      </v-btn>
                    </template>
                  </v-slide-group>
            </div>
          </v-container>
            <p class="footer text-grey">
              Diskover++ is a project from students of the Department of Computer Science in UP Diliman. Please help us by reporting broken links or providing comments and suggestions through this form. We need your feedback to help us improve the site.
            </p>
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
import SearchBar from '@/components/search/SearchBar.vue';
import InfoCard from '@/components/ui/InfoCard.vue';
import CategoryCard from '@/components/home/CategoryCard.vue';

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
  width: 100vw;
  height: 100vh;
  overflow: hidden; /* Allow content to overflow */
}

.caption {
  margin-bottom: 1%;
}

/* Background image */
.bg-image {
  top: 0;
  left: 0;
}

/* Content overlay */
.content-overlay {
  z-index: 2;
  width: 100%;
  height: 100vh;
  display: flex;
  flex-direction: column;
  box-sizing: border-box;
  padding-top: 10vh;
  padding-bottom: 0; 
}

.search-bar {
  padding: 0 10%;
}

.crescent {
  display: flex;
  flex-direction: column;
  align-items: center;
  background: white;
  width: 100vw;
  height: 600px;
  overflow: hidden;
  padding: 0;

  --r: 110vw;
  --y: -95vw;
  --mask-height: calc(var(--r) + var(--y));
  --content-height: calc(82% - var(--mask-height));

  -webkit-mask-image:
    radial-gradient(
      circle var(--r) at 49.5% var(--y),
      transparent 100%,
      black 100%
    );
  mask-image:
    radial-gradient(
      circle var(--r) at 50% var(--y),
      transparent 100%,
      black 100%
    );
}

.curve-buffer {
  height: var(--mask-height);
  flex-shrink: 0;
}


.crescent-elements-container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  height: var(--content-height);
  align-items: center;
  padding: 15px;
  width: 100%;
}

.carousel-container {
  padding: 0 5%;
  width: 80%;
  display: flex;
  justify-content: center;
}

.v-slide-group {
  justify-content: center;
  width: 100%;
}

.footer {
  margin: 0 25%;
  font-size: 0.55rem;
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

.text-green {
  color: #014421 !important;
}
</style>
