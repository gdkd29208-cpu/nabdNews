<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>وسائل التواصل الاجتماعي - نبض نيوز</title>
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
            --success: linear-gradient(135deg, #10b981 0%, #059669 100%);
            --bg-primary: #1e293b;
            --bg-secondary: #f1f5f9;
            --text-primary: #1e293b;
            --text-secondary: #64748b;
            --shadow: 0 10px 30px rgba(0,0,0,0.1);
            --border-radius: 20px;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Cairo', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            min-height: 100vh;
            color: var(--text-primary);
        }

        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 2rem;
        }

        .hero {
            text-align: center;
            color: white;
            padding: 4rem 2rem;
            margin-bottom: 4rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
        }

        .hero h1 {
            font-size: clamp(2.5rem, 6vw, 4rem);
            font-weight: 800;
            margin-bottom: 1rem;
            background: linear-gradient(135deg, white, rgba(255,255,255,0.8));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .hero p {
            font-size: 1.3rem;
            opacity: 0.95;
            max-width: 600px;
            margin: 0 auto;
        }

        .social-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
        }

        .social-card {
            background: rgba(255,255,255,0.95);
            border-radius: var(--border-radius);
            padding: 2.5rem;
            text-align: center;
            box-shadow: var(--shadow);
            transition: var(--transition);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.2);
        }

        .social-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 25px 50px rgba(0,0,0,0.15);
        }

        .social-icon {
            font-size: 4rem;
            margin-bottom: 1.5rem;
        }

        .social-card h3 {
            font-size: 1.5rem;
            margin-bottom: 1rem;
            color: var(--text-primary);
        }

        .social-card p {
            color: var(--text-secondary);
            line-height: 1.7;
            margin-bottom: 2rem;
        }

        .social-btn {
            background: var(--primary);
            color: white;
            padding: 1rem 2rem;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.8rem;
            transition: var(--transition);
            box-shadow: 0 8px 25px rgba(59,130,246,0.3);
        }

        .social-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(59,130,246,0.4);
        }

        .back-btn {
            display: inline-block;
            margin-top: 3rem;
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 1rem 2rem;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 600;
            transition: var(--transition);
            backdrop-filter: blur(10px);
        }

        .back-btn:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-2px);
        }

        @media (max-width: 768px) {
            .social-grid {
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="hero">
            <h1><i class="fas fa-share-alt"></i> تواصلوا معنا</h1>
            <p>تابعونا على وسائل التواصل الاجتماعي للحصول على آخر الأخبار لحظة بلحظة</p>
        </div>

        <div class="social-grid">
            <div class="social-card">
                <div class="social-icon" style="color: #1877F2;">
                    <i class="fab fa-facebook-f"></i>
                </div>
                <h3>فيسبوك</h3>
                <p>انضموا لصفحتنا على فيسبوك لمتابعة الأخبار والمنشورات الحصرية والتحديثات اليومية</p>
                <a href="https://facebook.com" class="social-btn" target="_blank">
                    <i class="fab fa-facebook-f"></i>
                    تابعونا على فيسبوك
                </a>
            </div>

            <div class="social-card">
                <div class="social-icon" style="color: #1DA1F2;">
                    <i class="fab fa-x-twitter"></i>
                </div>
                <h3>X (تويتر)</h3>
                <p>أسرع تحديثات الأخبار والأحداث الراهنة مع هاشتاقات حصرية وتغطية مباشرة</p>
                <a href="https://x.com" class="social-btn" target="_blank">
                    <i class="fab fa-x-twitter"></i>
                    تابعونا على X
                </a>
            </div>

            <div class="social-card">
                <div class="social-icon" style="color: #E4405F;">
                    <i class="fab fa-instagram"></i>
                </div>
                <h3>إنستجرام</h3>
                <p>صور وفيديوهات أخبارية حصرية مع ستوريز يومية وإنفوجرافيكس جذابة</p>
                <a href="https://instagram.com" class="social-btn" target="_blank">
                    <i class="fab fa-instagram"></i>
                    تابعونا على إنستجرام
                </a>
            </div>

            <div class="social-card">
                <div class="social-icon" style="color: #FF0000;">
                    <i class="fab fa-youtube"></i>
                </div>
                <h3>يوتيوب</h3>
                <p>تقارير مصورة وتحليلات وفيديوهات أخبارية معمقة مع تغطية مباشرة للأحداث</p>
                <a href="https://youtube.com" class="social-btn" target="_blank">
                    <i class="fab fa-youtube"></i>
                    اشترك في القناة
                </a>
            </div>

            <div class="social-card">
                <div class="social-icon" style="color: #0088CC;">
                    <i class="fab fa-telegram"></i>
                </div>
                <h3>تليجرام</h3>
                <p>قناة تليجرام للإشعارات الفورية والأخبار السريعة بدون إعلانات</p>
                <a href="https://t.me" class="social-btn" target="_blank">
                    <i class="fab fa-telegram"></i>
                    انضموا للقناة
                </a>
            </div>
        </div>

        <div style="text-align: center; margin-top: 4rem;">
            <a href="/" class="back-btn">
                <i class="fas fa-arrow-right"></i>
                العودة للرئيسية
            </a>
        </div>
    </div>
</body>
</html>
