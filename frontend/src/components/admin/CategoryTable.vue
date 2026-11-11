<template>
  <v-data-table
    v-if="categories && categories.length >= 0"
    :headers="headers"
    :items="categories"
    class="elevation-0 border rounded-lg"
    hover
    hide-default-footer
    mobile-breakpoint="sm"
  >
    <template #item.route_color="{ item }">
      <v-icon :color="item.route_color || item.raw?.route_color" size="large">
        mdi-map-marker
      </v-icon>
    </template>

    <template #item.actions="{ item }">
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
    categories: {
      type: Array,
      default: () => [],
    },
  },
  emits: ['edit-item', 'delete-item'],
  data() {
    return {
      headers: [
        { title: 'Name', key: 'name', align: 'start' },
        { title: 'URL', key: 'url', align: 'start' },
        {
          title: 'Route Color',
          key: 'route_color',
          align: 'center',
          sortable: false,
        },
        { title: 'Actions', key: 'actions', align: 'center', sortable: false },
      ],
    };
  },
};
</script>
