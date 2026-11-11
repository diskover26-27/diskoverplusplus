<template>
  <!-- selection field for inputting how results are sorted -->
  <v-select
    v-model="sortFilter"
    :items="sortItems"
    label="Sort by..."
    clearable
    attach
    item-title="text"
    item-value="value"
    hide-details
    class="selector"
    density="compact"
    variant="solo"
    theme="light"
  />
</template>

<script>
import { useSearchStore } from '@/stores/search';
import { computed } from 'vue';

export default {
  setup() {
    const searchStore = useSearchStore();

    const sortItems = [
      { text: 'alphabetically (a-z)', value: 'name' },
      { text: 'alphabetically (z-a)', value: '-name' },
      { text: 'least recently added', value: 'id' },
      { text: 'most recently added', value: '-id' },
    ];

    const sortFilter = computed({
      get() {
        return searchStore.orderingFilter;
      },
      set(value) {
        searchStore.setOrderingFilter(value); // Update orderingFilter in the store
      },
    });

    return {
      sortItems,
      sortFilter,
    };
  },
};
</script>

<style scoped></style>
