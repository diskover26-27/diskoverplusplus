<template>
  <!-- renders the default background image -->
  <div class="up-background" :style="backgroundImageStyle">
    <slot></slot>
  </div>
</template>

<script>
// import default background image
import bgImg from '@/assets/backgrounds/bgimg.png'

export default {
  // set the background image
  data: () => ({
    backgroundImageStyle: {
      backgroundImage: `url(${bgImg})`
    },
  }),
}
</script>

<style scoped>
/* expand the background image to 100% page height and anchor at the center */
.up-background {
  width: 100vw;
  height: 100vh;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
}
</style>
