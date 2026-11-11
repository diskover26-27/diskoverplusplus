<template>
  <v-expansion-panel id="admindropdown">
    <v-expansion-panel-content>
      <template #header>
        <div class="primary-bg">{{ category }}</div>
      </template>
      <template #actions>
        <v-icon color="white">$vuetify.icons.expand</v-icon>
      </template>
      <v-card color="accent">
        <div>
          <v-data-table
            :headers="headers"
            :items="locations"
            class="elevation-1"
          >
            <template #items="meow">
              <td>{{ meow.item.name }}</td>
              <td>{{ meow.item.description }}</td>
            </template>
          </v-data-table>
        </div>
      </v-card>
    </v-expansion-panel-content>
  </v-expansion-panel>
</template>

<script>
export default {
  props: {
    category: {
      type: String,
      default: '',
    },
  },
  data() {
    return {
      headers: [
        { text: 'Name', value: 'name' },
        { text: 'Description', value: 'description' },
      ],
    };
  },
  computed: {
    locations() {
      return this.$store.getters['admin/getLocationsAtCategory'](this.category);
    },
  },
};
</script>

<style scoped>
#admindropdown .v-expansion-panel__header {
  background-color: var(--v-primary-base) !important;
  color: white;
}
</style>
