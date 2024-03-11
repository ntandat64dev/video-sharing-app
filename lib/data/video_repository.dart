import 'package:video_sharing_app/domain/video.dart';

abstract class VideoRepository {
  Future<List<Video>> getVideos();
}

class VideoRepositoryImpl implements VideoRepository {
  @override
  Future<List<Video>> getVideos() async {
    Future.delayed(const Duration(seconds: 2));
    return [
      Video(
        id: 1,
        title: 'Big Buck Bunny and A Little Cute of Big Car with a Aggressive Man Big Buck Bunny and A Little Cute of Big Car with a Aggressive Man',
        description:
            'Big Buck Bunny tells the story of a giant rabbit with a heart bigger than himself. When one sunny day three rodents rudely harass him, something snaps... and the rabbit ain\'t no bunny anymore! In the typical cartoon tradition he prepares the nasty rodents a comical revenge.\n\nLicensed under the Creative Commons Attribution license\nhttp://www.bigbuckbunny.org',
        thumbnail: 'https://i.easil.com/wp-content/uploads/20210901120345/Teal-White-Tech-Design-with-white-person-outline-youtube-thumbnail-2.jpg',
        url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      ),
      Video(
        id: 2,
        title: 'Elephant Dream',
        description: 'The first Blender Open Movie from 2006',
        thumbnail: 'https://i.easil.com/wp-content/uploads/20210901120345/Teal-White-Tech-Design-with-white-person-outline-youtube-thumbnail-2.jpg',
        url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      ),
      Video(
        id: 3,
        title: 'For Bigger Blazes',
        description:
            'HBO GO now works with Chromecast -- the easiest way to enjoy online video on your TV. For when you want to settle into your Iron Throne to watch the latest episodes. For \$35.\nLearn how to use Chromecast with HBO GO and more at google.com/chromecast.',
        thumbnail: 'https://i.easil.com/wp-content/uploads/20210901120345/Teal-White-Tech-Design-with-white-person-outline-youtube-thumbnail-2.jpg',
        url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      ),
      Video(
        id: 4,
        title: 'For Bigger Escape',
        description:
            'Introducing Chromecast. The easiest way to enjoy online video and music on your TV—for when Batman\'s escapes aren\'t quite big enough. For \$35. Learn how to use Chromecast with Google Play Movies and more at google.com/chromecast.',
        thumbnail: 'https://i.easil.com/wp-content/uploads/20210901120345/Teal-White-Tech-Design-with-white-person-outline-youtube-thumbnail-2.jpg',
        url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      ),
      Video(
        id: 5,
        title: 'For Bigger Fun',
        description:
            'Introducing Chromecast. The easiest way to enjoy online video and music on your TV. For \$35.  Find out more at google.com/chromecast.',
        thumbnail: 'https://i.easil.com/wp-content/uploads/20210901120345/Teal-White-Tech-Design-with-white-person-outline-youtube-thumbnail-2.jpg',
        url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
      ),
      Video(
        id: 6,
        title: 'For Bigger Joyrides',
        description:
            'Introducing Chromecast. The easiest way to enjoy online video and music on your TV—for the times that call for bigger joyrides. For \$35. Learn how to use Chromecast with YouTube and more at google.com/chromecast.',
        thumbnail: 'https://i.easil.com/wp-content/uploads/20210901120345/Teal-White-Tech-Design-with-white-person-outline-youtube-thumbnail-2.jpg',
        url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
      ),
      Video(
        id: 7,
        title: 'For Bigger Meltdowns',
        description:
            'Introducing Chromecast. The easiest way to enjoy online video and music on your TV—for when you want to make Buster\'s big meltdowns even bigger. For \$35. Learn how to use Chromecast with Netflix and more at google.com/chromecast.',
        thumbnail: 'https://i.easil.com/wp-content/uploads/20210901120345/Teal-White-Tech-Design-with-white-person-outline-youtube-thumbnail-2.jpg',
        url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
      ),
      Video(
        id: 8,
        title: 'Sintel',
        description:
            'Sintel is an independently produced short film, initiated by the Blender Foundation as a means to further improve and validate the free/open source 3D creation suite Blender. With initial funding provided by 1000s of donations via the internet community, it has again proven to be a viable development model for both open 3D technology as for independent animation film.\nThis 15 minute film has been realized in the studio of the Amsterdam Blender Institute, by an international team of artists and developers. In addition to that, several crucial technical and creative targets have been realized online, by developers and artists and teams all over the world.\nwww.sintel.org',
        thumbnail: 'https://i.easil.com/wp-content/uploads/20210901120345/Teal-White-Tech-Design-with-white-person-outline-youtube-thumbnail-2.jpg',
        url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
      ),
      Video(
        id: 9,
        title: 'Subaru Outback On Street And Dirt',
        description:
            'Smoking Tire takes the all-new Subaru Outback to the highest point we can find in hopes our customer-appreciation Balloon Launch will get some free T-shirts into the hands of our viewers.',
        thumbnail: 'https://i.easil.com/wp-content/uploads/20210901120345/Teal-White-Tech-Design-with-white-person-outline-youtube-thumbnail-2.jpg',
        url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4',
      ),
    ];
  }
}