<template>
  <!-- Basic Navbar with important links -->
  <v-toolbar app id="nav-bar" height="128px">
    <!-- Left Side -->
    <v-toolbar-items>
      <!-- Homepage link -->
      <v-btn to="/" class="text-h4" variant="tonal" density="compact" rounded="xl" flat color="transparent">
        <span class="text-black">dIskover</span>
      </v-btn>
      <!-- Button for displaying GPS configuration modals -->
    </v-toolbar-items>
    <v-spacer></v-spacer>

    <!-- Right Side -->
    <!-- Desktop Version -->
    <v-toolbar-items v-if="mdAndUp">
      <!-- Map link -->
      <v-btn to="/map" density="compact" id="nav-bar-button" class="rounded-xl elevated-24 text-white px-5 py-2 my-7" @click="showFullMap">
        Map
      </v-btn>
      <!-- FAQs link -->
      <v-btn to="/faq" density="compact" id="nav-bar-button" class="rounded-xl elevated-24 text-white px-5 my-7 ml-4">
        Help
      </v-btn>
      <!-- TODO: About Page About link -->
      <v-btn to="/about" density="compact" id="nav-bar-button" class="rounded-xl elevated-24 text-white px-5 my-7 ml-4"> 
        About
      </v-btn>
      <AdminDropdown/>
    </v-toolbar-items>

    <!-- Mobile Version -->
    <v-toolbar-items v-else>
      <v-menu
        attach="#nav-bar"
        location="bottom left"
        min-width="300px"
        z-index="1003"
        :close-on-content-click="false"
      >
        <template v-slot:activator="{ props }">
          <v-btn flat color="black" icon dark v-bind="props" id="nav-dropdown-activator">
            <v-icon>mdi-menu</v-icon>
          </v-btn>
        </template>
        <v-list id="nav-dropdown">
          <v-list-item to="/map" active-class="primary-text list-active">
              <v-list-item-title class="text-white" @click="showFullMap">Map</v-list-item-title>
          </v-list-item>
          <!-- FAQs link -->
          <v-list-item to="/faq" active-class="primary-text list-active">
              <v-list-item-title class="text-white">Help</v-list-item-title>
          </v-list-item>
          <AdminDropdown/>
        </v-list>
      </v-menu>
    </v-toolbar-items>
  </v-toolbar>
</template>

<script setup>
import { computed, inject } from 'vue';
import { useDisplay } from 'vuetify';
import { useAuthStore } from '@/stores/auth';
import { useMapStore } from '@/stores/map'; // Import the map store
import AdminDropdown from '@/components/ui/AdminDropdown.vue';

const { mdAndUp } = useDisplay();
const authStore = useAuthStore();
const mapStore = useMapStore(); // Use the map store
const eventBus = inject('eventBus'); // Inject the eventBus

const isLoggedIn = computed(() => authStore.isLoggedIn);
const loggedInUser = computed(() => authStore.user);

const showFullMap = () => {
  mapStore.setSideDrawer(false); // Use mapStore to set side drawer
};

const openGpsModal = () => {
  console.log("Emitting open-gps-bottom-modal event"); // Add a console log to verify the event emission
  eventBus.emit("open-gps-bottom-modal"); 
};
</script>

<style scoped>
@import "@/assets/stylesheets/style.css";

* {
  font-family: roboto, sans-serif;
}

#nav-dropdown {
  background-color: black !important;
  overflow: visible !important;
}

.list-active {
  color: white !important;
  background-color: black !important;
}

#nav-bar {
  z-index: 1001 !important;
  padding-left: 0px !important;
  background-color: var(--nav-bg, transparent);
}

#nav-bar-button {
  background-color: black;
}
</style>
