<template>
  <v-container fluid class="content-overlay">
      <v-container>
        <v-card color="white" class="mb-3" elevation="0">
          <v-card-title>
            <h2 class="text-black">Frequently Asked Questions</h2>
          </v-card-title>
        </v-card>
        <v-card color="white" class="mb-3" elevation="0">
          <v-card-title>
            <h3 class="text-black">Using The Website</h3>
          </v-card-title>
        </v-card>
        <v-expansion-panels>
          <v-expansion-panel>
            <v-expansion-panel-title class="primary--text">How do I search for a specific location?</v-expansion-panel-title>
            <v-expansion-panel-text>
              <v-card color="accent" elevation="0">
                <v-card-text>
                  <ol>
                    <li>Use the search bar on the home page.</li>
                    <li>Type in the location you wish to find.</li>
                    <li>Select a location from the search results.</li>
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
                    <li>Click on the 'Map' button on the upper right side of the homepage.</li>
                    <li>If you are within UP Diliman, you can use your GPS to automatically track your location. Diskover++ will then generate a driving route to your destination.</li>
                    <li>If you are not within UP Diliman, a blue pin should show up at the Quezon Hall/Oblation Statue location. This blue pin acts as your origin point and you can drag this blue pin to any location. Diskover++ will then automatically generate driving directions for you.</li>
                  </ol>
                </v-card-text>
              </v-card>
            </v-expansion-panel-text>
          </v-expansion-panel>
        </v-expansion-panels>
        <v-card color="white" class="mb-3" elevation="0">
          <v-card-title>
            <h3 class="text-black">Admin Guide: Updating Locations</h3>
          </v-card-title>
        </v-card>
      <v-expansion-panels>
          <v-expansion-panel>
            <v-expansion-panel-title class="primary--text">How do I create and add a new location?</v-expansion-panel-title>
            <v-expansion-panel-text>
              <v-card color="accent" elevation="0">
                <v-card-text>
                  <ol>
                    <li>Log in to your admin account.</li>
                    <li>Click "Logged in as [your username]" and choose "Create new location".</li>
                    <li>Fill in the necessary information. Drag the pin on the map to mark the new location.</li>
                    <li>Once done, click "Create location".</li>
                  </ol>
                </v-card-text>
              </v-card>
            </v-expansion-panel-text>
          </v-expansion-panel>
          <v-expansion-panel>
            <v-expansion-panel-title class="primary--text">How do I add a new image?</v-expansion-panel-title>
            <v-expansion-panel-text>
              <v-card color="accent" elevation="0">
                <v-card-text>
                  <ol>
                    <li>Log in to your admin account.</li>
                    <li>Click "Logged in as [your username]" and choose "Upload new images".</li>
                    <li>Click "Choose files" to upload new unbinded image.</li>
                    <li>Once done, click "Upload unbinded images".</li>
                  </ol>
                </v-card-text>
              </v-card>
            </v-expansion-panel-text>
          </v-expansion-panel>
          <v-expansion-panel>
            <v-expansion-panel-title class="primary--text">How do I update an existing location?</v-expansion-panel-title>
            <v-expansion-panel-text>
              <v-card color="accent" elevation="0">
                <v-card-text>
                  <ol>
                    <li>Log in to your admin account.</li>
                    <li>Choose an existing location by searching it.</li>
                    <li>At the bottom of the left panel, click "Update Info" to update textual information or "Update Images" to update existing images.</li>
                    <li>Update the information as needed. For images, new images can be binded to the location by uploading via "Choose files". Already uploaded images binded to other locations can also be binded by searching for and choosing that location.</li>
                    <li>Once done, click "Update location" or "Update location images".</li>
                  </ol>
                </v-card-text>
              </v-card>
            </v-expansion-panel-text>
          </v-expansion-panel>
          <v-expansion-panel>
            <v-expansion-panel-title class="primary--text">How do I delete an existing location?</v-expansion-panel-title>
            <v-expansion-panel-text>
              <v-card color="accent" elevation="0">
                <v-card-text>
                  <ol>
                    <li>Log in to your admin account.</li>
                    <li>Choose an existing location by searching it.</li>
                    <li>At the bottom of the left panel, click "Delete".</li>
                    <li>Scroll down and click "Delete".</li>
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
