if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(version = "3.14")

BiocManager::install("phyloseq") # Install phyloseq

install.packages(c("RColorBrewer", "patchwork"))

library("phyloseq")
library("ggplot2")
library("RColorBrewer")
library("patchwork")

setwd("~/camda2024/gut/taxonomy/")

merged_metagenomes <- import_biom("cuatroc.biom")

class(merged_metagenomes)

View(merged_metagenomes@tax_table@.Data)

merged_metagenomes@tax_table@.Data <- substring(merged_metagenomes@tax_table@.Data, 4)
colnames(merged_metagenomes@tax_table@.Data)<- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")

unique(merged_metagenomes@tax_table@.Data[,"Phylum"])

sum(merged_metagenomes@tax_table@.Data[,"Phylum"] == "Firmicutes")

unique(merged_metagenomes@tax_table@.Data[merged_metagenomes@tax_table@.Data[,"Phylum"] == "Firmicutes", "Class"])

View(merged_metagenomes@otu_table@.Data)

sum(merged_metagenomes@tax_table@.Data[,"Phylum"] == "Proteobacteria")

merged_metagenomes <- subset_taxa(merged_metagenomes, Kingdom == "Bacteria")

merged_metagenomes

sample_sums(merged_metagenomes)

summary(merged_metagenomes@otu_table@.Data)

plot_richness(physeq = merged_metagenomes, 
              measures = c("Observed","Chao1","Shannon")) 

plot_richness(physeq = merged_metagenomes, 
              title = "Alpha diversity indexes for 100 samples of gut metagenome",
              measures = c("Observed","Chao1","Shannon"))

plot_richness(physeq = merged_metagenomes, 
              measures = c("Observed","Chao1","Shannon"),
              sortby = "Shannon") 

plot_richness(physeq = merged_metagenomes,
              measures = c("Observed","Chao1","Shannon"),
              nrow=3)

  summary(merged_metagenomes@tax_table@.Data== "")

merged_metagenomes <- subset_taxa(merged_metagenomes, Genus != "")

summary(merged_metagenomes@tax_table@.Data== "")

head(merged_metagenomes@otu_table@.Data)

percentages <- transform_sample_counts(merged_metagenomes, function(x) x*100 / sum(x) )

head(percentages@otu_table@.Data)

distanceMethodList

meta_ord <- ordinate(physeq = percentages, method = "NMDS", 
                     distance = "bray")

plot_ordination(physeq = percentages, ordination = meta_ord)

percentages_glom <- tax_glom(percentages, taxrank = 'Phylum')

View(percentages_glom@tax_table@.Data)

percentages_df <- psmelt(percentages_glom)
str(percentages_df)

absolute_glom <- tax_glom(physeq = merged_metagenomes, taxrank = "Phylum")
absolute_df <- psmelt(absolute_glom)
str(absolute_df)

absolute_df$Phylum <- as.factor(absolute_df$Phylum)
phylum_colors_abs<- colorRampPalette(brewer.pal(8,"Dark2")) (length(levels(absolute_df$Phylum)))

absolute_plot <- ggplot(data= absolute_df, aes(x=Sample, y=Abundance, fill=Phylum))+ 
  geom_bar(aes(), stat="identity", position="stack")+
  scale_fill_manual(values = phylum_colors_abs)

absolute_plot
percentages_df$Phylum <- as.factor(percentages_df$Phylum)
phylum_colors_rel<- colorRampPalette(brewer.pal(8,"Dark2")) (length(levels(percentages_df$Phylum)))
relative_plot <- ggplot(data=percentages_df, aes(x=Sample, angle = 90, y=Abundance, fill=Phylum))+ 
  geom_bar(aes(), stat="identity", position="stack")+
  scale_fill_manual(values = phylum_colors_rel)
 qrelative_plot
 percentages_df$Phylum <- as.character(percentages_df$Phylum) # Return the Phylum column to be of type character
 percentages_df$Phylum[percentages_df$Abundance < 0.5] <- "Phyla < 0.5% abund."
 unique(percentages_df$Phylum)
 
 percentages_df$Phylum <- as.factor(percentages_df$Phylum)
 phylum_colors_rel<- colorRampPalette(brewer.pal(8,"Dark2")) (length(levels(percentages_df$Phylum)))
 
 phylum_colors_rel<- colorRampPalette(brewer.pal(8,"Dark2")) (length(levels(percentages_df$Phylum)))
 
 absolute_plot <- ggplot(data= absolute_df, aes(x=Sample, y=Abundance, fill=Phylum))+ 
   geom_bar(aes(), stat="identity", position="stack")+
   scale_fill_manual(values = phylum_colors_abs)
 
 relative_plot <- ggplot(data=percentages_df, aes(x=Sample, y=Abundance, fill=Phylum))+ 
   geom_bar(aes(), stat="identity", position="stack")+
   scale_fill_manual(values = phylum_colors_rel)
 absolute_plot | relative_plot
 cyanos <- subset_taxa(merged_metagenomes, Phylum == "Cyanobacteria")
 unique(cyanos@tax_table@.Data[,2])

 cyanos_percentages <- transform_sample_counts(cyanos, function(x) x*100 / sum(x) )
 cyanos_glom <- tax_glom(cyanos_percentages, taxrank = "Genus")
 cyanos_df <- psmelt(cyanos_glom)
 cyanos_df$Genus[cyanos_df$Abundance < 10] <- "Genera < 10.0 abund"
 cyanos_df$Genus <- as.factor(cyanos_df$Genus)
 genus_colors_cyanos<- colorRampPalette(brewer.pal(8,"Dark2")) (length(levels(cyanos_df$Genus)))  
plot_cyanos <- ggplot(data=cyanos_df, aes(x=Sample, y=Abundance, fill=Genus))+ 
   geom_bar(aes(), stat="identity", position="stack")+
   scale_fill_manual(values = genus_colors_cyanos)
plot_cyanos
 