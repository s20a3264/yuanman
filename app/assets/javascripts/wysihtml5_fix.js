// wysihtml5關閉modal有時有問題
$(document).on('ready page:load',function() {
  // 確保modal被移除
  $('[data-wysihtml5-dialog]').on('hidden.bs.modal', function(){
    $('.modal-backdrop').remove();
  })
});