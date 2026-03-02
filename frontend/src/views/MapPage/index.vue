<template>
  <v-container fluid class="map-page-container">
    
        <div v-if="mapStore.isSideDrawerVisible">
          <SideDrawer v-if="mdAndUp" @toggle-side-drawer="toggleSideDrawer" class="side-drawer">
            <router-view></router-view>
          </SideDrawer>

          <SideDrawer v-else @toggle-side-drawer="toggleSideDrawer" class="side-drawer-mobile">
            <router-view></router-view>
          </SideDrawer>
        </div>

        <BigMapView 
          :height="mapExactHeight" 
          :isOnDetailsPage="isOnDetailsPage" 
          :transportMode="detailsStore.transportMode" 
          class="map"
        >
          <FloatingButton  v-if="mdAndUp" attachedTo="map" @click="toggleSideDrawer" color="white" class="search-btn-mdAndUp"/>
          <FloatingButton  v-else attachedTo="map" @click="toggleSideDrawer" color="white" class="search-btn"/>
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
  height: 100vh;
  width: 100%;
  overflow: hidden;
  padding: 0;
}
.side-drawer, .side-drawer-mobile{
  z-index: 1002 !important;
  position: absolute;
  left: 0;
  height: 100%;
  width: 25%;

}
.side-drawer-mobile{
  height: 50%;
  width: 100%;
  bottom: 0;
  left: 50%;
  transform: translate(-50%, 0%);
}

.map {
  position: relative;
  height: 100%;
  width: 100%;
}

.search-btn-mdAndUp{
  position: absolute;
  top: 50%;
  left: 5%; /* Adjust this value to position the button on the left side */
  transform: translateY(-50%);
}
.search-btn{
  position: absolute;
  z-index: 1002;
  top: 95%;
}
</style>
