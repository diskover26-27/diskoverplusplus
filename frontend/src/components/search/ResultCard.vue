<template>
  <!-- Card for showing a location search result, shadow effect on hover -->
  <v-hover v-slot="{ isHovering }">
  <v-card
    theme="light"
    class="secondary-bg overflow-hidden border rounded-lg"
    :class="`elevation-${isHovering ? 12 : 2}`"
    :to="`/map/details/${result.id}`"
    height="100px"
  >
    <v-row no-gutters wrap>
      <v-col cols="5">
        <v-img height="100%" cover aspect-ratio="1/1" :src="thumbnailUrl" />
      </v-col>
      <v-col cols="7" class="pr-2 pt-2 pb-2 card-content">
        <v-card-title class ="card-title">{{ result.name }}</v-card-title>
        <v-card-text class="card-text">
          <div ref="desc">{{ result.description }}</div>
        </v-card-text>
      </v-col>
    </v-row>

  </v-card>
</v-hover>
</template>

<script>
import defaultThumbnail from '@/assets/no-thumbnail.jpg';

export default {
  props: {
    // parent component specifies the result to display
    result: {
      type: Object
    }
  },
  data() {
    return {
      // default thumbnail to use in case result doesn't have an image
      defaultThumbnail
    };
  },
  // called when card is ready for rendering
  mounted() {
    // clamps the description text to a maximum of two lines; truncates with ellipsis
    $clamp(this.$refs.desc, { clamp: 3 });
  },
  computed: {
    // complete the full thumbnail url using the backend static path and the thumbnail url
    thumbnailUrl() {
      return this.result.thumbnail_url
        ? `${this.$backendStaticPath}/images/locations/${this.result.thumbnail_url}`
        : '/assets/no-thumbnail.jpg'; // Adjust the path as needed
    },
  }
};
</script>

<style scoped>
.card-title{
  font-size:medium;
  padding:0;
}
.card-text{
  font-size: small;
  padding:0;
}
.card-text > div{
  overflow: hidden;
  text-overflow: ellipsis;
}
.card-content{
  height: 100px;
}
.v-card {
  box-shadow: none !important;
}
</style>
