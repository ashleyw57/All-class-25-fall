simulate_multinomial <- function(n, probs) {
  k <- length(probs)
  counts <- integer(k)
  for (t in 1:n) {
    rem <- 1
    placed <- FALSE
    for (j in 1:(k-1)) {
      if (rbinom(1, 1, probs[j] / rem) == 1) {
        counts[j] <- counts[j] + 1
        placed <- TRUE
        break
      } else {
        rem <- rem - probs[j]
      }
    }
    if (!placed) counts[k] <- counts[k] + 1
  }
  counts
}

# Example: 10 trials, probs (0.2, 0.5, 0.3)
set.seed(1)
simulate_multinomial(10, c(0.2, 0.5, 0.3))
