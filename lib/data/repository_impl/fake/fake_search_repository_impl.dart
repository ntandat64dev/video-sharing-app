import 'dart:math';

import 'package:video_sharing_app/domain/entity/category.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/entity/user.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/repository/search_repository.dart';

class FakeSearchRepositoryImpl implements SearchRepository {
  @override
  Future<PageResponse> search({required String keyword, String? sort, String? type, Pageable? pageable}) async {
    return PageResponse(
      pageNumber: 0,
      pageSize: 10,
      totalElements: 10,
      totalPages: 1,
      items: [
        Video(
          id: Random().nextInt(16).toRadixString(16),
          publishedAt: DateTime.now(),
          userId: Random().nextInt(16).toRadixString(16),
          username: 'fakeuser',
          userImageUrl:
              'https://ui-avatars.com/api/?name=Fake+User&size=500&background=0D8ABC&color=fff&rouded=true&bold=true',
          title: 'Best Video Ever!',
          description: null,
          videoUrl: 'videoUrl',
          thumbnails: {
            Thumbnail.kDefault: const Thumbnail(
              url: 'https://dummyimage.com/720x450/fff/aaa',
              width: 720,
              height: 450,
            )
          },
          hashtags: ['music', 'sport', 'football'],
          duration: 'PT50M',
          location: null,
          category: Category(id: Random().nextInt(16).toRadixString(16), category: 'Music'),
          privacy: 'public',
          madeForKids: false,
          ageRestricted: false,
          commentAllowed: true,
          viewCount: BigInt.zero,
          likeCount: BigInt.zero,
          dislikeCount: BigInt.zero,
          commentCount: BigInt.zero,
          downloadCount: BigInt.zero,
        ),
        User(
          id: Random().nextInt(16).toRadixString(16),
          email: 'fakeuser@gmail.com',
          dateOfBirth: null,
          phoneNumber: null,
          gender: null,
          country: null,
          username: 'fakeuser',
          bio: null,
          publishedAt: DateTime.now(),
          thumbnails: {
            Thumbnail.kDefault: const Thumbnail(
              url:
                  'https://ui-avatars.com/api/?name=Fake+User&size=500&background=0D8ABC&color=fff&rouded=true&bold=true',
              width: 500,
              height: 500,
            )
          },
          roles: ['ROLE_USER'],
          viewCount: BigInt.zero,
          followerCount: BigInt.zero,
          followingCount: BigInt.zero,
          videoCount: BigInt.zero,
        )
      ],
    );
  }
}
