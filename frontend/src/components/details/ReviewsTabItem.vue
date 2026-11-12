<template>
  <v-card theme="light" color="#7b1113" class="pa-3">
    <div v-if="reviews.length" class="review-summary mb-4">
      <div class="text-h5 font-weight-bold">{{ averageRating.toFixed(1) }}</div>
      <div>
        <v-rating
          :model-value="averageRating"
          color="#f3aa2c"
          active-color="#f3aa2c"
          density="compact"
          half-increments
          readonly
        />
        <div class="text-caption">{{ reviews.length }} review{{ reviews.length === 1 ? '' : 's' }}</div>
      </div>
    </div>

    <v-alert v-else type="info" variant="tonal" class="mb-4">
      No reviews yet. Be the first to share your experience.
    </v-alert>

    <v-card
      v-for="review in reviews"
      :key="review.id"
      theme="light"
      variant="outlined"
      class="mb-3 pa-3"
    >
      <div class="d-flex justify-space-between align-start">
        <div>
          <div class="font-weight-bold">
            {{ review.title || 'Review' }}
          </div>
          <div class="text-caption">{{ review.author }} · {{ formatDate(review.createdAt) }}</div>
        </div>
        <v-rating
          :model-value="review.rating"
          color="#f3aa2c"
          active-color="#f3aa2c"
          density="compact"
          size="small"
          readonly
        />
      </div>
      <p class="mb-0 mt-2">{{ review.comment }}</p>
    </v-card>

    <ReviewForm
      :location-id="locationId"
      :location-name="locationName"
      @submitted="loadReviews"
    />
  </v-card>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue';
import ReviewForm from '@/components/details/ReviewForm.vue';
import { getReviews, type Review } from '@/services/reviews';

const props = defineProps({
  locationId: {
    type: Number,
    required: true,
  },
  locationName: {
    type: String,
    default: '',
  },
});

const reviews = ref<Review[]>([]);

const loadReviews = () => {
  reviews.value = getReviews(props.locationId);
};

const averageRating = computed(() => {
  if (!reviews.value.length) {
    return 0;
  }

  return (
    reviews.value.reduce((total, review) => total + review.rating, 0) /
    reviews.value.length
  );
});

const formatDate = (date: string) =>
  new Intl.DateTimeFormat(undefined, {
    dateStyle: 'medium',
  }).format(new Date(date));

watch(() => props.locationId, loadReviews, { immediate: true });
</script>

<style scoped>
.review-summary {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}
</style>

