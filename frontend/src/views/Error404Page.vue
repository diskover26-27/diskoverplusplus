<template>
  <v-container
    class="fill-height align-center justify-center"
    style="min-height: 100vh"
  >
    <v-card
      class="rounded-xl pa-5 login-bg"
      elevation="24"
      max-width="500"
      width="100%"
    >
      <v-container
        class="d-flex flex-column align-center justify-center text-center"
      >
        <v-icon size="100" class="mb-4" color="primary"
          >mdi-alert-circle-outline</v-icon
        >
        <h1 class="text-h4 font-weight-bold">404 - Page Not Found</h1>
        <p class="text-body-1 mt-2 mb-6">
          Sorry, the page you are looking for doesn't seem to exist.
        </p>
        <div class="d-flex gap-4">
          <v-btn color="primary" to="/" variant="flat">Home Page</v-btn>
          <v-btn color="secondary" to="/map" variant="flat">Map Page</v-btn>
        </div>
      </v-container>
    </v-card>
  </v-container>
</template>

<style scoped>
.content-overlay {
  z-index: 0;
  background: white;
  width: 100%;
  height: 100vh;
  display: flex;
  flex-direction: column;
  padding: 10%;
}
.v-card-text {
  display: flex;
  flex-direction: column;
  align-items: center;
}
.gap-4 {
  gap: 16px;
}
</style>
