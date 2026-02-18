<template>
  <v-container fluid class="content-overlay">
      <v-container>
        <v-card color="white" class="mb-3" elevation="0">
          <v-card-title>
            <h2 class="text-black">Frequently Asked Questions</h2>
          </v-card-title>
        </v-card>
        <v-expansion-panels>
          <v-expansion-panel>
            <v-expansion-panel-title class="primary--text">How do I search for a specific location?</v-expansion-panel-title>
            <v-expansion-panel-text>
              <v-card color="accent" elevation="0">
                <v-card-text>
                  <ol>
                    <li>Use the search bar on the home page</li>
                    <li>Type in the location you wish to find</li>
                    <li>Select a location from the search results</li>
                  </ol>
                </v-card-text>
              </v-card>
            </v-expansion-panel-text>
          </v-expansion-panel>
          <v-expansion-panel>
            <v-expansion-panel-title class="primary--text">How do I search for a location by category?</v-expansion-panel-title>
            <v-expansion-panel-text>
              <v-card color="accent" elevation="0">
                <v-card-text>
                  <ol>
                    <li>Click on the top left logo to go back to the home page.</li>
                    <li>Click on a category panel you wish to search for.</li>
                    <li>Choose a location from the list that will appear on the left of the next page.</li>
                  </ol>
                </v-card-text>
              </v-card>
            </v-expansion-panel-text>
          </v-expansion-panel>
          <v-expansion-panel>
            <v-expansion-panel-title class="primary--text">How do I get driving directions from the map?</v-expansion-panel-title>
            <v-expansion-panel-text>
              <v-card color="accent" elevation="0">
                <v-card-text>
                  <ol>
                    <li>Click on the 'Map' button on the upper right side of the homepage</li>
                    <li>If you are within UP Diliman, you can use your GPS to automatically track your location. Diskover++ will then generate a driving route to your destination.</li>
                    <li>If you are not within UP Diliman, a blue pin should show up at the Quezon Hall/Oblation Statue location. This blue pin acts as your origin point and you can drag this blue pin to any location. Diskover++ will then automatically generate driving directions for you.</li>
                  </ol>
                </v-card-text>
              </v-card>
            </v-expansion-panel-text>
          </v-expansion-panel>
        </v-expansion-panels>
      </v-container>
  </v-container>
</template>

<script>
export default {

}
</script>

<style scoped>

.content-overlay {
  z-index: -2;
  background: white;
  width: 100%;
  height: 100vh;
  display: flex;
  flex-direction: column;
  padding: 10%; 
}

#faq .v-expansion-panel-title {
  background-color: var(--v-primary-base) !important;
  color: white;
}

.link {
  color: #87CEEB !important;
}
</style>
