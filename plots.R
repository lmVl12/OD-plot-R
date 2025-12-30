# ==============================================================================
# ФІНАЛЬНИЙ НАУКОВИЙ КОД (Індекси на осях та чіткі точки)
# ==============================================================================

library(readxl)
library(ggplot2)
library(tidyr)
library(dplyr)
library(stringr)

# 1. НАЛАШТУВАННЯ
path <- "C:/Users/LV/OneDrive/plots.xlsx" 
current_sheet <- "plot3" 

col_names <- colnames(read_excel(path, sheet = current_sheet, n_max = 0))
raw_data <- read_excel(path, sheet = current_sheet)

# Витягуємо підписи (2-й рядок Excel)
labels_dict <- as.character(raw_data[1, ])
names(labels_dict) <- col_names

# Видаляємо текстовий рядок, залишаємо цифри
data <- raw_data[-1, ]

# 2. РОЗРАХУНОК CUT-OFF
neg_cols <- col_names[str_detect(col_names, "Neg")]
neg_values <- data %>%
  select(all_of(neg_cols)) %>%
  unlist() %>% 
  as.character() %>%
  str_replace(",", ".") %>% 
  as.numeric() %>%
  na.omit()

cutoff_val <- (2 * mean(neg_values)) + (3 * sd(neg_values))
cutoff_label <- paste0("Cut-off (", round(cutoff_val, 3), ")")

# 3. ПІДГОТОВКА ДАНИХ
original_order <- col_names[str_detect(col_names, "Pos|Neg")]

data_long <- data %>%
  select(all_of(original_order)) %>% 
  pivot_longer(cols = everything(), names_to = "Group", values_to = "Value") %>%
  mutate(
    Value = as.character(Value) %>% str_replace(",", ".") %>% as.numeric(),
    Type = ifelse(str_detect(Group, "Pos"), "Positive", "Negative"),
    Group = factor(Group, levels = original_order)
  ) %>%
  filter(!is.na(Value))

# 4. ПОБУДОВА ГРАФІКА
plot <- ggplot(data_long, aes(x = Group, y = Value)) +
  stat_boxplot(geom = "errorbar", width = 0.2, color = "black") + 
  
  # Боксплот: Pos - жовтий, Neg - блакитний
  geom_boxplot(aes(fill = Type), color = "black", alpha = 0.8, width = 0.6, lwd = 0.6, fatten =0.6, outlier.shape = NA) +
  
  # ЧІТКІ ЧОРНІ ТОЧКИ: alpha=0.8 робить їх майже непрозорими, size=1.8 - більшими
  geom_jitter(width = 0.12, size = 1.8, color = "black", alpha = 0.5) +
  
  # Лінія Cut-off
  geom_hline(aes(yintercept = cutoff_val, linetype = cutoff_label), 
             color = "red", linewidth = 0.8) +
  
  scale_fill_manual(values = c("Positive" = "#FF9966", "Negative" = "#87CEEB")) +
  scale_x_discrete(labels = labels_dict) +
  scale_linetype_manual(name = NULL, values = "dashed") + 
  
  theme_bw() +
  labs(
    title = paste("Immunoenzymatic activity,", current_sheet),
    x = "Protein fractions", 
    # НАУКОВИЙ ПІДПИС З ІНДЕКСАМИ (OD 450/655)
    y = expression(bold(OD["450/655"]))
  ) +
  
  guides(fill = "none") + 
  theme(
    axis.text.x = element_text(vjust = 0.5, size = 10, face = "bold"),
    axis.title.y = element_text(size = 11),
    
    legend.position = c(0.88, 0.95), 
    legend.background = element_rect(fill = NA, color = NA),
    legend.key = element_blank(),
    legend.text = element_text(size = 9, face = "bold", color = "black"),
    
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    plot.title = element_text(hjust = 0.5, face = "bold")
  )

# 5. ВІДОБРАЖЕННЯ
print(plot)
# 6. ЗБЕРЕЖЕННЯ (необов'язково, розкоментуй за потреби)
 ggsave(paste0(current_sheet, "_plot.png"), width = 18, height = 12, units = "cm", dpi = 300)