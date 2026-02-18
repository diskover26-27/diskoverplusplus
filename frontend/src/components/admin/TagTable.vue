<template>
  <v-data-table
    v-if="tags && tags.length >= 0"
    :headers="headers"
    :items="tags"
    class="elevation-0 border rounded-lg"
    hover
    mobile-breakpoint="sm"
    hide-default-footer="true"
  >
    <template v-slot:item.actions="{ item }">
      <div class="d-flex justify-end justify-sm-center align-center">
        <v-btn
          icon="mdi-pencil"
          variant="text"
          color="primary"
          size="small"
          class="mr-2"
          @click="$emit('edit-item', item.id || item.raw?.id)"
        ></v-btn>
        <v-btn
          icon="mdi-delete"
          variant="text"
          color="error"
          size="small"
          @click="$emit('delete-item', item.id || item.raw?.id)"
        ></v-btn>
      </div>
    </template>
  </v-data-table>
</template>

<script>
export default {
  props: {
    tags: {
      type: Array,
      default: () => [],
    },
  },
  data() {
    return {
      headers: [
        { title: 'Name', key: 'name', align: 'start' },
        { title: 'Actions', key: 'actions', align: 'center', sortable: false },
      ],
    };
  },
};
</script>