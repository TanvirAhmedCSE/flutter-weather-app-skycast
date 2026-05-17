import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import '../models/weather_model.dart';
import '../widgets/todays_weather.dart';

// Hive box and key used to persist search history locally
const String _kHistoryBox = 'search_history_box';
const String _kHistoryKey = 'queries';

// WeatherAPI autocomplete endpoint for city suggestions while typing
const String _kApiKey = '8920f4b67c1648b797f161236260405';
const String _kAutoCompleteUrl =
    'http://api.weatherapi.com/v1/search.json?key=$_kApiKey&q=';

class SearchScreen extends StatefulWidget {
  // Passed in from HomeScreen so the background matches the current weather
  final Current? currentWeather;

  const SearchScreen({super.key, this.currentWeather});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // Hive box
  late Box _box;
  List<String> _history = [];

  // Autocomplete suggestions
  List<String> _suggestions = [];
  Timer? _debounce;
  bool _isLoadingSuggestions = false;

  @override
  void initState() {
    super.initState();
    _openBoxAndLoad();
    _controller.addListener(_onTextChanged);

    // Auto-focus the search field when the screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  Future<void> _openBoxAndLoad() async {
    _box = await Hive.openBox(_kHistoryBox);
    _loadHistory();
  }

  void _loadHistory() {
    final List<dynamic> raw = _box.get(_kHistoryKey, defaultValue: []) as List;
    setState(() {
      _history = raw.cast<String>();
    });
  }

  // Inserts query at the top, removes duplicates, and caps the list at 20 items
  Future<void> _saveToHistory(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    _history.removeWhere((e) => e.toLowerCase() == trimmed.toLowerCase());
    _history.insert(0, trimmed);

    if (_history.length > 20) _history = _history.sublist(0, 20);

    await _box.put(_kHistoryKey, _history);
    setState(() {});
  }

  Future<void> _deleteFromHistory(int index) async {
    _history.removeAt(index);
    await _box.put(_kHistoryKey, _history);
    setState(() {});
  }

  // Debounces the API call so it only fires 400ms after the user stops typing
  void _onTextChanged() {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _fetchSuggestions(text);
    });
  }

  // Calls the WeatherAPI search endpoint and formats results as "City, Region, Country"
  Future<void> _fetchSuggestions(String query) async {
    if (!mounted) return;
    setState(() => _isLoadingSuggestions = true);

    try {
      final response = await http.get(
        Uri.parse('$_kAutoCompleteUrl${Uri.encodeComponent(query)}'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<String> results = data.map<String>((e) {
          final name = e['name'] ?? '';
          final region = e['region'] ?? '';
          final country = e['country'] ?? '';
          if (region.isNotEmpty) {
            return '$name, $region, $country';
          }
          return '$name, $country';
        }).toList();

        if (mounted) {
          setState(() {
            _suggestions = results;
            _isLoadingSuggestions = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoadingSuggestions = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingSuggestions = false);
    }
  }

  // Saves the query to history and pops the screen, returning the query string
  void _submitSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    _saveToHistory(trimmed);
    Navigator.pop(context, trimmed);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Derive the background type from the weather passed in by HomeScreen
    final weatherType = TodaysWeather.getWeatherType(widget.currentWeather);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.15),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
        title: const Text(
          'Search Location',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
      ),
      body: Stack(
        children: [
          // full height of weather_bg for full screen
          // ── Layer 1: WeatherBg — HomeScreen এর মতো same animated bg ──────
          // Positioned.fill(
          //   child: WeatherBg(
          //     weatherType: weatherType,
          //     width: MediaQuery.of(context).size.width,
          //     height: MediaQuery.of(context).size.height,
          //   ),
          // ),

          // Shifted upward so only the bottom half of the animation is visible
          Positioned(
            left: 0,
            right: 0,
            top: -MediaQuery.of(context).size.height,
            child: WeatherBg(
              weatherType: weatherType,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 2,
            ),
          ),

          // Layer 2: search bar and results or history list
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Glassmorphism search input field
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      textInputAction: TextInputAction.search,
                      onSubmitted: _submitSearch,
                      decoration: InputDecoration(
                        hintText: 'City, region, zip code, coordinates...',
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.35),
                          fontSize: 14,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.search_rounded,
                            color: Colors.white.withValues(alpha: 0.55),
                            size: 20,
                          ),
                        ),
                        // Clear button appears only when text is present
                        suffixIcon: _controller.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _controller.clear();
                                  setState(() => _suggestions = []);
                                },
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: Colors.white.withValues(alpha: 0.55),
                                  size: 18,
                                ),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ),

                // Show autocomplete suggestions while typing, history otherwise
                if (_suggestions.isNotEmpty || _isLoadingSuggestions)
                  _buildSuggestionsBox()
                else
                  _buildHistorySection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Dropdown box that shows live autocomplete results from the API
  Widget _buildSuggestionsBox() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
            width: 1,
          ),
          boxShadow: [
            // BoxShadow(
            //   color: Colors.black.withValues(alpha: 0.25),
            //   blurRadius: 12,
            //   offset: const Offset(0, 6),
            // ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.125),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: _isLoadingSuggestions && _suggestions.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      color: Colors.white54,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _suggestions.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.07),
                ),
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return InkWell(
                    onTap: () => _submitSearch(suggestion),
                    borderRadius: index == _suggestions.length - 1
                        ? const BorderRadius.vertical(
                            bottom: Radius.circular(16),
                          )
                        : BorderRadius.zero,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 16,
                            color: Colors.white.withValues(alpha: 0.40),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildHighlightedText(
                              suggestion,
                              _controller.text.trim(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  // Highlights the typed portion of a suggestion in bold white
  Widget _buildHighlightedText(String fullText, String query) {
    if (query.isEmpty) {
      return Text(
        fullText,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.60),
          fontSize: 14,
        ),
      );
    }

    final lowerFull = fullText.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final matchIndex = lowerFull.indexOf(lowerQuery);

    if (matchIndex == -1) {
      return Text(
        fullText,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.60),
          fontSize: 14,
        ),
      );
    }

    final before = fullText.substring(0, matchIndex);
    final matched = fullText.substring(matchIndex, matchIndex + query.length);
    final after = fullText.substring(matchIndex + query.length);

    return RichText(
      text: TextSpan(
        children: [
          if (before.isNotEmpty)
            TextSpan(
              text: before,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.40),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          TextSpan(
            text: matched,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (after.isNotEmpty)
            TextSpan(
              text: after,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.40),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
    );
  }

  // Shows the Hive-persisted recent searches when the text field is empty
  Widget _buildHistorySection() {
    return Expanded(
      child: _history.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 40,
                    color: Colors.white.withValues(alpha: 0.18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'No recent searches',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.30),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.history_rounded,
                        size: 15,
                        color: Colors.white.withValues(alpha: 0.40),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Recent Searches',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.40),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _history.length,
                    padding: const EdgeInsets.only(bottom: 24),
                    itemBuilder: (context, index) {
                      return _buildHistoryItem(index);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  // Single history row with a clock icon and a delete button on the right
  Widget _buildHistoryItem(int index) {
    final query = _history[index];
    return InkWell(
      onTap: () => _submitSearch(query),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.07),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 16,
                color: Colors.white.withValues(alpha: 0.35),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  query,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _deleteFromHistory(index),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
