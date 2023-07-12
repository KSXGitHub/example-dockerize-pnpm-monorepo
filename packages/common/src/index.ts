const fib = (n: number): number => n > 1 ? fib(n - 1) + fib(n - 2) : n

export function fibonacci(n: number): number {
  if (Math.floor(n) !== n) {
    throw new RangeError('Float not supported: ' + n)
  }
  return fib(n)
}
