
package business.cart;

import business.book.Book;

public class ShoppingCartItem {

    private Book book;
    private int quantity;

    public ShoppingCartItem(Book book) {
        this.book = book;
        quantity = 1;
    }

    // getter methods

    public long getBookId() {
        return book.getBookId();
    }

    public int getPrice() {
        return book.getPrice();
    }

    public int getQuantity() {
        return quantity;
    }

    public int getTotal() {
        return quantity * getPrice();
    }

    public Book getBook() {
        return book;
    }

    // setter methods

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public void incQuantity() { this.quantity++; }

    public void decQuantity() { this.quantity--; }

    // hasBook method

    public boolean hasBook(Book book) {
        return this.getBookId() == book.getBookId();
    }

    // equals method

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null) return false;
        if (!(o instanceof ShoppingCartItem)) return false;
        ShoppingCartItem that = (ShoppingCartItem) o;
        return this.getBookId() == that.getBookId();
    }

}
