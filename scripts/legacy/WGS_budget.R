# R code to estimate sequencing budget for whole genome re-sequencing projects
# M. Clark 12/5/2023
# prices based on MSU Genomics Core 12/5/2023 using 150 PE sequencing on NovaSeq S4 flowcell
# uses both full flowcells and 1/10 flowcell options

## Define functions----------------------------------------------------------------------------------------------------------
calcBudget <- function(N, genome_size, desired_coverage, QC_loss){
  # this function calcualtes a buget for a WGS resequencing project
  
  # define information for S4 flowcell 
  # **CHECK TO SEE IF PRICES ARE CURRENT** https://rtsf.natsci.msu.edu/genomics/pricing.aspx
  # pe_reads_per_flowcell <- 2250 *1000000 
  bp_per_flowcell <- 675
  S4_flowcell_cost <- 5953
  S4_tenth_flowcell_cost <- 694 
  
  # convert genome size in Gbp to bp 
  #genome_size <- 1000000000 * genome_size_gbp
  
  # define cost of library prep
  # **CHECK TO SEE IF PRICES ARE CURRENT** https://rtsf.natsci.msu.edu/genomics/pricing.aspx
  if (N < 12){
    lib_cost <- 93
  }else if(N < 47){
    lib_cost <- 81
  }else if(N >= 47){
    lib_cost <- 74
  }else{
    print(paste0("error, no library cost know for N of ", N))
  }
  
  # calculate library cost
  lib_prep_cost <- N * lib_cost
  
  # calculate the individuals you can sequence on a single flowcell
  inds_per_flowcell <- bp_per_flowcell / (genome_size * desired_coverage * (1+QC_loss))
  
  # calculate the number of flowcells required for the project
  required_flowcells <- N / inds_per_flowcell
  
  # how many full flowcells will we fill?
  no_full_flowcells <- required_flowcells %/% 1
  
  # use tenth of flowcells for the remainder
  remainder <- required_flowcells %% 1
  no_tenth_flowcells <- ceiling(remainder / 0.1)
  
  # cheaper to use 1/10 flowcells or just round up? 
  rounded_seq_cost <- S4_flowcell_cost * ceiling(required_flowcells)
  tenths_seq_cost <- (no_full_flowcells*S4_flowcell_cost) + (no_tenth_flowcells*S4_tenth_flowcell_cost)
  
  if(rounded_seq_cost < tenths_seq_cost){
    budget <- rounded_seq_cost + lib_prep_cost
    list <- list(budget, ceiling(required_flowcells), 0)
  }else if(tenths_seq_cost < rounded_seq_cost){
    budget <- tenths_seq_cost + lib_prep_cost
    list <- list(budget, no_full_flowcells, no_tenth_flowcells)
  }
  
  return(list) 
}

makeBudget <- function(genome_size, desired_coverage, funds, low_ind_no = 1, high_ind_no = 100, QC_loss = 0.2){
  # this function plots budget informaiton for a range of individuals, and returns a plot show the max. number of individuals you can sequence
  money <- vector(length = length(low_ind_no:high_ind_no))
  full_cells <- vector(length = length(low_ind_no:high_ind_no))
  tenth_cells <- vector(length = length(low_ind_no:high_ind_no))
  
  j = 1
  for(i in low_ind_no:high_ind_no){
    list <- calcBudget(i, 1.52, desired_coverage, QC_loss = QC_loss)
    money[j] <- list[[1]]
    full_cells[j] <- list[[2]]
    tenth_cells[j] <- list[[3]]
    j <- j + 1
  }
  
  plot(low_ind_no:high_ind_no, money, xlab = "number of sequenced individuals", ylab = "cost", type = "l", 
       main=paste0(genome_size, " Gbp genome sequenced at ", desired_coverage, "X coverage"))
  abline(h = funds, col = "green", lty = 2)
  abline(v = low_ind_no + max(which(money < funds)), col = "blue")
  mtext(paste0("sequence ", (low_ind_no-1) + max(which(money < funds)), " inds for $", money[max(which(money < funds))], 
               " on ", full_cells[max(which(money < funds))], " full flow cells and ", tenth_cells[max(which(money < funds))], " tenth flowcells"))
}

## ----------------------------------------------------------------------------------------------------------

## Make budget----------------------------------------------------------------------------------------------------------
pdf("./EMR_budget_20X.pdf", width = 6, height = 6)
makeBudget(genome_size = 1.52, desired_coverage = 20, funds = 33000, QC_loss = 0.2, high_ind_no = 200)
dev.off()
## ----------------------------------------------------------------------------------------------------------
33000 - calcBudget(55, 1.52, desired_coverage = 20, QC_loss = 0.2)[[1]]

makeBudget(genome_size = 1.52, desired_coverage = 8, funds = 11071, QC_loss = 0.2, high_ind_no = 200)


makeBudget(genome_size = 1.52, desired_coverage = 15, funds = 33000, QC_loss = 0.2, high_ind_no = 200)

makeBudget(genome_size = 1.52, desired_coverage = 20, funds = 33000, QC_loss = 0.2, high_ind_no = 100)


# variance in distribution of coal. events = 1/ n^2
#18-20 ind per site, 8-10X



UM_nova_price <- 15597
UM_nova_reads <- 25 * 1000000000

UM_bp <- UM_nova_reads * 150 *2

UM_bp/((1000000000 * 1.52)*20 * 1.3) # 98 individuals sequenced for $26,279.00

calcBudget(98, 1.52, desired_coverage = 20, QC_loss = 0)[[1]] # $34534 at MSU
