package viewmodel;
import javax.servlet.http.HttpServletRequest;


public class CartViewModel extends BaseViewModel {

    /**
     Create a cart viewmodel class called CartViewModel that extends BaseViewModel.
     Super sets up the request in the base view model.
     */



    public CartViewModel(HttpServletRequest request) {
        super(request);
    }
}
