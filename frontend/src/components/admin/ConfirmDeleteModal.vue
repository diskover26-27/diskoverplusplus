<template>
  <CenterModal :isVisible="isVisible" @close="$emit('cancel')">
    <v-sheet class="pa-8 rounded-xl text-center mx-auto" width="450">
      
      <v-icon 
        icon="mdi-alert-circle-outline" 
        color="red-lighten-1" 
        size="64" 
        class="mb-4"
      ></v-icon>

      <div class="text-h5 font-weight-bold text-red-darken-2 mb-2">
        Delete {{ itemType }}?
      </div>

      <div class="text-body-1 text-medium-emphasis mb-6">
        Are you sure you want to delete 
        <span class="font-weight-bold text-black">"{{ itemName }}"</span>?
        <br>This action cannot be undone.
      </div>

      <v-row justify="center" no-gutters>
        <v-col cols="12" sm="auto" class="ma-1">
          <v-btn 
            color="red-darken-1" 
            variant="flat" 
            height="45"
            width="120"
            class="text-white"
            :loading="isSubmitting"
            @click="$emit('confirm')"
          >
            Yes, Delete
          </v-btn>
        </v-col>
        <v-col cols="12" sm="auto" class="ma-1">
          <v-btn 
            color="grey-lighten-3" 
            variant="flat" 
            height="45"
            width="120"
            @click="$emit('cancel')"
            :disabled="isSubmitting"
          >
            Cancel
          </v-btn>
        </v-col>
      </v-row>
    </v-sheet>
  </CenterModal>
</template>

<script setup>
import CenterModal from "@/components/ui/CenterModal.vue";

defineProps({
  isVisible: { type: Boolean, default: false },
  isSubmitting: { type: Boolean, default: false },
  itemName: { type: String, default: 'this item' },
  itemType: { type: String, default: 'Item' }
});

defineEmits(['confirm', 'cancel']);
</script>