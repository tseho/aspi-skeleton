<?php

declare(strict_types=1);

namespace App\Infrastructure\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

class HelloAction
{
    public function __invoke(Request $request): Response
    {
        return new Response('Hello');
    }
}
