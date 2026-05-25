class OrderMailer < ApplicationMailer
  def order_ready(order)
    @order = order
    mail(to: order.customer.email, subject: "Seu pedido ##{order.id} está pronto!")
  end
end
