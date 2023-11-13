import 'package:flutter/material.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreen();
}

class _QuotesScreen extends State<QuotesScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Align(
          alignment: Alignment.topCenter,
          child: Padding(
              padding: EdgeInsets.fromLTRB(50, 80, 0, 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Quotes",
                    style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'PTSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )),
        ),
        Align(
            alignment: Alignment.topCenter,
            child: Image.asset('assets/images/up.png')),
        Expanded(
            child: Align(
          alignment: Alignment.center, //const Alignment(0.0, -0.4),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      '“',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 90.0),
                    child: SizedBox(
                      height: 120,
                      child: Center(
                        child: Text(
                          "Embrace each challenge as an opportunity to discover the strength within you. Your journey may be tough, but every step forward is a triumph. Believe in your capabilities, for you possess the power to turn dreams into reality.",
                          maxLines: 7,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      '”',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
        Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset('assets/images/down.png')),
      ],
    ));
  }
}
