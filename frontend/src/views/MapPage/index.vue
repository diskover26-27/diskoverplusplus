<template>
  <v-container fluid class="map-page-container">
    
        <SideDrawer v-if="mapStore.isSideDrawerVisible" @toggle-side-drawer="toggleSideDrawer" class="side-drawer">
          <router-view></router-view>
        </SideDrawer>
        <BigMapView 
          :height="mapExactHeight" 
          :isOnDetailsPage="isOnDetailsPage" 
          :transportMode="detailsStore.transportMode" 
          class="map"
        >
          <FloatingButton attachedTo="map" @click="toggleSideDrawer" class="btn"/>
        </BigMapView>

  </v-container>
</template>

<script setup>
import { computed, onMounted } from 'vue';
import { useDisplay } from 'vuetify';
import { useRoute } from 'vue-router';
import { useMapStore } from '@/stores/map';
import { useDetailsStore } from '@/stores/details'; // Import detailsStore
import SideDrawer from '@/components/ui/SideDrawer.vue';
import FloatingButton from '@/components/ui/FloatingButton.vue';
import BigMapView from '@/components/map/BigMapView.vue';

const { mdAndUp } = useDisplay();
const route = useRoute();
const mapStore = useMapStore();
const detailsStore = useDetailsStore(); // Initialize detailsStore

const mapExactHeight = computed(() => {
  return mdAndUp.value ? "calc(100vh - 64px)" : "calc(100vh - 48px)";
});

const isOnDetailsPage = computed(() => {
  return route.name === "details";
});

const toggleSideDrawer = () => {
  mapStore.setSideDrawer(!mapStore.isSideDrawerVisible);

};

// Open the side drawer by default on results or details page
onMounted(() => {
  if (route.name === "results" || route.name === "details") {
    mapStore.setSideDrawer(true);
  }
});
</script>

<style scoped>
.map-page-container {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 64px);
  width: 100%;
  overflow: hidden;
  padding: 0;
}
.side-drawer{
  z-index: 1000 !important;
  position: fixed;
  left: 0;
  height: 100%;
  width: 25%;
  box-shadow: 5px 0px 5px 0px rgba(106, 96, 96, 0.53);
}

.map {
  position: relative;
  height: 100%;
  width: 100%;
}

.btn {
  position: absolute;
  top: 50%;
  left: 5%; /* Adjust this value to position the button on the left side */
  transform: translateY(-50%);
}
</style>
