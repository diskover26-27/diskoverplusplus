<template>
  <v-app-bar id="nav-bar" absolute color="white">
    <v-btn
      to="/"
      variant="text"
      :ripple="false"
      class="text-h5 ml-5 px-0"
      style="
        --v-hover-opacity: 0;
        --v-activated-opacity: 0;
        --v-focus-opacity: 0;
      "
    >
      <span class="text-maroon font-weight-bold">dIskover</span>
    </v-btn>

    <v-spacer></v-spacer>

    <div v-if="mdAndUp" class="d-flex align-center mr-4">
      <v-btn
        id="nav-bar-button"
        to="/map"
        variant="elevated"
        :ripple="false"
        class="rounded-xl text-white px-5"
        @click="showFullMap"
      >
        Map
      </v-btn>
      <v-btn
        id="nav-bar-button"
        to="/faq"
        variant="elevated"
        :ripple="false"
        class="rounded-xl text-white px-5 ml-4"
      >
        Help
      </v-btn>
      <v-btn
        id="nav-bar-button"
        to="/about"
        variant="elevated"
        :ripple="false"
        class="rounded-xl text-white px-5 ml-4"
      >
        About
      </v-btn>
      <AdminDropdown class="ml-4" />
    </div>

    <div v-else class="mr-2 d-flex align-center">
      <v-btn
        id="nav-bar-button"
        to="/map"
        variant="elevated"
        :ripple="false"
        class="rounded-xl text-white px-3"
        @click="showFullMap"
      >
        Map
      </v-btn>
      <v-btn
        id="nav-bar-button"
        to="/faq"
        variant="elevated"
        :ripple="false"
        class="rounded-xl text-white px-3 ml-2"
      >
        Help
      </v-btn>
      <v-btn
        id="nav-bar-button"
        to="/about"
        variant="elevated"
        :ripple="false"
        class="rounded-xl text-white px-3 ml-2"
      >
        About
      </v-btn>

      <v-menu
        attach="#nav-bar"
        location="bottom end"
        min-width="250px"
        z-index="1003"
        :close-on-content-click="false"
      >
        <template #activator="{ props }">
          <v-btn
            id="nav-dropdown-activator"
            v-bind="props"
            icon
            color="black"
            variant="text"
            class="ml-1"
          >
            <v-icon>mdi-menu</v-icon>
          </v-btn>
        </template>

        <v-list id="nav-dropdown" bg-color="black">
          <AdminDropdown />
        </v-list>
      </v-menu>
    </div>
  </v-app-bar>
</template>

<script setup>
import { useDisplay } from 'vuetify';
import { useMapStore } from '@/stores/map'; // Import the map store
import AdminDropdown from '@/components/ui/AdminDropdown.vue';

const { mdAndUp } = useDisplay();
const mapStore = useMapStore(); // Use the map store

const showFullMap = () => {
  mapStore.setSideDrawer(false); // Use mapStore to set side drawer
};
</script>

<style scoped>
@import '@/assets/stylesheets/style.css';

#nav-dropdown {
  background-color: maroon !important;
  overflow: visible !important;
}

.list-active {
  color: white !important;
  background-color: maroon !important;
}

#nav-bar {
  z-index: 1001 !important;
  padding-left: 0px !important;
  background-color: var(--nav-bg, transparent);
  position: absolute;
  top: 0;
}

#nav-bar-button {
  background-color: maroon;
}
</style>
