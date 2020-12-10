import bus from "@/utils/bus.js";

export default {
  created() {
    bus.$emit("start:spinner");
  },
  mounted() {
    bus.$emit("end:spinner");
  },
};
