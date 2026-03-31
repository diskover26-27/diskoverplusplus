<template>
  <template v-if="mdAndUp">
    
    <v-menu
      v-if="isLoggedIn"
      v-model="menuVisible"
      attach="#nav-bar"
      location="bottom end"
      offset="15"
      z-index="1005"
    >
      <template v-slot:activator="{ props }">
        <v-btn id="nav-bar-button" :ripple="false" class="text-white rounded-xl px-5 py-2 my-7 ml-4" v-bind="props">
          <span>Logged in as {{ loggedInUser.name }}</span>
        </v-btn>
      </template>
      <v-list id="nav-admin-dropdown" bg-color="maroon">
        <v-list-item :to="{name: 'location_crud_form', params: {mode: 'create'}}" active-class="list-active">
          <v-list-item-title class="text-white">Create new location</v-list-item-title>
        </v-list-item>
        <v-list-item :to="{name: 'upload_images_form'}" active-class="list-active">
          <v-list-item-title class="text-white">Upload new images</v-list-item-title>
        </v-list-item>
        <v-list-item :to="{name: 'delete_images_form'}" active-class="list-active">
          <v-list-item-title class="text-white">Delete images</v-list-item-title>
        </v-list-item>
        <v-list-item :to="{name: 'categorytable'}" active-class="list-active">
          <v-list-item-title class="text-white">Browse categories</v-list-item-title>
        </v-list-item>
        <v-list-item :to="{name: 'tagtable'}" active-class="list-active">
          <v-list-item-title class="text-white">Browse tags</v-list-item-title>
        </v-list-item>
        <v-list-item @click="logout" active-class="list-active">
          <v-list-item-title class="text-white">Log out</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-menu>

    <v-btn
      v-else
      :to="{name: 'login'}"
      :ripple="false"
      id="nav-bar-button"
      class="rounded-xl text-white px-5 ml-4"
    >
      Log in
    </v-btn>

  </template>


  <template v-else>
    
    <template v-if="isLoggedIn">
      <v-list-item class="bg-grey-darken-4">
        <v-list-item-title class="text-grey-lighten-1 font-weight-light">
          Logged in as {{ loggedInUser.name }}
        </v-list-item-title>
      </v-list-item>
      
      <v-divider color="grey-darken-2"></v-divider>

      <v-list-item :to="{name: 'location_crud_form', params: {mode: 'create'}}" active-class="list-active">
        <v-list-item-title class="text-white">Create new location</v-list-item-title>
      </v-list-item>
      <v-list-item :to="{name: 'upload_images_form'}" active-class="list-active">
        <v-list-item-title class="text-white">Upload new images</v-list-item-title>
      </v-list-item>
      <v-list-item :to="{name: 'delete_images_form'}" active-class="list-active">
        <v-list-item-title class="text-white">Delete images</v-list-item-title>
      </v-list-item>
      <v-list-item :to="{name: 'categorytable'}" active-class="list-active">
        <v-list-item-title class="text-white">Browse categories</v-list-item-title>
      </v-list-item>
      <v-list-item :to="{name: 'tagtable'}" active-class="list-active">
        <v-list-item-title class="text-white">Browse tags</v-list-item-title>
      </v-list-item>
      <v-list-item @click="logout" active-class="list-active">
        <v-list-item-title class="text-white">Log out</v-list-item-title>
      </v-list-item>
    </template>

    <v-list-item v-else :to="{name: 'login'}" active-class="list-active">
      <v-list-item-title class="text-white">Log in</v-list-item-title>
    </v-list-item>

  </template>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useDisplay } from 'vuetify';
import { useAuthStore } from '@/stores/auth';

const { mdAndUp } = useDisplay();
const authStore = useAuthStore();

const isLoggedIn = computed(() => authStore.isLoggedIn);
const loggedInUser = computed(() => authStore.user);
const menuVisible = ref(false);

const logout = () => {
  authStore.logOut(); // Call the logOut action from the auth store
  window.location.href = '/login'; // Redirect to the login page (optional)
};
</script>

<style scoped>
@import "@/assets/stylesheets/style.css";

#nav-admin-dropdown {
  background-color: maroon !important;
  overflow: visible !important;
}

.v-list-item {
  background-color: maroon !important;
}

.v-list-item:hover {
  background-color: var(--v-primary-lighten1) !important;
}

.list-active {
  color: white !important;
  background-color: var(--v-primary-lighten1) !important;
}

.text-white {
  color: white !important;
}

#nav-bar-button {
  background-color: maroon;
}
</style>
