<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use App\Models\News;

class NewsController extends Controller
{
    private function newsDisk(): string
    {
        return config('filesystems.default', 'public');
    }

    private function detectCategory(array $data): string
    {
        $haystack = Str::lower(implode(' ', array_filter([
            $data['title'] ?? '',
            $data['content'] ?? '',
            $data['description'] ?? '',
            $data['source'] ?? '',
        ])));

        $keywords = [
            'سياسة' => ['سياس', 'حكومة', 'برلمان', 'رئيس', 'اتفاق', 'انتخاب', 'وزير', 'دولة', 'سلام'],
            'رياضة' => ['رياض', 'مباراة', 'كرة', 'هدف', 'دوري', 'كأس', 'لاعب', 'بي إن سبورتس'],
            'اقتصاد' => ['اقتص', 'دولار', 'بورصة', 'سوق', 'تضخم', 'استثمار', 'بلومبرج', 'نفط'],
            'تكنولوجيا' => ['تقني', 'هاتف', 'ذكاء', 'تطبيق', 'انترنت', 'رقمي', 'وايرد', 'تك كرانش'],
            'ثقافة' => ['ثقاف', 'كتاب', 'فن', 'سينما', 'مسرح', 'مؤتمر', 'معرض'],
        ];

        foreach ($keywords as $category => $terms) {
            foreach ($terms as $term) {
                if (Str::contains($haystack, Str::lower($term))) {
                    return $category;
                }
            }
        }

        return 'عالمي';
    }

    private function newsValidationRules(): array
    {
        return [
            'title' => 'required|string|max:255',
            'content' => 'required|string',
            'category' => 'required|in:' . implode(',', News::CATEGORIES),
            'image' => 'nullable|image|mimes:jpeg,png,jpg|max:5120',
        ];
    }

    public function create()
    {
        return view('news-create', [
            'categories' => News::CATEGORIES,
        ]);
    }

    public function index(Request $request)
    {
        $query = News::with('user')->latest();

        if ($request->filled('category')) {
            $query->where('category', $request->category);
        }

        $news = $query->paginate(9);
        $stats = News::selectRaw('category, COUNT(*) as total')
            ->groupBy('category')
            ->pluck('total', 'category');

        return view('news-list', [
            'news' => $news,
            'categories' => News::CATEGORIES,
            'selectedCategory' => $request->string('category')->toString(),
            'stats' => $stats,
        ]);
    }

    public function store(Request $request)
    {
        $request->validate($this->newsValidationRules());

        $data = $request->all();
        if ($request->hasFile('image')) {
            $data['image'] = $request->file('image')->store('news', $this->newsDisk());
        }

        $data['user_id'] = Auth::id() ?? 1;
        News::create($data);

        return redirect('/')->with('success', '✅ تم نشر الخبر بنجاح! شكراً لك');
    }

    public function show(News $news)
    {
        $news->load('user');
        return view('news-show', compact('news'));
    }

    public function edit(News $news)
    {
        if (Auth::id() != $news->user_id && !(Auth::user()?->is_admin)) {
            abort(403, 'غير مصرح لك');
        }

        return view('news-edit', [
            'news' => $news,
            'categories' => News::CATEGORIES,
        ]);
    }

    public function update(Request $request, News $news)
    {
        if (Auth::id() != $news->user_id && !(Auth::user()?->is_admin)) {
            abort(403, 'غير مصرح لك');
        }

        $request->validate($this->newsValidationRules());

        $data = $request->all();

        if ($request->hasFile('image')) {
            if ($news->image) {
                Storage::disk($this->newsDisk())->delete($news->image);
            }
            $data['image'] = $request->file('image')->store('news', $this->newsDisk());
        }

        $news->update($data);

        return redirect()->route('news.index')->with('success', '✅ تم تحديث الخبر بنجاح!');
    }

    public function scrape(Request $request)
    {
        try {
            $newsData = $request->input('news', []);
            $savedCount = 0;
            $errors = [];

            foreach ($newsData as $data) {
                try {
                    $title = trim($data['title'] ?? '');
                    if (empty($title)) continue;

                    $exists = News::whereRaw('LOWER(title) LIKE ?', ['%' . strtolower($title) . '%'])
                                 ->where('is_scraped', true)
                                 ->where('created_at', '>', now()->subHour())
                                 ->exists();

                    if (!$exists) {
                        News::create([
                            'title' => $title,
                            'content' => Str::limit($data['content'] ?? $data['description'] ?? 'لا يوجد ملخص متاح لهذا الخبر حالياً.', 500),
                            'category' => $this->detectCategory($data),
                            'source' => $data['source'] ?? 'Web Scraping',
                            'link' => $data['link'] ?? $data['url'] ?? '',
                            'is_scraped' => true,
                            'user_id' => null,
                        ]);
                        $savedCount++;
                    }
                } catch (\Exception $e) {
                    $errors[] = $e->getMessage();
                }
            }

            return response()->json([
                'success' => true,
                'saved_count' => $savedCount,
                'total_processed' => count($newsData),
                'errors' => $errors,
                'message' => "تم معالجة {$savedCount} خبر جديد بنجاح"
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => $e->getMessage(),
                'message' => 'خطأ في الخادم'
            ], 500);
        }
    }

    public function destroy(News $news)
    {
        if (Auth::id() && Auth::id() == $news->user_id || Auth::user()?->is_admin) {
            if ($news->image) {
                Storage::disk($this->newsDisk())->delete($news->image);
            }
            $news->delete();
            return redirect()->back()->with('success', '✅ تم حذف الخبر بنجاح!');
        }
        return redirect()->back()->with('error', '❌ ليس لديك صلاحية الحذف');
    }
}
