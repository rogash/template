<?php

/**
 * Arquivo de exemplo para testar as ferramentas de qualidade
 * Este arquivo demonstra boas práticas de código
 */

declare(strict_types=1);

namespace Template\Scripts;

/**
 * Classe de exemplo para demonstração
 */
class Example
{
    private string $name;
    private int $value;

    public function __construct(string $name, int $value)
    {
        $this->name = $name;
        $this->value = $value;
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function getValue(): int
    {
        return $this->value;
    }

    public function setValue(int $value): void
    {
        $this->value = $value;
    }

    public function calculate(int $multiplier): int
    {
        return $this->value * $multiplier;
    }
}
