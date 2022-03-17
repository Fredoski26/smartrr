import 'package:flutter/material.dart';
import 'package:smartrr/components/widgets/list_item.dart';
import 'package:smartrr/components/widgets/text_heading.dart';
import 'package:smartrr/components/widgets/text_paragraph.dart';
import 'package:smartrr/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class AllAboutSmartRR extends StatelessWidget {
  AllAboutSmartRR({Key key}) : super(key: key);

  final TextStyle _headingStyle = TextStyle().copyWith(
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  @override
  Widget build(BuildContext context) {
    final _language = S.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(_language.allAboutSRHR)),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextHeading(
                  text:
                      "Sexual Reproductive Health and Rights (SRHR) CONTENTS"),
              TextParagraph(
                  text:
                      "Young girls and women  are viewed as too youthful to even think about approaching sexuality schooling and family planning or in any event, discussing it, yet in many spots and around us they are getting hitched, getting pregnant, conceiving an offspring and are moms."),
              TextHeading(
                  text:
                      "Key definitions of Sexual Reproductive Health and Rights components"),
              TextHeading(text: "key messages".toUpperCase()),
              TextParagraph(
                  text:
                      "Access to modern contraception and reproductive health, including access to safe abortion, is an essential aspect of gender equality, economic development, humanitarian response,and progress for all."),
              TextParagraph(
                  text:
                      "For a girl or a woman to reach their greatest potential, they must have control over their sexual and reproductive lives."),
              TextParagraph(
                  text:
                      "Gender equality can be achieved when women and girls  sexual health and rights are respected,protected, and accessed."),
              TextParagraph(
                  text:
                      "A world without fear, stigma, or discrimination drives equality and progress for all."),
              TextParagraph(
                  text:
                      "To fulfill women and girls Sexual Reproductive Health and Rights (SRHR), adolescents and women in reproductive age must have the knowledge, skills, and tools needed to make safe and informed decisions."),
              TextHeading(
                  text: "Sexual Reproductive Health and Rights Definitions"),
              ListItem(
                  label: "A",
                  body:
                      "Is a state of physical, emotional,  mental, and social wellbeing in relation to sexual feelings, considerations, attractions and practices towards others Sexuality. It encompasses the possibility of pleasurable and safe sexual experiences, free of coercion, discrimination, and violence. For sexual health to be attained and maintained, the sexual rights of all persons must be respected, protected, and fulfilled"),
              Text("Sexual health include:"),
              ListItem(
                  body:
                      "Counselling and care related to sexuality, sexual identity, and sexual relationships"),
              ListItem(
                  body:
                      "Prevention and management of sexually transmitted infections (STIs)"),
              ListItem(
                  body:
                      "Psychosexual counselling, and treatment for sexual dysfunction and disorders"),
            ],
          ),
        ),
      ),
      // body: Center(
      //   child: ElevatedButton(
      //     onPressed: () async {
      //       await launch(
      //         "https://docs.google.com/document/d/170XeWJLKtTo2GOufFgnhqqmZ1tFyfoAv/edit?usp=sharing&ouid=102250998567041919901&rtpof=true&sd=true",
      //         forceWebView: true,
      //       );
      //     },
      //     child: Text("Open"),
      //   ),
      // ),
    );
  }
}
