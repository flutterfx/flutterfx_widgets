import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:math';

class SpringAnimationsDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spring Animations Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // SpringButton(
            //   onPressed: () => _showAnimation(context, 'Springy'),
            //   curve: SpringyCurve(),
            //   child: Text('Springy', style: TextStyle(fontSize: 18)),
            // ),
            // SpringButton(
            //   onPressed: () => _showAnimation(context, 'Shock Absorber'),
            //   curve: ShockAbsorberCurve(),
            //   child: Text('Shock Absorber', style: TextStyle(fontSize: 18)),
            // ),
            // SpringButton(
            //   onPressed: () => _showAnimation(context, 'Quick Bounce'),
            //   curve: QuickBounceCurve(),
            //   child: Text('Quick Bounce', style: TextStyle(fontSize: 18)),
            // ),
            // SpringButton(
            //   onPressed: () => _showAnimation(context, 'Snappy Spring'),
            //   curve: SnappySpringCurve(),
            //   child: Text('Snappy Spring', style: TextStyle(fontSize: 18)),
            // ),
            // SpringButton(
            //   onPressed: () => _showAnimation(context, 'Elastic Snap'),
            //   curve: ElasticSnapCurve(),
            //   child: Text('Elastic Snap', style: TextStyle(fontSize: 18)),
            // ),

            SpringButton(
              onPressed: () => _showAnimation(context, 'High Velocity Spring'),
              curve: HighVelocitySpringCurve(),
              child:
                  Text('High Velocity Spring', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  void _showAnimation(BuildContext context, String animationName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$animationName animation triggered!'),
        duration: Duration(milliseconds: 500),
      ),
    );
  }
}

class SpringButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Curve curve;

  SpringButton({
    required this.child,
    required this.onPressed,
    required this.curve,
  });

  @override
  _SpringButtonState createState() => _SpringButtonState();
}

class _SpringButtonState extends State<SpringButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
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
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateZ((math.sin(_animation.value * math.pi) *
                0.5)), //(_animation.value *math.pi), //,
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () {
              print("rotate pressed");
              _controller.forward(from: 0);
              widget.onPressed();
            },
            child: Padding(
              padding: EdgeInsets.all(12),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

// Spring animation curves (same as before)
class SpringyCurve extends Curve {
  @override
  double transform(double t) {
    return -math.pow(2.718281828, -8 * t) * math.cos(t * 12) + 1;
  }
}

class ShockAbsorberCurve extends Curve {
  @override
  double transform(double t) {
    return 1 - math.pow(1 - t, 3) * math.cos(t * math.pi * 2.5);
  }
}

class QuickBounceCurve extends Curve {
  @override
  double transform(double t) {
    return 1 - math.pow(1 - t, 8) - math.sin(t * math.pi) * 0.1;
  }
}

class SnappySpringCurve extends Curve {
  @override
  double transform(double t) {
    return t * t * (3 - 2 * t) + math.sin(t * math.pi * 3) * 0.1 * (1 - t);
  }
}

class ElasticSnapCurve extends Curve {
  @override
  double transform(double t) {
    return t * t * (3 - 2 * t) - math.sin(t * math.pi * 2) * 0.1 * (1 - t);
  }
}

//----

// 2. Less springy version
class LessSpringySnappyCurve extends Curve {
  @override
  double transform(double t) {
    return t * t * (3 - 2 * t) + sin(t * pi * 2) * 0.05 * (1 - t);
  }
}

// 3. Heavier mass simulation
class HeavyMassSnappyCurve extends Curve {
  @override
  double transform(double t) {
    return t * t * (3 - 2 * t) + sin(t * pi * 1.5) * 0.08 * (1 - t * t);
  }
}

// 4. Quick start, slow end
class QuickStartSlowEndCurve extends Curve {
  @override
  double transform(double t) {
    return t * t * (3 - 2 * t) + sin(t * pi) * 0.1 * (1 - pow(t, 3));
  }
}

// 5. Damped oscillation
class DampedOscillationCurve extends Curve {
  @override
  double transform(double t) {
    return t - sin(t * pi * 2) * 0.1 * exp(-2 * t);
  }
}

// 6. Soft bounce
class SoftBounceCurve extends Curve {
  @override
  double transform(double t) {
    return t * t * (3 - 2 * t) - sin(t * pi) * 0.05 * (1 - t);
  }
}

// 7. Delayed snap
class DelayedSnapCurve extends Curve {
  @override
  double transform(double t) {
    return t < 0.5
        ? 2 * t * t
        : 1 - pow(-2 * t + 2, 2) / 2 + sin(t * pi) * 0.05;
  }
}

// 8. Gradual acceleration
class GradualAccelerationCurve extends Curve {
  @override
  double transform(double t) {
    return t * t * t + sin(t * pi * 2) * 0.03 * (1 - t);
  }
}

// 9. Elastic-like with less oscillation
class MildElasticCurve extends Curve {
  @override
  double transform(double t) {
    return pow(2, -8 * t) * sin((t - 0.1) * pi * 2) * 0.5 + 1;
  }
}

// 10. Smooth overshoot

class HeavyMassBaseCurve extends Curve {
  @override
  double transform(double t) {
    return t * t * (3 - 2 * t) + sin(t * pi * 2) * 0.1 * (1 - t);
  }
}

// Slow Start Heavy Mass
class SlowStartHeavyMassCurve extends Curve {
  @override
  double transform(double t) {
    return pow(t, 3) + sin(t * pi) * 0.1 * (1 - t);
  }
}

// Overshoot Heavy Mass
class OvershootHeavyMassCurve extends Curve {
  @override
  double transform(double t) {
    return t < 0.6
        ? 1.3 * t
        : 1 + sin((t - 0.6) * pi * 2.5) * 0.15 * pow(1 - t, 2);
  }
}

// Bouncy Heavy Mass
class BouncyHeavyMassCurve extends Curve {
  @override
  double transform(double t) {
    return t < 0.5
        ? 4 * t * t * t
        : 1 - pow(-2 * t + 2, 3) / 2 + sin(t * pi * 3) * 0.1 * (1 - t);
  }
}

class HighVelocitySpringCurve extends Curve {
  final double a;
  final double w;

  HighVelocitySpringCurve({this.a = 0.3, this.w = 20});

  @override
  double transform(double t) {
    // Rapid initial movement
    double initialMovement = (1 - pow(1 - t, 3)).toDouble();

    // Small spring back effect
    double springBack = sin(t * w) * a * pow(1 - t, 2);

    return initialMovement - springBack;
  }
}
