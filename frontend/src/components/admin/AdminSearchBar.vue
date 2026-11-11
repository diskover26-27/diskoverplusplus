<template>
  <!-- Search field for inputting search queries -->
  <!-- Navigates to result page when Enter is pressed -->
  <v-text-field
    v-model="searchText"
    class="nav-search"
    label="Where to?"
    placeholder="Search away!"
    solo
    hide-details
    height="1em"
    @keyup.enter="emitSearch"
  >
    <!-- Navigate to result page when search button is pressed -->
    <template #append>
      <v-btn color="primary" icon dark @click.stop="emitSearch">
        <v-icon>search</v-icon>
      </v-btn>
    </template>
  </v-text-field>
</template>

<script>
export default {
  data() {
    return {
      // stores the text that has been typed in the search bar
      searchText: '',
    };
  },
  computed: {
    // referencing the apiQuery from the Vuex store
    apiQuery() {
      return this.$store.getters['admin/locations/apiQuery'];
    },
  },
  methods: {
    // used to set search values to the apiQuery in Vuex store and then navigate to the results page
    emitSearch() {
      this.$store.commit('admin/locations/setSearchFilter', this.searchText);
      this.$router.push({
        path: '/admin/locations',
        query: this.apiQuery,
      });
    },
  },
};
</script>

<style scoped>
.nav-search {
  align-self: center;
}
</style>
