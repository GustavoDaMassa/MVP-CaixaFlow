import "@hotwired/turbo-rails"
import "controllers"
import { initOrderForm } from "order_form"

document.addEventListener("turbo:load", initOrderForm)
