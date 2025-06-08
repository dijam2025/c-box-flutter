import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../widgets/category_tab_bar.dart';
import '../widgets/post_card.dart';
import '../widgets/hot_post_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/custom_app_bar_title.dart';
import '../screens/post_detail_page.dart';
import '../screens/post_create_page.dart';
import 'rental_status_page.dart';

class MissionHome extends StatefulWidget {
  const MissionHome({super.key});

  @override
  State<MissionHome> createState() => _MissionHomeState();
}

class _MissionHomeState extends State<MissionHome> {
  final List<Map<String, dynamic>> posts = [
    {
      'author': '가나디',
      'category': '수업',
      'title': '이산구조 시험 언제임?',
      'comments': 3,
      'createdAt': DateTime.now().subtract(const Duration(minutes: 30)),
      'content': '컴공 이산구조 01분반 시험 언제임?'
    },
    {
      'author': '사용자',
      'category': '요청',
      'title': '공대 3층 화장실에 휴지가 없어요 ㅜㅜㅜ',
      'comments': 1,
      'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
      'content':'공대 3층 여자화장실 휴지 가져다주실 분 구합니다. 사례금 드릴게요 제발요 ㅠㅜㅠㅜ'
    },
  ];

  void updateComments(int index, int newCount) {
    setState(() {
      posts[index]['comments'] = newCount;
    });
  }

  void _navigateToCreatePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PostCreatePage()),
    );

    if (!mounted) return;

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        posts.insert(0, result);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('게시물이 등록되었습니다!')),
      );
    }
  }

  void _onBottomTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RentalStatusPage()),
      );
    }
    // index == 1은 현재 페이지, 아무 동작 X
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBarTitle(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: MainContent(
        posts: posts,
        updateComments: updateComments,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreatePage,
        backgroundColor: Colors.indigo,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // ✅ 하단바 추가
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: _onBottomTapped,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: '한남렌탈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '미션스쿨',
          ),
        ],
      ),
    );
  }
}

class MainContent extends StatefulWidget {
  final List<Map<String, dynamic>> posts;
  final void Function(int index, int newCount) updateComments;

  const MainContent({
    super.key,
    required this.posts,
    required this.updateComments,
  });

  @override
  State<MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  late List<Map<String, dynamic>> filteredPosts;

  @override
  void initState() {
    super.initState();
    filteredPosts = widget.posts;
  }

  void _onSearchFiltered(List<Map<String, dynamic>> result) {
    setState(() {
      filteredPosts = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = context.watch<CategoryProvider>().selected;

    final hotPosts = [
      {
        'title': '디버깅 중 잠시만요',
        'subtitle': '댓글 12',
        'category': '요청',
        'author': '익명1',
        'content': '디버깅 12시간 째 실화냐?'
      },
      {
        'title': '자바 스터디 하실 분 구합니다',
        'subtitle': '댓글 8',
        'category': '스터디',
        'author': '김자바',
        'content': '자바 중급 스터디 할 사람 DM 주세요~'
      },
      {
        'title': '3-5시 충전기 빌려주실 분?',
        'subtitle': '댓글 20',
        'category': '요청',
        'author': '배터리0퍼',
        'content': '아이폰 충전기 빌릴 수 있을까요? 3-5시까지 급합니다!'
      },
    ];

    // ✅ 선택된 카테고리에 따라 필터링
    final categoryFiltered = selectedCategory == '전체'
        ? filteredPosts
        : filteredPosts.where((post) => post['category'] == selectedCategory).toList();

    return Column(
      children: [
        SizedBox(
          height: 140,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: hotPosts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, idx) {
              final post = hotPosts[idx];
              return HotPostCard(
                title: post['title']!,
                subtitle: post['subtitle']!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostDetailPage(
                        title: post['title']!,
                        category: post['category']!,
                        author: post['author']!,
                        content: post['content']!,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // ✅ 검색창 적용!
        CustomSearchBar<Map<String, dynamic>>(
          allItems: widget.posts,
          onFiltered: _onSearchFiltered,
          filter: (item, query) {
            final title = item['title']?.toString().toLowerCase() ?? '';
            final author = item['author']?.toString().toLowerCase() ?? '';
            final search = query.toLowerCase();
            return title.contains(search) || author.contains(search);
          },
        ),

        // ✅ 카테고리 필터 탭
        const CategoryTabBar(categories: ['전체', '요청', '수업', '기타']),

        // ✅ 게시글 리스트
        Expanded(
          child: filteredPosts.isEmpty
              ? const Center(child: Text('게시글이 없습니다.'))
              : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: categoryFiltered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final post = categoryFiltered[index];
              final originalIndex = widget.posts.indexOf(post);

              return PostCard(
                author: post['author'] ?? '익명',
                category: post['category'],
                title: post['title'],
                comments: post['comments'] ?? 0,
                createdAt: post['createdAt'] is String
                    ? DateTime.parse(post['createdAt'])
                    : post['createdAt'] as DateTime,
                content: post['content'],
                onCommentChanged: (newCount) => widget.updateComments(originalIndex, newCount),
              );
            },
          ),
        ),
      ],
    );
  }
}
