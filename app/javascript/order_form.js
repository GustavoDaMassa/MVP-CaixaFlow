export function initOrderForm() {
  const form = document.getElementById("order-form")
  if (!form) return

  setupTabs()
  setupSearch()
  setupProductCards()
  setupCart()
  initExistingItems()
}

// ── Category tabs ─────────────────────────────────────────────
function setupTabs() {
  document.querySelectorAll(".pos-tab").forEach(tab => {
    tab.addEventListener("click", () => {
      document.querySelectorAll(".pos-tab").forEach(t => t.classList.remove("active"))
      tab.classList.add("active")
      applyFilter()
    })
  })
}

function setupSearch() {
  document.getElementById("pos-search")?.addEventListener("input", applyFilter)
}

function applyFilter() {
  const catId = document.querySelector(".pos-tab.active")?.dataset.category || ""
  const term  = (document.getElementById("pos-search")?.value || "").toLowerCase().trim()
  document.querySelectorAll(".pos-product-card").forEach(card => {
    const matchCat    = !catId || card.dataset.category === catId
    const matchSearch = !term  || card.dataset.productName.toLowerCase().includes(term)
    card.hidden = !(matchCat && matchSearch)
  })
}

// ── Product cards ─────────────────────────────────────────────
function setupProductCards() {
  document.querySelectorAll(".pos-product-card").forEach(card => {
    card.addEventListener("click", () => {
      addOrIncrement(
        card.dataset.productId,
        card.dataset.productName,
        parseFloat(card.dataset.productPrice)
      )
    })
  })
}

function addOrIncrement(productId, name, price) {
  const existing = document.querySelector(
    `[data-order-item][data-product-id="${productId}"]:not([data-hidden-destroy])`
  )
  if (existing) {
    changeQty(existing, +1)
    existing.scrollIntoView({ behavior: "smooth", block: "nearest" })
    return
  }
  const item = buildCartItem(Date.now(), productId, name, price, 1)
  document.getElementById("order-items").appendChild(item)
  updateSubtotal(item)
  updateTotal()
  updateCartState()
}

function buildCartItem(index, productId, name, price, quantity) {
  const div = document.createElement("div")
  div.className = "cart-item"
  div.dataset.orderItem = ""
  div.dataset.productId = productId
  div.innerHTML = `
    <span class="cart-item__name">${escHtml(name)}</span>
    <div class="cart-item__controls">
      <button type="button" class="qty-btn" data-qty-dec>−</button>
      <input type="number" class="qty-input" value="${quantity}" min="1" data-quantity
             name="order[order_items_attributes][${index}][quantity]">
      <button type="button" class="qty-btn" data-qty-inc>+</button>
    </div>
    <span class="cart-item__subtotal" data-subtotal></span>
    <button type="button" class="btn-icon" data-remove-item title="Remover">×</button>
    <input type="hidden" name="order[order_items_attributes][${index}][product_id]" value="${productId}">
    <input type="hidden" name="order[order_items_attributes][${index}][unit_price]" value="${price}" data-unit-price>
    <input type="hidden" name="order[order_items_attributes][${index}][_destroy]" value="false" data-destroy>
  `
  return div
}

// ── Cart interactions ─────────────────────────────────────────
function setupCart() {
  const items = document.getElementById("order-items")
  if (!items) return

  items.addEventListener("click", e => {
    const item = e.target.closest("[data-order-item]")
    if (!item) return
    if (e.target.closest("[data-qty-dec]"))    changeQty(item, -1)
    else if (e.target.closest("[data-qty-inc]")) changeQty(item, +1)
    else if (e.target.closest("[data-remove-item]")) removeItem(item)
  })

  items.addEventListener("input", e => {
    const item = e.target.closest("[data-order-item]")
    if (item && "quantity" in e.target.dataset) {
      updateSubtotal(item)
      updateTotal()
    }
  })
}

function changeQty(item, delta) {
  const input = item.querySelector("[data-quantity]")
  input.value = Math.max(1, (parseInt(input.value) || 1) + delta)
  updateSubtotal(item)
  updateTotal()
}

function removeItem(item) {
  const destroyField = item.querySelector("[data-destroy]")
  if ("persisted" in item.dataset) {
    destroyField.value = "true"
    item.hidden = true
    item.dataset.hiddenDestroy = ""
  } else {
    item.remove()
  }
  updateTotal()
  updateCartState()
}

// ── Init existing items (edit mode) ───────────────────────────
function initExistingItems() {
  document.querySelectorAll("[data-order-item]").forEach(item => updateSubtotal(item))
  updateTotal()
  updateCartState()
}

// ── Helpers ───────────────────────────────────────────────────
function updateSubtotal(item) {
  const qty   = parseFloat(item.querySelector("[data-quantity]")?.value)  || 0
  const price = parseFloat(item.querySelector("[data-unit-price]")?.value) || 0
  const el    = item.querySelector("[data-subtotal]")
  if (el) el.textContent = formatCurrency(qty * price)
}

function updateTotal() {
  let total = 0
  document.querySelectorAll("[data-order-item]").forEach(item => {
    if (item.querySelector("[data-destroy]")?.value === "true") return
    const qty   = parseFloat(item.querySelector("[data-quantity]")?.value)  || 0
    const price = parseFloat(item.querySelector("[data-unit-price]")?.value) || 0
    total += qty * price
  })
  const el = document.getElementById("order-total-display")
  if (el) el.textContent = formatCurrency(total)
}

function updateCartState() {
  const hasItems = !!document.querySelector("[data-order-item]:not([hidden])")
  const empty    = document.getElementById("cart-empty")
  if (empty) empty.hidden = hasItems
}

function formatCurrency(val) {
  return "R$ " + val.toFixed(2).replace(".", ",")
}

function escHtml(str) {
  return String(str)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
}
