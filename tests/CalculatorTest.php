<?php
declare(strict_types=1);

namespace Tests;

use App\Calculator;
use InvalidArgumentException;
use PHPUnit\Framework\TestCase;

class CalculatorTest extends TestCase
{
    public function testAdd(): void
    {
        $calculator = new Calculator();

        self::assertEquals(5, $calculator->add(2, 3));
    }

    public function testSubtract(): void
    {
        $calculator = new Calculator();

        self::assertEquals(-1, $calculator->subtract(2, 3));
    }

    public function testMultiply(): void
    {
        $calculator = new Calculator();

        self::assertEquals(6, $calculator->multiply(2, 3));
    }

    public function testDivide(): void
    {
        $calculator = new Calculator();

        self::assertEquals(0.67, $calculator->divide(2, 3));
    }

    public function testDivideByZero(): void
    {
        $calculator = new Calculator();

        self::expectException(InvalidArgumentException::class);
        self::expectExceptionMessage('Division by zero.');

        self::assertEquals(0.67, $calculator->divide(2, 0));
    }
}