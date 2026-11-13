<template>
  <section class="review-list">
    <div class="review-list__header">
      <h3 class="review-list__title">Reviews</h3>

      <div v-if="reviews.length" class="review-list__summary">
        <StarRating :rating="averageRating" show-value />
        <span class="review-list__count">
          {{ reviews.length }}
          {{ reviews.length === 1 ? 'review' : 'reviews' }}
        </span>
      </div>
    </div>

    <v-alert
      v-if="!reviews.length"
      type="info"
      variant="tonal"
      density="comfortable"
      class="review-list__empty"
    >
      No reviews yet.
    </v-alert>

    <div v-else>
      <ReviewCard v-for="review in reviews" :key="review.id" :review="review" />
    </div>
  </section>
</template>

<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue';
import { getReviews } from '@/services/reviews';
import ReviewCard from './ReviewCard.vue';
import StarRating from './StarRating.vue';

const props = defineProps({
  locationId: {
    type: Number,
    required: true,
  },
  refreshKey: {
    type: Number,
    default: 0,
  },
});

const reviews = ref([]);

const loadReviews = () => {
  reviews.value = getReviews(props.locationId);
};

const averageRating = computed(() => {
  if (!reviews.value.length) return 0;
  let sum = 0;
  for (const r of reviews.value) sum += r.rating;
  return sum / reviews.value.length;
});

onMounted(loadReviews);

watch(
  () => [props.locationId, props.refreshKey],
  () => loadReviews()
);
</script>

<style scoped>
.review-list {
  margin-bottom: 8px;
}

.review-list__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 12px;
}

.review-list__title {
  color: #7b1113;
  font-weight: 700;
  font-size: 1.05rem;
}

.review-list__summary {
  display: inline-flex;
  align-items: center;
  gap: 8px;
}

.review-list__count {
  font-size: 0.8rem;
  color: #5f6368;
}

.review-list__empty {
  margin-bottom: 12px;
}
</style>
