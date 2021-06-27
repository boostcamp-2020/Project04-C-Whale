<template>
  
    <v-menu :offset-y="true" :close-on-content-click="false" :allow-overflow="true">
      <template v-slot:activator="{ on, attrs }">
        <v-btn depressed color="normal" v-bind="attrs" v-on="on">
          <v-icon :color="iconColor" > mdi-alarm </v-icon>
        </v-btn>
      </template>
      <v-list min-height="230">
        <v-list-item>
           <VueTimepicker
              @input="$emit('input', $event)"
              :value="value"
              format="HH시간 mm분 ss초"
              :minute-interval="10"
              :second-interval="10"
              class="my-time-picker"
            />
            후에 알람
        </v-list-item>
      </v-list>  
    </v-menu>
    
   
  
</template>

<script>
import VueTimepicker from "vue2-timepicker/src/vue-timepicker.vue";

export default {
  components: {
    VueTimepicker,
  },
  props: {
    value: Object,
  },
  computed: {
    iconColor: function() {
      return this.value.HH === "00" & this.value.mm === "00" && this.value.ss === "00" 
        ? "grey" 
        : "red"
    }
  }
};
</script>

<style>
.my-time-picker * {
  border: none !important;
  margin-bottom: 0px !important;
}
</style>
