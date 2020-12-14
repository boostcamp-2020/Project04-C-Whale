import myAxios from "./myAxios";

const bookmarkAPI = {
  getAllBookmarks(taskId) {
    return myAxios.get(`/task/${taskId}/bookmark`);
  },
  createBookmark(taskId, data) {
    return myAxios.post(`/task/${taskId}/bookmark`, data);
  },
  deleteBookmark(taskId, bookmarkId) {
    return myAxios.delete(`/task/${taskId}/bookmark/${bookmarkId}`);
  },
};

export default bookmarkAPI;
