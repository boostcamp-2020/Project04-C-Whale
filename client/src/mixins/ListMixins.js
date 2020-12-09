import bus from "@/utils/bus.js";

export default {
  mounted() {
    bus.$emit("end:spinner");
  },
};
