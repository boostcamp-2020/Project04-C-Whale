<template>
  <v-btn depressed color="normal">
    <v-icon color="red"> mdi-alarm </v-icon>
    <VueTimepicker
      @input="pickTime"
      v-model="time"
      :format="timePickerFormat"
      :minute-interval="10"
      :second-interval="10"
      class="my-time-picker"
    />
  </v-btn>
</template>

<script>
import VueTimepicker from "vue2-timepicker/src/vue-timepicker.vue";
export default {
  components: {
    VueTimepicker,
  },
  data() {
    return {
      time: {
        HH: "00",
        mm: "00",
        ss: "00",
      },
      timePickerFormat: "HH시간 mm분 ss초",
    };
  },
  methods: {
    pickTime(data) {
      this.$emit("pickAlarmTime", data);
    },
  },
};
</script>

<style>
.my-time-picker * {
  border: none !important;
  margin-bottom: 0px !important;
}
</style>
