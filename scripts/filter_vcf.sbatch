# filter_vcf

# filter VCF to contain SNPs that are not in deletions, pass quality filtering etc. 



VCF='/mnt/home/clarkm89/petrels/called_snps/annotated_vcf/mel_norm_annotated.vcf.gz'
EXCLUDE='/mnt/home/clarkm89/petrels/filtering/masks/$mel_snps_in_deletions.pos' 
OUTPOS='/mnt/home/clarkm89/petrels/called_snps/annotated_vcf/mel_norm_annotated_qc_indel_mult.pos'
bcftools view -H -f "PASS" -i 'N_PASS(GT[4,5,6,7,8,9,10,11]!="mis" & FMT/DP > 6) >= 6 && N_PASS(GT[0,1,2,3]!="mis" & FMT/DP > 6) >= 3' $VCF | perl -ne  '@tok = split(/\s+/,$_); if ($tok[7] =~ /REPGQ=(\d+),(\d+)/) {print "$tok[0]\t$tok[1]\n" if ($1 >= 6 && $2 >= 3);} else {print "$tok[0]\t$tok[1]\n";}' | uniq > $OUTPOS

