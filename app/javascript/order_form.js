const PLACEHOLDER = "TPLINDEX"

export function initOrderForm() {
  const form = document.getElementById("order-form")
  if (!form) return

  document.getElementById("add-item")?.addEventListener("click", addItem)
  form.addEventListener("change", handleChange)
  form.addEventListener("click", handleRemove)

  updateTotal()
}

function addItem() {
  const template = document.getElementById("order-item-template")
  if (!template) return
  const index = Date.now()
  const html = template.innerHTML.replaceAll(PLACEHOLDER, index)
  const wrapper = document.createElement("div")
  wrapper.innerHTML = html
  document.getElementById("order-items").appendChild(wrapper.firstElementChild)
}

function handleChange(e) {
  const item = e.target.closest("[data-order-item]")
  if (!item) return

  if ("priceSelect" in e.target.dataset) updateUnitPrice(e.target, item)
  updateSubtotal(item)
  updateTotal()
}

function handleRemove(e) {
  if (!("removeItem" in e.target.dataset)) return
  const item = e.target.closest("[data-order-item]")
  if (!item) return

  if ("persisted" in item.dataset) {
    item.querySelector("[data-destroy]").value = "true"
    item.style.display = "none"
  } else {
    item.remove()
  }
  updateTotal()
}

function updateUnitPrice(select, item) {
  const price = select.selectedOptions[0]?.dataset.price || "0"
  item.querySelector("[data-unit-price]").value = price
}

function updateSubtotal(item) {
  const qty   = parseFloat(item.querySelector("[data-quantity]")?.value)  || 0
  const price = parseFloat(item.querySelector("[data-unit-price]")?.value) || 0
  item.querySelector("[data-subtotal]").textContent = formatCurrency(qty * price)
}

function updateTotal() {
  let total = 0
  document.querySelectorAll("[data-order-item]").forEach(item => {
    if (item.querySelector("[data-destroy]")?.value === "true") return
    const qty   = parseFloat(item.querySelector("[data-quantity]")?.value)  || 0
    const price = parseFloat(item.querySelector("[data-unit-price]")?.value) || 0
    total += qty * price
  })
  const display = document.getElementById("order-total-display")
  if (display) display.textContent = formatCurrency(total)
}

function formatCurrency(value) {
  return "R$ " + value.toFixed(2).replace(".", ",")
}
