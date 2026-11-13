<template>
  <v-card theme="light" class="review-card pa-4" variant="outlined">
    <div class="review-card__header">
      <v-avatar color="#7b1113" size="36">
        <span class="text-white text-body-2">{{ initial }}</span>
      </v-avatar>

      <div class="review-card__meta">
        <div class="review-card__author">{{ review.author }}</div>
        <div class="review-card__date">{{ formattedDate }}</div>
      </div>

      <StarRating :rating="review.rating" class="review-card__rating" />
    </div>

    <div v-if="review.title" class="review-card__title">
      {{ review.title }}
    </div>
    <p class="review-card__comment">{{ review.comment }}</p>
  </v-card>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import StarRating from './StarRating.vue';

const props = defineProps({
  review: {
    type: Object,
    required: true,
  },
});

const initial = computed(() => {
  const name = props.review.author?.trim();
  return name ? name.charAt(0).toUpperCase() : '?';
});

const formattedDate = new Date(props.review.createdAt).toLocaleDateString();
</script>

<style scoped>
.review-card {
  background: #ffffff !important;
  border: 1px solid rgba(123, 17, 19, 0.3);
  color: #202124;
  margin-bottom: 12px;
}

.review-card__header {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 10px;
}

.review-card__meta {
  min-width: 0;
}

.review-card__author {
  font-weight: 700;
  font-size: 0.9rem;
  color: #202124;
}

.review-card__date {
  font-size: 0.75rem;
  color: #5f6368;
}

.review-card__rating {
  margin-left: auto;
}

.review-card__title {
  font-weight: 700;
  font-size: 0.95rem;
  color: #7b1113;
  margin-bottom: 4px;
}

.review-card__comment {
  font-size: 0.875rem;
  line-height: 1.5;
  color: #3c4043;
  white-space: pre-wrap;
}
</style>
