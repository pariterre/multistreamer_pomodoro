import 'package:flutter/material.dart';

class ThankingPage extends StatelessWidget {
  const ThankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('REMERCIMENTS', style: Theme.of(context).textTheme.titleLarge),
        const Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),
                Text('Un immense merci aux coanimatrices et coanimateurs de '
                    'l\'événement. Honnêtement, je suis sans mots face à la '
                    'confiance et l\'accueil que vous portez à ce projet. '
                    'Ça me touche sincèrement. Merci!'),
                SizedBox(height: 12),
                Text('Un merci tout particulier pour Le_Sketch, qui a '
                    'gracieusement offert le travail artistique pour l\'événement '
                    'et le site web. Si ce n\'eut été de lui et de son graphiste Francis, '
                    'vous ne seriez pas sur un si beau site web!'),
                SizedBox(height: 12),
                Text('Je tiens également à remercier les coanimateurs '
                    'et coanimatrices qui ont généreusement (et spontanément) '
                    'offert des prix pour les prix de participation :'),
                Padding(
                  padding: EdgeInsets.only(left: 18.0),
                  child: Text(
                    '\u2022 elidelivre\n'
                    '\u2022 LizEMyers\n'
                    '\u2022 MemepAuteure\n'
                    '\u2022 WayceUpenFoya',
                  ),
                ),
                SizedBox(height: 12),
                Text(
                    'Finalement, un grand merci à tous les auditeurs et toutes '
                    'les auditrices pour votre présence et votre support, que '
                    'ce soit pendant ou à l\'extérieur de l\'événement. Vous '
                    'êtes tellement importants et importantes pour nous, vous '
                    'êtes notre motivation. Un grand merci à chacun et chacune '
                    'd\'entre vous \u2665'),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
