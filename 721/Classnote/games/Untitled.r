install.packages("gganimate")
install.packages("gapminder")
library(ggplot2)
library(gganimate)
library(gapminder)
library(gifski)  # make sure it's attached so the renderer is available

# 1) Rebuild the animated object (should have class "gganim")
p <- ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, color = continent)) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  scale_x_log10() +
  labs(title = "Year: {frame_time}", x = "GDP per Capita (log)", y = "Life Expectancy") +
  theme_minimal()

animated_plot <- p + transition_time(year) + ease_aes("linear")

# sanity check
class(animated_plot)
# expect: "gganim"

# 2) Render explicitly with a renderer (creates an "animation" object)
anim <- animate(
  animated_plot,
  renderer = gifski_renderer(loop = TRUE),
  fps = 20, width = 700, height = 500
)

# 3) Save using the rendered object
anim_save("gapminder_animation.gif", animation = anim)