
class Boarding {
  
  final String title;
  final String body;
  final String image;

  Boarding({
    required this.title,
    required this.body,
    required this.image,
  });
  
 }


 List<Boarding> boarding_data = [
  Boarding(
    title: 'Effortless Ordering',
    body: 'Order fresh produce and snacks effortlessly. Perfect for events, businesses, or stocking up for your needs.',
    image: 'assets/images/sc1.jpg', // Update with the actual image path
  ),
  Boarding(
    title: 'Flexible Packaging Options',
    body: 'Choose from a range of packaging options to suit your needs. Whether it\'s bulk quantities or specialty items, we’ve got packaging that keeps your items fresh and secure.',
    image: 'assets/images/sc2.jpg', // Update with the actual image path
  ),
  Boarding(
    title: 'Secure & Convenient Payments',
    body: 'Pay securely with multiple payment methods. Enjoy a hassle-free checkout experience every time.',
    image: 'assets/images/sc3.jpg', // Update with the actual image path
  ),
  
];
