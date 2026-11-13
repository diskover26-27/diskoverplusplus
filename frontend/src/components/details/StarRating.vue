<template>
  <span class="star-rating">
    <v-rating
      :model-value="rating"
      readonly
      density="compact"
      color="#f3aa2c"
      active-color="#f3aa2c"
      :size="size"
      half-increments
    />
    <span v-if="showValue" class="star-rating__value">
      {{ rating.toFixed(1) }}
    </span>
  </span>
</template>

<script setup lang="ts">
defineProps({
  rating: {
    type: Number,
    required: true,
  },
  size: {
    type: [String, Number],
    default: 'small',
  },
  showValue: {
    type: Boolean,
    default: false,
  },
});
</script>

<style scoped>
.star-rating {
  display: inline-flex;
  align-items: center;
  gap: 6px;
}

.star-rating__value {
  font-size: 0.85rem;
  font-weight: 600;
  color: #5f6368;
}
</style>
