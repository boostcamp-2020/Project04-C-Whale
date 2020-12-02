<template>
  <div>
    <v-list-item-group v-model="model" active-class="font-weight-bold">
      <v-list-item class="pl-8">
        <v-list-item-icon class="mr-4 my-3"
          ><v-icon color="blue">mdi-inbox</v-icon></v-list-item-icon
        >
        <v-list-item-content>
          <v-list-item-title class="font-14">
            관리함 <span>{{ managedProjectCount }}</span>
          </v-list-item-title>
        </v-list-item-content>
      </v-list-item>
      <v-list-item class="pl-8">
        <v-list-item-icon class="mr-4">
          <v-icon color="red">mdi-calendar-today</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title class="font-14">
            오늘 <span>{{ todayTaskCount }}</span>
          </v-list-item-title>
        </v-list-item-content>
      </v-list-item>
    </v-list-item-group>
  </div>
</template>

<script>
export default {
  props: {
    managedProjectCount: Number,
    todayTaskCount: Number,
    nextDayTaskCount: Number,
  },
};
</script>

<style lang="scss">
.font-14 {
  font-size: 14px;
}
</style>
