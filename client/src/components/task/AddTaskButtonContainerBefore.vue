<template>
  <div class="add-button-container">
    <v-btn @click="$emit('showForm')" text color="#777777">
      <v-icon color="primary" dense class="mr-1"> mdi-plus </v-icon>
      작업 추가
    </v-btn>

    <v-btn
      @click="
        $emit('showForm');
        $emit('getUrl');
      "
      text
      color="#777777"
    >
      <v-icon color="primary" dense class="mr-1"> mdi-plus </v-icon>
      웹사이트를 작업으로 추가
    </v-btn>
  </div>
</template>

<style>
.add-button-container {
  display: flex;
  margin-top: 6px;
}
</style>
