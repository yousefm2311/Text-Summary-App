import 'package:get/get.dart';
import 'package:text_summary_edit/model/team_model.dart';

class WebViewModel extends GetxController {
  List<InfoModel> data = [
    InfoModel(
      image: 'assets/images/me.jpg',
      name: 'Yousef Mohamed',
      description: 'Flutter Developer & UI/UX Design',
      count: '1',
      linkGitHub: 'https://github.com/yousefm2311',
    ),
    InfoModel(
      image: 'assets/images/mok.jpg',
      name: 'Mahmoud Okaily',
      description:
          'Mahmoud Elokaily is a highly skilled full stack developer with expertise in front-end and back-end technologies. With 1 years of experience, Mahmoud delivers innovative and robust web applications while staying up-to-date with the latest industry trends. His strong problem-solving abilities and effective collaboration make him a valuable asset to any development team.',
      count: '2',
      linkGitHub: 'https://github.com/MahmoudElokaily',
    ),
    InfoModel(
      image: 'assets/images/aref.jpg',
      name: 'Mohamed Aref',
      description: 'ML & Fullstack Devolper',
      count: '3',
      linkGitHub: 'https://github.com/mohmedaref1',
    ),
    InfoModel(
      image: 'assets/images/wael.jpg',
      name: 'Mohamed Wael',
      description:
          'A Full-Stack Web Devoleper Able to use html - Css - Bootstarp - jquery - JS - MySQL - Laravel - PHP languages',
      count: '4',
      linkGitHub: 'https://github.com/MohamedWael200',
    ),
    InfoModel(
      image: 'assets/images/omara.jpg',
      name: 'Abdelrahman Omara',
      description: 'Android Developer & Cyber security & Django Developer',
      count: '5',
      linkGitHub: 'https://github.com/Abdalrahmanomara',
    ),
    InfoModel(
      image: 'assets/images/mariam.jpg',
      name: 'Mariam abdelkhalek',
      description:
          'studed computer science and now i taking ui/ux course and hope i will make muster in the next year in Ai',
      count: '6',
      linkGitHub: 'https://github.com/mariamabdelkhalik',
    ),
  ];
}
