
package business.cart;

import business.book.Book;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ShoppingCart {

    //also create a fixed surcharge value here in the ShoppingCart
    //take out static and final so we can generate a setter to change the surcharge
    //alt+insert to generate getter and setters
    //make it int because DefaultOrderService takes in surcharge+ subtotal as an int (subtotal was already an int we just converted it to currency form
    private int surcharge= 5;

    public final int maxQuantity = 10;

    public int getSurcharge() {
        return surcharge;
    }

    public void setSurcharge(int surcharge) {
        this.surcharge = surcharge;
    }


    List<ShoppingCartItem> items;

    public ShoppingCart() {
        items = new ArrayList<ShoppingCartItem>();
    }

    /**
     * Adds an item (book + quantity) to the cart.
     * If the book is already in the cart, increments
     * the quantity.
     *
     * @param book
     */
    public synchronized void addItem(Book book) {

        if (bookInCart(book)) {
            increment(book);
        } else {
            ShoppingCartItem item = new ShoppingCartItem(book);
            items.add(item);
        }
    }

    /**
     * Updates the item to the specified quantity.
     * If the quantity is 0 the book is removed.
     * The cart is unchanged if:
     * - the quantity is less than 0
     * - the quantity is greater than the max
     * - the book is not in the cart
     *
     * @param book
     * @param quantity
     */
    public synchronized void update(Book book , int quantity) {

        ShoppingCartItem item = findItem(book);

        if (item == null || quantity < 0 || quantity > maxQuantity) {
            return;
        }

        if (quantity == 0) {
            items.remove(item);
        } else {
            item.setQuantity(quantity);
        }
    }

    /**
     * Increments the quantity of the item with the book.
     *
     * @param book
     */
    public synchronized void increment(Book book) {

        ShoppingCartItem item = findItem(book);

        if (item == null || item.getQuantity() == maxQuantity) {
            return;
        }

        item.setQuantity(item.getQuantity() + 1);
    }

    /**
     * Decrements the quantity of the item with the book.
     *
     * @param book
     */
    public synchronized void decrement(Book book) {

        ShoppingCartItem item = findItem(book);

        if (item == null || item.getQuantity() == 0) {
            return;
        }

        if (item.getQuantity() == 1) {
            items.remove(item);
        } else {
            item.setQuantity(item.getQuantity() - 1);
        }
    }

    /**
     * Returns the list of items.
     *
     * @return
     */
    public synchronized List<ShoppingCartItem> getItems() {
        return items;
    }

    /**
     * Returns the sum of quantities for all items in the cart.
     *
     * @return
     */
    public synchronized int getNumberOfItems() {
        return items.stream()
                .mapToInt(ShoppingCartItem::getQuantity)
                .sum();
    }

    /**
     * Returns the sum of the book price multiplied by the quantity for all
     * items in shopping cart list. This is the total cost *in cents*,
     * not including the surcharge.
     *
     * @return
     */
    public synchronized int getSubtotal() {
        return items.stream()
                .mapToInt(item -> item.getQuantity() * item.getPrice())
                .sum();
    }

    /**
     * Empties the shopping cart.
     */
    public synchronized void clear() {
        items.clear();
    }

    private boolean bookInCart(Book book) {
        return items.stream().anyMatch(item -> item.hasBook(book));
    }

    private ShoppingCartItem findItem(Book book) {
        Optional<ShoppingCartItem> optItem = items.stream()
                .filter(item -> item.hasBook(book))
                .findFirst();
        return optItem.orElse(null);
    }
}
