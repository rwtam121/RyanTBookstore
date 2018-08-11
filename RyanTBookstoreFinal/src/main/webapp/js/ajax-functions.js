/*!

Create Ajax functions for updating the server

Workflow: works for any other jsp that for our purposes invokes addToCartEvent-->ajaxPost, as ajaxPost is within this javascript.
We would need import a script to see these ajax-fns.js in the category page (or the cart page, if we want to have ajax rather than
 server do the incrementing/decrementing to prevent page refreshes) to see this functions.

Here is the workflow: User clicks the "Add to Cart" button for any book in the category page, the listener for click stores a data object
with the corresponding bookID for that button, and an "action". The reason we have "action" is that previously, in many of our forms we pass
in an "action" hidden parameter, like name="action" value="add" for the category, or clear/change for the cart. So we can store what sort of action
was requested for that particular button. For our case we want the "add" action and the bookID also for AJAX, that's why we have the corresponding
data-action="add" to the server call which was <input type="hidden" name="action" value="add">

 Then, it invokes ajaxPost here  [ajaxPost('category', data, function(text, xhr) ]
which takes in the url pattern from our servlets
(in our case here, "category", but can also be "cart" if we want to increment/decrement those values). it also takes in the data object and the
addToCallBack fn which takes in text contents for cart count. If everything is good, ajaxPost first invokes this callback which gets the cartCount number.

Then, XML request initiates a post  request for the category, setting header metadata
 and then we invoke the second part below--the encoded form data where as long as the data object exists, we read
in each of the fields (the bookID and the action) i.e,. {name: "John Smith", age: "47"} becomes name=John%20Smith&age=47 so this is a data string that can be used in
a post request. {NOTE: This is similar to the categoryServlet's post request which takes the in the /category and adds the book to the shopping cart--here we use AJAX
to get the bookID to add the book as well to the cart).


-----

Dr. K notes in Project 10:
The "if" conditions in this function are just guarding against invalid input.

The "ajaxPost" function will look familiar if you read the W3Schools site regarding Ajax. The callback function is invoked when everything goes well.
In the case of our add-to-cart buttons, the callback will eventually be processed by "addToCartCallback". Notice that the "open" function has a POST argument and the
"send" function passes along the encoded data. The "url" value will typically be a URL pattern that is caught by one of our servlets. For example, in the case of
the add-to-cart button, it will either by "category" or "cart" depending on which servlet you decided to process the form in.

The header settings we use here are important. By convention, "X-Requested-With" is included in the header whenever an Ajax call is made.
It lets the server know that Ajax is being used. The content type being passed to the server is "x-www-form-urlencoded". That is the case
whenever you have content of the form name1=value1&name2=value2&... Finally, the client expects the server to respond with a JSON string.

 */


function encodeFormData(data) {
    if (!data) return '';
    if (typeof data !== 'object') return '';
    var encodedData = '';
    for (field in data) {
        if (!data.hasOwnProperty(field)) continue;
        encodedData += '&' + encodeURIComponent(field)
            + '=' + encodeURIComponent(data[field]);
    }
    return encodedData.slice(1);
}

/*! callback is the addToCartCallback which gets the response text and sets the headers and allows
* us to get the headers and encoded data back in the form of an alert
*
* moreover, since we are using javascript XML xhr.open invokes 'POST' with our category tag, and since we have the action "add"
* embedded in the data, then we can parse the bookId and add the book item in as well. All this would be done without reloading the page,
* since we are just sending a post command rather than going directly into the servlet and back to the category page like previous
*(have access to catServlet POST without going in directly)
*
* clicking the Ajax add-to-cart button should cause your cart to be updated just as if you clicked on the original add-to-cart button,
* because both buttons are passing the same information to the servlet and are being handled in the exact same way.
*
* Tested 7/30 couldn't find ajax in the readyState or status
* */

function ajaxPost(url, data, callback) {
    var xhr = new XMLHttpRequest();
    //alert("Hmmm")
    xhr.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            callback(xhr.responseText, xhr);
        }
    };
    xhr.open('POST', url);
    xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.send(encodeFormData(data));
}
