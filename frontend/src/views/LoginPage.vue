<template>
  <v-container class="fill-height">
    <v-row align="center" justify="center">
      <v-col cols="12" md="6" class="d-flex justify-center">
        <v-card
          class="rounded-xl pa-5 login-bg"
          elevation="24"
          max-width="500"
          width="100%"
        >
          <v-card-text>
            <div
              v-if="!isLoggedIn"
              class="d-flex flex-column align-center w-100"
            >
              <h1 class="mb-4 text-maroon">Login</h1>
              <form class="w-100" @submit.prevent="attemptLogIn">
                <v-text-field
                  v-model="username"
                  rounded
                  variant="outlined"
                  label="Username"
                  :error-messages="
                    invalidLogInAttempt ? 'Invalid Username' : null
                  "
                  class="mb-4 w-100"
                />
                <v-text-field
                  v-model="password"
                  rounded
                  variant="outlined"
                  type="password"
                  label="Password"
                  :error-messages="
                    invalidLogInAttempt ? 'Invalid Password' : null
                  "
                  class="mb-4 w-100"
                />
                <v-btn
                  rounded="xl"
                  size="large"
                  type="submit"
                  color="maroon"
                  class="text-white w-100"
                  :loading="isProcessing"
                  :disabled="isProcessing"
                >
                  Login
                </v-btn>
              </form>
            </div>

            <div v-else class="d-flex flex-column align-center">
              <div class="mb-4">
                Currently logged in as
                <span class="text-primary font-weight-bold">{{
                  loggedInUser
                }}</span>
              </div>
              <div class="mb-4">Logout?</div>
              <div class="d-flex">
                <v-btn color="blue" class="text-white mr-2" @click="logOut"
                  >Yes</v-btn
                >
                <v-btn color="red" class="text-white" @click="backPage"
                  >No</v-btn
                >
              </div>
            </div>
          </v-card-text>
        </v-card>
      </v-col>

      <v-col cols="12" md="6" class="d-none d-md-block">
        <v-card
          color="maroon"
          class="elevation-24 rounded-xl border-lg overflow-hidden"
        >
          <v-img :src="upImage" height="500" cover />
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '@/stores/auth';
import { useMainStore } from '@/stores/index';
import upImage from '@/assets/images/upimg.jpg';

const authStore = useAuthStore();
const mainStore = useMainStore();
const router = useRouter();

const username = ref('');
const password = ref('');
const isProcessing = ref(false);

const attemptLogIn = async () => {
  isProcessing.value = true;
  try {
    await authStore.logIn({
      username: username.value,
      password: password.value,
    });
    // Determine redirect target
    const prev = mainStore.previousPage;
    if (prev === '/admin/unauthenticated' || prev === '/404' || !prev) {
      router.push('/'); // or router.push('/admin') if you want to go to admin dashboard
    } else {
      router.push(prev);
    }
  } catch (error) {
    console.error('Login failed:', error);
  } finally {
    isProcessing.value = false;
  }
};

const logOut = () => {
  authStore.logOut();
};

const backPage = () => {
  window.history.back();
};

const isLoggedIn = computed(() => authStore.isLoggedIn);
const invalidLogInAttempt = computed(() => authStore.invalidLogInAttempt);
const loggedInUser = computed(() => authStore.user);
</script>

<style scoped>
@import '@/assets/stylesheets/style.css';

.login-bg {
  background-color: white !important;
}

.text-white {
  color: white !important;
}

.v-btn:hover {
  filter: brightness(1.2);
}

.fill-height {
  height: calc(
    100vh - 64px
  ); /* Adjust the height to fill the screen under the navbar */
}

.v-card-text {
  display: flex;
  flex-direction: column;
  align-items: center;
}
</style>
