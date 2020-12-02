<template>
  <div>
    <v-list-item>
      <v-list-item-content>
        <v-list-item-title>관리함 </v-list-item-title>
      </v-list-item-content>
    </v-list-item>
    <v-list-item>
      <v-list-item-content>
        <v-list-item-title>오늘 {{ todayTaskCount }}</v-list-item-title>
      </v-list-item-content>
    </v-list-item>
    <v-list-item>
      <v-list-item-content>
        <v-list-item-title>다음 {{ nextDayTaskCount }}</v-list-item-title>
      </v-list-item-content>
    </v-list-item>
  </div>
</template>

<script>
export default {
  props: {
    todayTaskCount: Number,
    nextDayTaskCount: Number,
  },
};
</script>
