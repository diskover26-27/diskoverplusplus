<template>
  <!-- selection input with multiple category chips -->
  <div id="tag-select">
    <v-select
      v-model="tagsFilter"
      theme="light"
      :items="tags"
      attach
      label="Tags"
      multiple
      clearable
      hide-details
      chips
      density="compact"
      variant="solo"
    />
  </div>
</template>

<script>
import { useMainStore } from '@/stores/index'; // Import the main store
import { useSearchStore } from '@/stores/search';
import { computed } from 'vue';

export default {
  setup() {
    const mainStore = useMainStore(); // Access the main store
    const searchStore = useSearchStore();

    const tags = computed(() => mainStore.tagNames);

    const tagsFilter = computed({
      get() {
        return searchStore.tagsFilter;
      },
      set(value) {
        searchStore.setTagsFilter(value); // Update tagsFilter in the store
      },
    });

    return {
      tags,
      tagsFilter,
    };
  },
};
</script>
