<template>
  <v-dialog v-model="myVisible" max-width="750px" max-height="750px" persistent>
    <!-- Set max-width and persistent -->
    <v-card class="modal"
      ><v-card-actions>
        <v-btn color="black" text @click="emit('close')">Close</v-btn>
        <v-spacer></v-spacer>
      </v-card-actions>
      <v-card-text>
        <slot></slot>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
  isVisible: {
    type: Boolean,
    default: false,
  },
});

const emit = defineEmits(['close', 'update:isVisible']);

const myVisible = computed({
  get() {
    return props.isVisible;
  },
  set(value) {
    emit('update:isVisible', value);
  },
});
</script>

<style scoped>
.modal {
  background-color: white;
}
</style>
