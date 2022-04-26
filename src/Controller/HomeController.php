<?php
declare(strict_types=1);

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use function Symfony\Component\String\u;

class HomeController extends AbstractController
{
    #[Route('/')]
    public function homepage(): Response
    {
        return $this->render('home/homepage.html.twig');
    }

    #[Route('/browse/{slug}')]
    public function browse(string $slug = null): Response
    {
        if ($slug !== null) {
            $title = 'Genre: ' . u(str_replace('-', ' ', $slug))->title(true);
        } else {
            $title = 'All Genres';
        }

        return new Response($title);
    }
}