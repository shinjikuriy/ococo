import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="nested-form"
export default class extends Controller {
  static targets = ["links", "template", "forms"];

  connect() {
    this.wrapperClass = this.data.get("wrapperClass") || "nested-fields";
  }

  add_association(event){
    event.preventDefault();

    let content = this.templateTarget.innerHTML.replace(
      /NEW_RECORD/g,
      new Date().getTime()
    );
    this.formsTarget.insertAdjacentHTML("beforeend", content);
  }

  remove_association(event){
    event.preventDefault();

    let wrapper = event.target.closest("." + this.wrapperClass);

    // レコードがDBに保存されていない場合、ページから削除
    if(wrapper.dataset.newRecord == "true"){
      wrapper.remove();
      // レコードがDBに保存されている場合、表示を隠し、削除フラグを立てる
    } else {
      wrapper.querySelector("input[name*='_destroy']").value = 1;
      wrapper.style.display = "none";
    }
  }
}
