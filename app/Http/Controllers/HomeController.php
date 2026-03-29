<?php

namespace App\Http\Controllers;

use App\Models\News;

class HomeController extends Controller
{
    public function index()
    {
        $globalNews = News::scrapedNews();
        $featuredNews = News::with('user')
            ->where('is_scraped', false)
            ->latest()
            ->take(6)
            ->get();

        return view('home', compact('globalNews', 'featuredNews'));
    }
}
