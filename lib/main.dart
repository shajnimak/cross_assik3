import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _location = 'New York'; // Default value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: WeatherBody(location: _location, onRefresh: _fetchWeather),
    );
  }

  void _fetchWeather(String newLocation) {
    setState(() {
      _location = newLocation;
    });
  }

  void refreshWeather() {
    
    _fetchWeather(_location);
  }
}

class WeatherBody extends StatelessWidget {
  final String location;
  final Function(String) onRefresh;

  const WeatherBody({
    super.key,
    required this.location,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const WeatherIcon(),
          const SizedBox(height: 20),
          Text(
            '25°C',
            style: TextStyle(
              fontSize: screenSize.width * 0.08,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Sunny',
            style: TextStyle(
              fontSize: screenSize.width * 0.05,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter location',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                  },
                ),
              ),
              onSubmitted: onRefresh,
            ),
          ),
          const SizedBox(height: 20),
          AnimatedRefreshButton(onTap: () => onRefresh(location), onRefreshButtonTap: () {
            onRefresh(location);
          }),
        ],
      ),
    );
  }
}

class WeatherIcon extends StatefulWidget {
  const WeatherIcon({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WeatherIconState createState() => _WeatherIconState();
}

class _WeatherIconState extends State<WeatherIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 2 * 3.141592).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value,
          child: const Icon(
            Icons.wb_sunny,
            size: 100,
            color: Colors.yellow,
          ),
        );
      },
    );
  }
}

class AnimatedRefreshButton extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onRefreshButtonTap;

  const AnimatedRefreshButton({
    super.key,
    required this.onTap,
    required this.onRefreshButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              'Refresh',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
