<?php

namespace Tests\Feature;

use App\Models\JournalistGroup;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class JournalistGroupTest extends TestCase
{
    use RefreshDatabase;

    public function test_authenticated_user_can_create_a_journalist_group(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user)->post(route('journalist-groups.store'), [
            'name' => 'صحفيو العاصمة',
            'description' => 'كروب خاص لتبادل الأخبار الموثقة',
            'password' => 'secret123',
            'password_confirmation' => 'secret123',
        ]);

        $response->assertRedirect(route('profile'));

        $this->assertDatabaseHas('journalist_groups', [
            'name' => 'صحفيو العاصمة',
            'owner_id' => $user->id,
        ]);
    }

    public function test_authenticated_user_can_join_group_with_correct_password(): void
    {
        $owner = User::factory()->create();
        $member = User::factory()->create();

        $group = JournalistGroup::create([
            'name' => 'صحفيو التقنية',
            'description' => 'كل ما يخص أخبار التقنية',
            'password' => bcrypt('join1234'),
            'owner_id' => $owner->id,
        ]);

        $response = $this->actingAs($member)->post(route('journalist-groups.join'), [
            'group_id' => $group->id,
            'password' => 'join1234',
        ]);

        $response->assertRedirect(route('profile'));
        $this->assertDatabaseHas('journalist_group_user', [
            'journalist_group_id' => $group->id,
            'user_id' => $member->id,
        ]);
    }
}
