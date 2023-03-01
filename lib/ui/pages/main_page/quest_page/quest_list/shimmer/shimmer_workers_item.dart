import 'package:app/ui/widgets/shimmer.dart';
import 'package:flutter/material.dart';

class ShimmerWorkersItem extends StatelessWidget {
  const ShimmerWorkersItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.stand(
                child: Container(
                  height: 61,
                  width: 61,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Shimmer.stand(
                      child: Container(
                        height: 20,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Shimmer.stand(
                        child: Container(
                          height: 20,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Shimmer.stand(
                      child: Container(
                        height: 20,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.stand(
                child: Container(
                  height: 20,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Wrap(children: [
                Shimmer.stand(
                  child: Container(
                    height: 20,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Shimmer.stand(
                  child: Container(
                    height: 20,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Shimmer.stand(
                  child: Container(
                    height: 20,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: Colors.white,
                    ),
                  ),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 15),
          Shimmer.stand(
            child: Container(
              height: 20,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Shimmer.stand(
            child: Container(
              height: 20,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 10),
          Shimmer.stand(
            child: Container(
              height: 20,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Shimmer.stand(
            child: Container(
              height: 20,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
