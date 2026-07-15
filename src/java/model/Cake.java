package model;

public class Cake {
    private int id;
    private String number;
    private String code;
    private String name;
    private String description;
    private String tag;
    private double rating;
    private double price;
    private String imageFile;
    private String ingredients;

    // Required blank bean constructor
    public Cake() {}

    // Master parameterized constructor mapped inside our Servlet's Doppler loop block
    public Cake(int id, String number, String code, String name, String description, String tag, double rating, double price, String imageFile, String ingredients) {
        this.id = id;
        this.number = number;
        this.code = code;
        this.name = name;
        this.description = description;
        this.tag = tag;
        this.rating = rating;
        this.price = price;
        this.imageFile = imageFile;
        this.ingredients = ingredients;
    }

    // Explicit Property Accessement Getters
    public int getId() { return id; }
    public String getNumber() { return number; }
    public String getCode() { return code; }
    public String getName() { return name; }
    public String getDescription() { return description; }
    public String getTag() { return tag; }
    public double getRating() { return rating; }
    public double getPrice() { return price; }
    public String getImageFile() { return imageFile; }
    public String getIngredients() { return ingredients; }
}