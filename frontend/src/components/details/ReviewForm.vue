<template>
  <v-card theme="light" class="review-form pa-4" variant="outlined">
    <v-card-title class="review-heading px-0 pt-0">
      Share your experience
    </v-card-title>
    <v-card-subtitle class="review-subtitle px-0">
      Add a review for {{ locationName || 'this location' }}.
    </v-card-subtitle>

    <v-form ref="form" class="mt-4" @submit.prevent="onSubmit">
      <v-text-field
        v-model="author"
        label="Your name"
        prepend-inner-icon="mdi-account-outline"
        :rules="[requiredRule]"
        maxlength="80"
        required
        class="review-field"
      />

      <div class="review-label text-subtitle-2 mb-1">Rating</div>
      <v-rating
        v-model="rating"
        color="#f3aa2c"
        active-color="#f3aa2c"
        hover
        density="compact"
      />
      <div v-if="showRatingError" class="review-error text-caption">
        Please select a rating.
      </div>

      <v-text-field
        v-model="title"
        label="Review title (optional)"
        maxlength="100"
        class="review-field mt-3"
      />

      <v-textarea
        v-model="comment"
        label="What did you think?"
        rows="4"
        maxlength="500"
        counter
        :rules="[requiredRule]"
        required
        class="review-field"
      />

      <v-alert v-if="errorMessage" type="error" variant="tonal" class="mb-3">
        {{ errorMessage }}
      </v-alert>

      <v-btn
        type="submit"
        color="#7b1113"
        variant="elevated"
        class="text-white"
        :loading="isSubmitting"
      >
        Submit review
      </v-btn>
    </v-form>
  </v-card>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { createReview } from '@/services/reviews';

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

const emit = defineEmits<{
  submitted: [];
}>();

const form = ref();
const author = ref('');
const rating = ref(0);
const title = ref('');
const comment = ref('');
const isSubmitting = ref(false);
const showRatingError = ref(false);
const errorMessage = ref('');

const requiredRule = (value: string) =>
  Boolean(value?.trim()) || 'This field is required.';

const onSubmit = async () => {
  showRatingError.value = rating.value < 1;
  errorMessage.value = '';
  const validation = await form.value?.validate();

  if (!validation?.valid || showRatingError.value) {
    return;
  }

  isSubmitting.value = true;

  try {
    createReview({
      locationId: props.locationId,
      author: author.value.trim(),
      rating: rating.value,
      title: title.value.trim(),
      comment: comment.value.trim(),
    });
    author.value = '';
    rating.value = 0;
    title.value = '';
    comment.value = '';
    form.value?.resetValidation();
    emit('submitted');
  } catch (error) {
    console.error('Unable to save review:', error);
    errorMessage.value = 'Your review could not be saved. Please try again.';
  } finally {
    isSubmitting.value = false;
  }
};
</script>

<style scoped>
.review-form {
  background: #ffffff !important;
  border: 1px solid rgba(123, 17, 19, 0.3);
  color: #202124;
  margin-bottom: 24px;
}

.review-heading {
  color: #7b1113;
  font-weight: 700;
}

.review-subtitle,
.review-label {
  color: #3f3f46 !important;
}

.review-error {
  color: #b42318;
  font-weight: 600;
}

.review-field :deep(.v-field) {
  background: #ffffff;
  color: #202124;
}

.review-field :deep(.v-label),
.review-field :deep(input),
.review-field :deep(textarea),
.review-field :deep(.v-icon),
.review-field :deep(.v-counter) {
  color: #202124 !important;
  opacity: 1;
}

.review-field :deep(.v-label) {
  color: #4b5563 !important;
}

.review-field :deep(.v-field__outline) {
  color: #6b7280;
}

.review-field :deep(.v-messages__message) {
  color: #b42318;
}
</style>
